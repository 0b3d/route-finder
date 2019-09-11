import time
start = time.time()

mapFile = 'map.osm'
input_type = 'file'

import xml.etree.ElementTree as ET
if input_type == 'file':
    tree = ET.parse(mapFile)
    root = tree.getroot()
    children = root.getchildren()
elif input_type == 'str':
    tree = ET.fromstring(mapFile)
    children = tree.getchildren()

import interOSM
writeFile = 'intersections.txt'
f = open(writeFile, 'w')
ic = interOSM.get_intersections(children)
for coord in ic:
	f.write(coord + '\n')
f.close()


import allWayNodes
writeFile = 'ways.txt'
f = open(writeFile, 'w')
nc = allWayNodes.allWayNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()


import allBuildingNodes
writeFile = 'buildings.txt'
f = open(writeFile, 'w')
nc = allBuildingNodes.allBuildingNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

import allNaturalNodes
writeFile = 'nature.txt'
f = open(writeFile, 'w')
nc = allNaturalNodes.allNaturalNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

import allLeisureNodes
writeFile = 'leisure.txt'
f = open(writeFile, 'w')
nc = allLeisureNodes.allLeisureNodes(children)
for coord in nc:
	f.write(coord + '\n')
f.close()

import boundaryOSM
writeFile = 'boundary.txt'
f = open(writeFile, 'w')
nc = boundaryOSM.get_boundary(children)
for coord in nc:
	f.write(coord + '\n')
f.close()


print('It took', time.time()-start, 'seconds to parse the OSM map.')
