def get_intersections(children, road_types):
    """
    This method reads the passed osm file (xml) and finds intersections (i.e., nodes that are shared by two or more roads).

    (derived from a Stack Overflow post by Kotaro)
    """
    intersection_coordinates = []
    counter = {}
    inters_num = 0
    
    for child in children:
        if child.tag == 'way':
            # Check if the way represents a "highway (road)"
            # If the current way is not a road,
            # continue without checking any nodes
            road = False
            # road types shouln't be included in these types
            # road_types = ('footway', 'steps', 'cycleway')

            for item in child:
                if item.tag == 'tag' and item.attrib['k'] == 'highway' and item.attrib['v'] not in road_types: 
                    road = True

            if not road:
                continue

            for item in child:
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    if not nd_ref in counter:
                        counter[nd_ref] = 0
                    counter[nd_ref] += 1

    # Find nodes that are shared with more than one way, which
    # might correspond to intersections
    # note: filter function is different between python 2 and 3 !
    # python 2:
    # intersections = filter(lambda x: counter[x] > 1,  counter) 
    # python 3:
    intersections_filter = filter(lambda x: counter[x] > 1,  counter) 
    intersections = list(intersections_filter)

    # Extract intersection coordinates
    # You can plot the results using this url:
    # http://www.darrinward.com/lat-long/
    for child in children:
        if child.tag == 'node' and child.attrib['id'] in intersections:
            coordinate = child.attrib['lat'] + ',' + child.attrib['lon']
            inters_num += 1
            intersection_coordinates.append(coordinate)
            
    print('There are', inters_num, 'intersections in this area.')
    return intersection_coordinates