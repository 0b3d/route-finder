function [hd] = display_top_routes(routes, key_frame, et1, color, marker_size)
    % estimated location
    estimated_x1 = zeros(key_frame,1);
    estimated_y1 = zeros(key_frame,1);

    for i=1:key_frame
        estimated_x1(i) = routes(et1(i)).gsv_coords(2);
        estimated_y1(i) = routes(et1(i)).gsv_coords(1);   
    end
    
    hd(1) = plot(estimated_x1(:,1), estimated_y1(:,1), 'o', 'MarkerFaceColor', color,'MarkerSize', 5,'MarkerEdgeColor', color);    
    hd(2) = plot(estimated_x1(key_frame), estimated_y1(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', marker_size, 'LineWidth', 5);
end