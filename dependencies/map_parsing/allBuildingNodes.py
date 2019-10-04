def allBuildingNodes(children):
    """
    This method reads the passed osm file (xml) and extracts all building nodes.
    (derived from OSMtagSetupInit post by Yam)
    """
    node_coordinates = []
    lat = {}
    lon = {}
    buildings_num = 0

    building_keys = ('building', 'shop', 'office', 'craft')

    # for amenity
    building_types_amenity = ('biergarten','bicycle_parking','bicycle_repair_station','bicycle_rental','boat_rental',
    'boat_sharing','bus_station','car_sharing','charging_station','ferry_terminal','fuel','grit_bin','motorcycle_parking',
    'parking','parking_space','taxi','fountain','public_bookcase','grave_yard','hunting_stand','kneipp_water_cure',
    'marketplace','public_bath','recycling','sanitary_dump_station','shelter','shower','toilets','waste_transfer_station')
    # for tourism
    building_types_tourism = ('apartment','aquarium','chalet','gallery','guest_house','hostle',
    'hotel','information','motel','museum')

    # for leisure
    building_types_leisure = ('adult_gaming_centre','amusement_arcade','dance','escape_game',
    'fitness_centre','hackerspace','sports_centre','stadium')    

    # for historic
    building_types_historic = ('building','castle','church','fort','manor','monastery','tower')


    for child in children:
        if child.tag == 'way':
        # Check if the way represents a "building"
        # If the current way is not a building,
        # continue without checking any nodes
            building = False
            for item in child:
                if item.tag == 'tag' and item.attrib['k'] in building_keys: 
                    building = True
                    buildings_num += 1
                    if item.attrib['v'] == 'yes':
                        building_type = 'undefined'
                    else:
                        building_type = item.attrib['v']
                            
                    node_coordinates.append('     ') # blank line between ways
                    node_coordinates.append('building id: ' + child.attrib['id']) # delineate start of new "way" (previously [345,345])
                
                if item.tag == 'tag' and item.attrib['k'] == 'amenity' and item.attrib['v'] not in building_types_amenity:
                    building = True
                    buildings_num += 1
                    building_type = item.attrib['v']                            
                    node_coordinates.append('     ') 
                    node_coordinates.append('building id: ' + child.attrib['id']) 

                if item.tag == 'tag' and item.attrib['k'] == 'tourism' and item.attrib['v'] in building_types_tourism:
                    building = True
                    buildings_num += 1
                    building_type = item.attrib['v']                            
                    node_coordinates.append('     ') 
                    node_coordinates.append('building id: ' + child.attrib['id'])                     
                
                if item.tag == 'tag' and item.attrib['k'] == 'leisure' and item.attrib['v'] in building_types_leisure:
                    building = True
                    buildings_num += 1
                    building_type = item.attrib['v']                            
                    node_coordinates.append('     ') 
                    node_coordinates.append('building id: ' + child.attrib['id']) 

                if item.tag == 'tag' and item.attrib['k'] == 'historic' and item.attrib['v'] in building_types_historic:
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

            node_coordinates.append('building_type: ' + building_type)

        elif child.tag == 'node':
        # store lat and lon coordinates
            nd_ref = child.attrib['id']
            lat[nd_ref] = child.attrib['lat']
            lon[nd_ref] = child.attrib['lon']

    print('There are', buildings_num, 'buildings in this area.')
    return node_coordinates