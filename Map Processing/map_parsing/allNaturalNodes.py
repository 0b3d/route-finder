def allNaturalNodes(children):
    """
    This method reads the passed osm file (xml) and extracts all natural nodes.
    (derived from OSMtagSetupInit post by Yam)
    """
    node_coordinates = []
    lat = {}
    lon = {}
    nature_num = 0


    for child in children:
        if child.tag == 'way':
        # Check if the way represents a "natural"
        # If the current way is not a natural,
        # continue without checking any nodes
            nature = False
            for item in child:
                if item.tag == 'tag' and item.attrib['k'] == 'natural': 
                    nature = True
                    nature_num += 1
                    if item.attrib['v'] == 'yes':
                        nature_type = 'undefined'
                    else:
                        nature_type = item.attrib['v']
                            
                    node_coordinates.append('     ') # blank line between ways
                    node_coordinates.append('nature id: ' + child.attrib['id']) # delineate start of new "way" (previously [345,345])

                if item.tag == 'tag' and item.attrib['k'] == 'amenity' and item.attrib['v'] == 'scrub':
                    nature = True
                    nature_num += 1
                    nature_type = item.attrib['v']                            
                    node_coordinates.append('     ') 
                    node_coordinates.append('nature id: ' + child.attrib['id']) 

            if not nature:
                continue

            for item in child:  # must keep in order 
                # Add nodes
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    coordinate = lat[nd_ref] + ',' + lon[nd_ref]
                    node_coordinates.append(coordinate)           

            node_coordinates.append('nature_type: ' + nature_type)

        elif child.tag == 'node':
        # store lat and lon coordinates
            nd_ref = child.attrib['id']
            lat[nd_ref] = child.attrib['lat']
            lon[nd_ref] = child.attrib['lon']

    print('There are', nature_num, 'naturals in this area.')
    return node_coordinates