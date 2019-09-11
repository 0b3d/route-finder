def allBuildingNodes(children):
    """
    This method reads the passed osm file (xml) and extracts all building nodes.
    (derived from OSMtagSetupInit post by Yam)
    """
    node_coordinates = []
    lat = {}
    lon = {}
    buildings_num = 0
    buildings_with_housenumber = 0
    buldings_with_streetname = 0
    buldings_is_amenity = 0
    buildings_with_height = 0
    buildings_with_level = 0

    building_keys = ('building','shop')
    building_types = ('fast_food','cafe','nightclub','restaurant','pub','bank',
    'gym','police','place_of_worship','parking')


    for child in children:
        if child.tag == 'way':
        # Check if the way represents a "building"
        # If the current way is not a building,
        # continue without checking any nodes
            building = False
            for item in child:
                if item.tag == 'tag' and item.attrib['k'] in building_keys: 
                #if item.tag == 'tag' and item.attrib['k'] == 'building': 
                    building = True
                    buildings_num += 1
                    if item.attrib['v'] == 'yes':
                        building_type = 'undefined'
                    else:
                        building_type = item.attrib['v']
                            
                    node_coordinates.append('     ') # blank line between ways
                    node_coordinates.append('building id: ' + child.attrib['id']) # delineate start of new "way" (previously [345,345])

                if item.tag == 'tag' and item.attrib['k'] == 'amenity' and item.attrib['v'] in building_types:
                    building = True
                    buildings_num += 1
                    building_type = item.attrib['v']                            
                    node_coordinates.append('     ') 
                    node_coordinates.append('building id: ' + child.attrib['id']) 

            if not building:
                continue

            for item in child:  # must keep in order 
                # Add nodes
                if item.tag == 'nd':
                    nd_ref = item.attrib['ref']
                    coordinate = lat[nd_ref] + ',' + lon[nd_ref]
                    node_coordinates.append(coordinate)   
                # The height of the building in meters
                if item.tag == 'tag' and item.attrib['k'] == 'height':
                    height = item.attrib['v']
                    buildings_with_height += 1
                # The number of visible levels in the building
                if item.tag =='tag' and item.attrib['k'] == 'building:levels':
                    building_level = item.attrib['v']
                    buildings_with_level += 1
                # Building amentity
                if item.tag =='tag' and item.attrib['k'] == 'amenity':
                    amenity = item.attrib['v']
                    buldings_is_amenity += 1
                # House number
                if item.tag =='tag' and item.attrib['k'] == 'addr:housenumber':
                    house_number = item.attrib['v']
                    buildings_with_housenumber += 1  
                # Street name
                if item.tag =='tag' and item.attrib['k'] == 'addr:street':
                    street_name = item.attrib['v']
                    buldings_with_streetname += 1              

            node_coordinates.append('building_type: ' + building_type)
            #node_coordinates.append('height: ' + height)
            #node_coordinates.append('building levels: ' + building_level)
            #node_coordinates.append('amennity: ' + amenity)
            #node_coordinates.append('house number: ' + house_number)
            #node_coordinates.append('street name: ' + street_name)

        elif child.tag == 'node':
        # store lat and lon coordinates
            nd_ref = child.attrib['id']
            lat[nd_ref] = child.attrib['lat']
            lon[nd_ref] = child.attrib['lon']

    print('There are', buildings_num, 'buildings in this area.')
    print('There are', buildings_with_height, 'buildings with height info.')
    print('There are', buildings_with_level, 'buildings with level info.')
    print('There are', buldings_is_amenity, 'buildings with amenity info.')
    print('There are', buildings_with_housenumber, 'buildings with house number.')
    print('There are', buldings_with_streetname, 'buildings with street name.')
    return node_coordinates