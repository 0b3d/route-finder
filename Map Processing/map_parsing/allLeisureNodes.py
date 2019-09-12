def allLeisureNodes(children):
    """
    This method reads the passed osm file (xml) and extracts all leisure nodes.
    (derived from OSMtagSetupInit post by Yam)
    """
    node_coordinates = []
    lat = {}
    lon = {}
    leisure_num = 0


    for child in children:
        if child.tag == 'way':
        # Check if the way represents a "leisure"
        # If the current way is not a leisure,
        # continue without checking any nodes
            leisure = False
            for item in child:
                if item.tag == 'tag' and item.attrib['k'] == 'leisure': 
                    leisure = True
                    leisure_num += 1
                    if item.attrib['v'] == 'yes':
                        leisure_type = 'undefined'
                    else:
                        leisure_type = item.attrib['v']
                            
                    node_coordinates.append('     ') # blank line between ways
                    node_coordinates.append('leisure id: ' + child.attrib['id']) # delineate start of new "way" (previously [345,345])

            if not leisure:
                continue

            for item in child:  # must keep in order 
                # Add nodes
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    coordinate = lat[nd_ref] + ',' + lon[nd_ref]
                    node_coordinates.append(coordinate)           

            node_coordinates.append('leisure_type: ' + leisure_type)

        elif child.tag == 'node':
        # store lat and lon coordinates
            nd_ref = child.attrib['id']
            lat[nd_ref] = child.attrib['lat']
            lon[nd_ref] = child.attrib['lon']

    print('There are', leisure_num, 'leisures in this area.')
    return node_coordinates