function [location, rank, best_routes, best_top5_routes] = RouteSearching_onlyT_v2(routes, max_route_length, R_init, t, T, threshold)
R = R_init;
rank = zeros(max_route_length,1);
best_routes = {max_route_length};
best_top5_routes = {max_route_length};

for m=1 : max_route_length
    if m > 1
        turn = T(m-1);
        R_ = Turn_filter_v2(R, turn, routes, m, threshold);
    else
        R_ = R;
    end
            
    if m < max_route_length
        R = RRextend_v6(R_, routes);
    end  
    
    % rank of the current route
    gt_point = t(m);
    [gt_indices, ~] = find(R_(:,m) == gt_point);
    if size(gt_indices) > 0
        point_rank = gt_indices(1);
    else 
        point_rank = [gt_indices,1];
    end
    rank(m,1) = point_rank;
    
    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    best_routes{m} = t_; 
    
    if size(R_, 1) > 5
        top5 = R_(1:5,:);
    else
        top5 = R_;
    end
    best_top5_routes{m} = top5;
end

if ~isempty(t_)
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end