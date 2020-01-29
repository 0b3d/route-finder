import os, sys
import numpy as np 
import pandas as pd

def split_by_latitude(frame, sections=3):
    n = len(frame)
    print("Original number of nodes in this dataset: ", n)
    minLat = frame['lat'].min()
    maxLat = frame['lat'].max()
    delta = (maxLat - minLat) / sections
    bbox = [( minLat + i * delta, minLat + (i+1) * delta) for i in range(0,sections)]
    subframes = [frame[ (frame['lat'] > bbox[i][0]) &  (frame['lat'] < bbox[i][1])] for i in range(0, sections)]
    return subframes, bbox


#---------------------------------------------------------
city = 'manhattan'
datasetPath = os.path.join( os.environ['datasets'] , 'streetlearn')

filename = os.path.join(datasetPath, 'jpegs_' + city + '_2019', 'nodes.txt')
names = ["pano_id","yaw","lat","lon"]
frame = pd.read_csv(filename, names=names)
frame['city'] = city

# # subframes, bbox = split_by_latitude(frame, sections=3) # A list of tuples (min, max)
# for i, df in enumerate(subframes):
#     print(bbox[i])
#     print(i, len(df))

# Latitude range for each split

range1 = (40.701149, 40.717400)
range2 = (40.717400, 40.729400)
range3 = (40.729400, 40.787206)
bbox = [range1, range2, range3]
subframes = [frame[ (frame['lat'] > bbox[i][0]) &  (frame['lat'] < bbox[i][1])] for i in range(0, len(bbox))]

for i, df in enumerate(subframes):
    print(bbox[i])
    print(i, len(df))
    name = os.path.join(datasetPath, 'ny{}.csv'.format(i))
    df.to_csv(name, index=False, header=False) # to save splits

