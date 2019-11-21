function [hd] = display_ranked_points_on_map (routes, points, color, marker_size)
    cmap = colormap(jet);

    % estimated location
    for p=1:1:size(points,2)
        point_index = points(1, p);
        lat = routes(point_index).gsv_coords(1); 
        lon = routes(point_index).gsv_coords(2);   
        hd(p) = plot(lon, lat, 'o', 'MarkerFaceColor', cmap(10*p,:),'MarkerSize', marker_size,'MarkerEdgeColor', cmap(10*p,:));    
        %hd(1,2) = plot(estimated_x1(1,key_frame), estimated_y1(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', marker_size, 'LineWidth', 5);
    end
end