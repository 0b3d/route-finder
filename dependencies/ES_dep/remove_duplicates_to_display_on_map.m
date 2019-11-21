function indices = remove_duplicates_to_display_on_map(sorted_indices, routes, k)
    pano_ids = {};
    indices = zeros(1,k);
    i = 1;
    counter = 1;
    while counter<=k
        index = sorted_indices(i);
        pano_id = routes(index).id;
        if ~ismember(pano_id, pano_ids)
            pano_ids{counter} = pano_id;
            indices(1,counter) = index; 
            counter = counter + 1;
        end
        i = i + 1;
    end
end

