def allWayNodes(children):
    """
    This method reads the passed osm file (xml) and extracts all highway nodes.

    (derived from a Stack Overflow post by Kotaro)
    """
    node_coordinates = []
    lat = {}
    lon = {}
    roads_num = 0
    roads_with_name = 0
    
    for child in children:
        if child.tag == 'way':
        # Check if the way represents a "highway (road)"
        # If the current way is not a road,
        # continue without checking any nodes
            road = False
            #road_types = ('motorway', 'trunk', 'primary','secondary','tertiary','residential','service',
            #'unclassified','road','footway','path','pedestrain','track','living_street')
            #'motorway_link','trunk_link','primary_link','secondary_link','tertiary_link')
            
            #road_types = ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 
            #'secondary', 'secondary_link', 'tertiary', 'tertiary_link', 'road', 'residential', 'living_street', 'service',
            #'services', 'motorway_junction','unclassified', 'path', 'pedestrian', 'track')
            
            # road types shouldn't be included in these types
            road_types = ('footway', 'steps', 'cycleway', 'service', 'pedestrian', 'path')

            for item in child:
                if item.tag == 'tag' and item.attrib['k'] == 'highway' and item.attrib['v'] not in road_types: 
                    road = True
                    roads_num += 1
                    road_type = item.attrib['v']
                    node_coordinates.append('     ') # blank line between ways
                    node_coordinates.append('way id: ' + child.attrib['id']) # delineate start of new "way" (previously [345,345])

            if not road:
                continue

            oneway = False
            speed = 'undefined'
            numLanes = 'undefined'
            cycleway = 'no'	  
            #name = 'undefined'  
            for item in child:  # must keep in order 
                # Add nodes
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    coordinate = lat[nd_ref] + ',' + lon[nd_ref]
                    node_coordinates.append(coordinate)
                # Check oneway vs. twoway
                if item.tag == 'tag' and item.attrib['k'] == 'oneway' and item.attrib['v'] == 'yes':
                    oneway = True
                # Speed limit
                if item.tag == 'tag' and item.attrib['k'] == 'maxspeed':
                    speed_v = item.attrib['v']
                    speed_end = speed_v.find('mph')
                    if speed_end != -1:
                        speed = speed_v[0:speed_end-1]
                # Number of lanes
                if item.tag == 'tag' and item.attrib['k'] == 'lanes':
                    numLanes = item.attrib['v']
                # Bike path
                if item.tag == 'tag' and item.attrib['k'] == 'cycleway':
                    cycleway = item.attrib['v']
                # Street name
                if item.tag == 'tag' and item.attrib['k'] == 'name':
                    name = item.attrib['v']
                    roads_with_name += 1


            if road_type == 'motorway':
                oneway = True
            if oneway:
                node_coordinates.append('oneway: true')
            else:
                node_coordinates.append('oneway: false')
            node_coordinates.append('road_type: ' + road_type)
            node_coordinates.append('speed: ' + speed)
            node_coordinates.append('lanes: ' + numLanes)
            node_coordinates.append('cycleway: ' + cycleway)
            #node_coordinates.append('name: ' + name)



        elif child.tag == 'node':
        # store lat and lon coordinates
            nd_ref = child.attrib['id']
            lat[nd_ref] = child.attrib['lat']
            lon[nd_ref] = child.attrib['lon']

    print('There are', roads_num, 'roads in this area.')
    print('There are', roads_with_name, 'roads with street name.')
    return node_coordinates
