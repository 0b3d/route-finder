function show_pair_ESv(loc_index, dataset, routes)
    pano_id = routes(loc_index).id;
    loc_id = routes(loc_index).loc_id;
    xpath = ['images/',dataset,'/tiles/z19/',num2str(loc_id),'.png'];
    tile = imread(xpath);
    [front, left, right, back] = crop_pano(256, 90,pano_id, dataset);
    image = [tile, front, left, right, back];
    imshow(image)
end