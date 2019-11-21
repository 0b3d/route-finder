function [hd] = display_top_routes_v2 (routes, key_frame, estimated_routes, color, marker_size)
    cmap = colormap(jet);

    % estimated location
    for r=size(estimated_routes,1):-1:1
        route_indices = estimated_routes(r,1:key_frame);
        for i=1:key_frame
           index = route_indices(i);
           route_lats(i) = routes(index).gsv_coords(1); 
           route_lons(i) = routes(index).gsv_coords(2); 
        end  
        hd(r,1) = plot(route_lons, route_lats, 'o', 'MarkerFaceColor', cmap(10*r,:),'MarkerSize', 5,'MarkerEdgeColor', color);    
        %hd(1,2) = plot(estimated_x1(1,key_frame), estimated_y1(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', marker_size, 'LineWidth', 5);
    end
end