import time
import os
start = time.time()

mapFile = os.path.join(os.getcwd(), 'OSM Files', 'london.osm')
print(mapFile)
input_type = 'file'

data_path = os.path.join(os.getcwd(), 'Data')
if not os.path.isdir(data_path):
	os.mkdir(data_path)

import xml.etree.ElementTree as ET
if input_type == 'file':
    tree = ET.parse(mapFile)
    root = tree.getroot()
    children = root.getchildren()
elif input_type == 'str':
    tree = ET.fromstring(mapFile)
    children = tree.getchildren()

import interOSM
road_types = ('footway', 'steps', 'cycleway', 'service', 'pedestrian', 'path', 'proposed', 'construction')
writeFile = os.path.join(os.getcwd(), 'Data', 'intersections.txt')
f = open(writeFile, 'w')
ic = interOSM.get_intersections(children, road_types)
for coord in ic:
	f.write(coord + '\n')
f.close()

import allWayNodes
writeFile = os.path.join(os.getcwd(), 'Data', 'ways.txt')
f = open(writeFile, 'w')
nc = allWayNodes.allWayNodes(children, road_types)
for coord in nc:
	f.write(coord + '\n')
f.close()

road_types = ('proposed', 'construction', 'steps')
writeFile = os.path.join(os.getcwd(), 'Data', 'intersections_all.txt')
f = open(writeFile, 'w')
ic = interOSM.get_intersections(children, road_types)
for coord in ic:
	f.write(coord + '\n')
f.close()

writeFile = os.path.join(os.getcwd(), 'Data', 'ways_all.txt')
f = open(writeFile, 'w')
nc = allWayNodes.allWayNodes(children, road_types)
for coord in nc:
	f.write(coord + '\n')
f.close()


import allBuildingNodes
writeFile = os.path.join(os.getcwd(), 'Data', 'buildings.txt')
f = open(writeFile, 'w')
nc = allBuildingNodes.allBuildingNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

import allNaturalNodes
writeFile = os.path.join(os.getcwd(), 'Data', 'nature.txt')
f = open(writeFile, 'w')
nc = allNaturalNodes.allNaturalNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

import allLeisureNodes
writeFile = os.path.join(os.getcwd(), 'Data', 'leisure.txt')
f = open(writeFile, 'w')
nc = allLeisureNodes.allLeisureNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

import boundaryOSM
writeFile = os.path.join(os.getcwd(), 'Data', 'boundary.txt')
f = open(writeFile, 'w')
nc = boundaryOSM.get_boundary(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

print('It took', time.time()-start, 'seconds to parse the OSM map.')
