def get_boundary(children):
    boundary_coordinates = []
    for child in children:
        if child.tag == 'bounds':
            boundary_coordinates.append(child.attrib['minlat'])
            boundary_coordinates.append(child.attrib['minlon'])
            boundary_coordinates.append(child.attrib['maxlat'])
            boundary_coordinates.append(child.attrib['maxlon'])

    return boundary_coordinates
            

