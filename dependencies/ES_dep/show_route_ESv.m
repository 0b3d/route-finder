function show_route_ESv(index, test_route, routes, dataset, max_route_length)
    route = test_route(index,:);
    for l=1:max_route_length
        loc_index = route(l);
        pano_id = routes(loc_index).id;
        xpath = ['images/',dataset,'/tiles/z19/',num2str(loc_index),'.png'];
        ypath = ['images/',dataset,'/panos/',pano_id,'.jpg'];
        tile = imread(xpath);
        [front, left, right, back] = crop_pano(256, 90,pano_id, dataset);
        image = [tile, front, left, right, back];
        imshow(image)
        pause();
    end

end