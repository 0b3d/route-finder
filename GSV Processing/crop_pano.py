import numpy as np
import os, sys
import cv2
import Equirec2Perspec as E2P

def crop_pano(pano):
    # Crop gsv 
    zoom = int(np.ceil(pano.shape[0] / 512))
    snaps = []
    if  pano.shape[0] < 512*np.power(2,zoom-1):
        panowidth = 416 * np.power(2,zoom)
        panoheight = 416 * np.power(2,zoom-1)
        pano = pano[0:panoheight,0:panowidth,:]                
    equ = E2P.Equirectangular(pano)

    for i,tetha in enumerate([0,-90,90,180]):
        snap = equ.GetPerspective(100, tetha, 0, 256, 256)  
        snaps.append(snap) # Must have shape [1, 224,224,3]
    
    return snaps 


if __name__ == '__main__':
    path = os.path.join(os.getcwd(), 'Data',sys.argv[1], 'panos', sys.argv[2])
    pano = cv2.imread(path)
    snaps = crop_pano(pano)
