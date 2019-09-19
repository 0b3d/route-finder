import numpy as np
import os, sys
import cv2
import Equirec2Perspec as E2P
from scipy.io import loadmat
import time

def crop_pano(pano, yaw_diff):
    # Crop gsv 
    zoom = int(np.ceil(pano.shape[0] / 512))
    snaps = []
    if  pano.shape[0] < 512*np.power(2,zoom-1):
        panowidth = 416 * np.power(2,zoom)
        panoheight = 416 * np.power(2,zoom-1)
        pano = pano[0:panoheight,0:panowidth,:]                
    equ = E2P.Equirectangular(pano)

    for i,tetha in enumerate(yaw_diff):
        snap = equ.GetPerspective(100, tetha, 0, 227, 227)  
        snaps.append(snap) # Must have shape [1, 224,224,3]
    
    return snaps 

start = time.clock()
if __name__ == '__main__':
    # path = os.path.join(os.getcwd(), 'Data',sys.argv[1], 'panos', sys.argv[2])
    directory = os.getcwd()
    snaps_directory = os.path.join(directory, 'Data', 'snaps_yaw') 
    if not os.path.isdir(snaps_directory):
         os.mkdir(snaps_directory)

    # Open matlab file
    # routes_file = os.path.join(os.getcwd(), 'Data', sys.argv[1], 'routes_small.mat')
    routes_file = os.path.join(os.getcwd(), 'Data', 'routes_small.mat')
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
    yaw_diffs = []
    for i in range(routes.shape[0]):
        pano_id = routes[i][4].squeeze()
        pano_ids.append(str(pano_id))

        yaw = routes[i][1].squeeze()
        gsv_yaw = routes[i][6].squeeze()
        yaw_diff = gsv_yaw - yaw
        yaw_diff = abs(yaw_diff)
        yaw_diff = [0,-90,90,180] + yaw_diff
        yaw_diffs.append(yaw_diff)

    for k, pano_id in enumerate(pano_ids):
        path = os.path.join(os.getcwd(), 'Data', 'panos', pano_id + '.jpg')
        pano = cv2.imread(path)
        yaw_diff = yaw_diffs[k]
        snaps = crop_pano(pano, yaw_diff)
        filename = os.path.join(snaps_directory,  pano_id + '.jpg') 
        filename_f = os.path.join(snaps_directory, pano_id + '_front.jpg')
        cv2.imwrite(filename_f, snaps[0]) 
        filename_l = os.path.join(snaps_directory, pano_id + '_left.jpg')
        cv2.imwrite(filename_l, snaps[1]) 
        filename_r = os.path.join(snaps_directory, pano_id + '_right.jpg')
        cv2.imwrite(filename_r, snaps[2]) 
        filename_b = os.path.join(snaps_directory, pano_id + '_back.jpg')
        cv2.imwrite(filename_b, snaps[3])    
        msg = filename + " saved"
        print(pano_id, msg)
        # for visualization
        # snaps = np.concatenate(snaps, axis=1)
        # cv2.imshow('snaps', snaps)
        # cv2.waitKey(0)
        # if k == 10:
        #    break

elapsed = (time.clock() - start)
print(elapsed)
print("All finished")