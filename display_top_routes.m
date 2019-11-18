function display_top_routes(routes, key_frame, et1, et2, et3, color)

    
    % estimated location
    estimated_x1 = zeros(key_frame,1);
    estimated_y1 = zeros(key_frame,1);
    estimated_x2 = zeros(key_frame,1);
    estimated_y2 = zeros(key_frame,1);
    estimated_x3 = zeros(key_frame,1);
    estimated_y3 = zeros(key_frame,1);
    for i=1:key_frame
        estimated_x1(i) = routes(et1(i)).gsv_coords(2);
        estimated_y1(i) = routes(et1(i)).gsv_coords(1);
        estimated_x2(i) = routes(et2(i)).gsv_coords(2);
        estimated_y2(i) = routes(et2(i)).gsv_coords(1);
        estimated_x3(i) = routes(et3(i)).gsv_coords(2);
        estimated_y3(i) = routes(et3(i)).gsv_coords(1);        
    end
    plot(estimated_x1(:,1), estimated_y1(:,1), 'o', 'MarkerFaceColor', color,'MarkerSize', 8,'MarkerEdgeColor', color);
    plot(estimated_x2(:,1), estimated_y2(:,1), 'd', 'MarkerFaceColor', color,'MarkerSize', 8,'MarkerEdgeColor', color);
    plot(estimated_x3(:,1), estimated_y3(:,1), 's', 'MarkerFaceColor', color,'MarkerSize', 8,'MarkerEdgeColor', color);    
    hold on;
    plot(estimated_x1(key_frame), estimated_y1(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', 30, 'LineWidth', 5);
    plot(estimated_x2(key_frame), estimated_y2(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', 30, 'LineWidth', 5);
    plot(estimated_x3(key_frame), estimated_y3(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', 30, 'LineWidth', 5);
    hold off;
end