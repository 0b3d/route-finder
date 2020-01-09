import xml.etree.ElementTree as ET
try:
    from urllib.request import urlopen
except ImportError:
    from urllib2 import urlopen
import multiprocessing
from subprocess import call
import numpy as np
from scipy.io import loadmat
#import tables
import cv2
import os, sys
import h5py

num_threads = 6
counter = 0

class Downloader():
    def __init__(self, zoom):
        self.pano_zoom = zoom
        self.dir = os.getcwd()
    
    def url_to_image(self, url):
        resp = urlopen(url)
        image = np.asarray(bytearray(resp.read()), dtype="uint8")
        image = cv2.imdecode(image, cv2.IMREAD_COLOR)
        return image

    def download_pano(self, pano_id):
        def autocrop(image, threshold=0):
            """Crops any edges below or equal to threshold

            Crops blank image to 1x1.

            Returns cropped image.

            """
            if len(image.shape) == 3:
                flatImage = np.max(image, 2)
            else:
                flatImage = image
            assert len(flatImage.shape) == 2

            rows = np.where(np.max(flatImage, 0) > threshold)[0]
            if rows.size:
                cols = np.where(np.max(flatImage, 1) > threshold)[0]
                image = image[cols[0]: cols[-1] + 1, rows[0]: rows[-1] + 1]
            else:
                image = image[:1, :1]
            return image

        def autocrop2(image):
            panowidth = 416 * np.power(2,self.pano_zoom)
            panoheight = 416 * np.power(2,self.pano_zoom-1)
            pano = image[0:panoheight,0:panowidth,:]
            return pano

        x_range = np.arange(0,np.power(2,self.pano_zoom))
        y_range = np.arange(0,np.power(2,self.pano_zoom-1))

        pano = np.zeros((512*len(y_range), 512*len(x_range), 3), dtype= 'uint8')
        for x in x_range:
            for y in y_range:
                try:
                    tile_url = 'http://maps.google.com/cbk?output=tile&zoom=' + str(self.pano_zoom) + '&x=' +str(x)+ '&y=' + str(y) +'&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=' + pano_id
                    img = self.url_to_image(tile_url)
                    pano[512*y:512*(y+1), 512*x:512*(x+1),...] = img

                except:
                    pano[512*y:512*(y+1), 512*x:512*(x+1),...] = np.zeros((512,512,3), dtype='uint8')

        pano = autocrop(pano)
        if pano.shape[0] < 512*np.power(2,self.pano_zoom-1):
            pano = autocrop2(pano)
        return pano

class RenderThread:
    def __init__(self, save_dir, q, printLock):
        self.save_dir = save_dir
        self.q = q 
        self.printLock = printLock
        self.downloader = Downloader(1)

    def loop(self):
        global counter
        while True:
            # Fetch a tile from the queue and render it
            r = self.q.get()
            if (r == None):
                self.q.task_done()
                break
            else:
                (pano_id) = r

            msg = ""   
            filename = os.path.join(self.save_dir, pano_id + '.jpg') 
            if os.path.isfile(filename):
                msg = "Exists..."    
            else:
                pano = self.downloader.download_pano(pano_id)
                cv2.imwrite(filename, pano)
                msg = filename + " saved"
            counter += 1
        
            print(pano_id, msg)

            self.printLock.acquire()
            self.printLock.release()
            self.q.task_done()

directory = os.getcwd()
# panos_directory = os.path.join(directory, 'Data', sys.argv[1], 'panos') 
panos_directory = os.path.join(directory, 'images', 'london_10_19', 'panos') 
if not os.path.isdir(panos_directory):
    os.makedirs(panos_directory)

# Open matlab file
# routes_file = os.path.join(os.getcwd(), 'Data', sys.argv[1], 'routes_small.mat')
routes_file = os.path.join(os.getcwd(), 'Data', 'london_10_19', 'routes_small.mat')
test = loadmat(routes_file)
routes = test['routes'].squeeze()
# 0 coords
# 1 yaw
# 2 wayidx
# 3 neighbor 
# 4 pano_id 
# 5 gsv_coords 
# 6 gsv_yaw

# Read all the pano_ids to process
pano_ids = []
for i in range(routes.shape[0]):
    pano_id = routes[i][4].squeeze()
    pano_ids.append(str(pano_id))

# Create threads
queue = multiprocessing.JoinableQueue(32)
printLock = multiprocessing.Lock()
renderers = {}
for i in range(num_threads):
    renderer = RenderThread(panos_directory, queue, printLock)
    render_thread = multiprocessing.Process(target=renderer.loop)
    render_thread.start()
    renderers[i] = render_thread

for pano_id in pano_ids:
    t = (pano_id)
    queue.put(t)

print("No more locations ...")
# Signal render threads to exit by sending empty request to queue
for i in range(num_threads):
    queue.put(None)
# wait for pending rendering jobs to complete
queue.join()

for i in range(num_threads):
    renderers[i].join()

print("All finished")