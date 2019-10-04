function show_route(index, test_route, routes, dataset, max_route_length)
    route = test_route(index,:);
    for l=1:max_route_length
        loc_index = route(l);
        pano_id = routes(loc_index).id;
        pano_path = [pwd, '/Data/',dataset,'/panos/', pano_id, '.jpg'];
        imshow(pano_path)
        pause();
    end

end