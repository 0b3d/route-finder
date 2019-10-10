function [location, rank, best_routes, route_dist] = RouteSearching_BSD(routes, N, max_route_length, threshold, R_init, t, T, turns, accuracy)
R = R_init;
dist = zeros(size(routes,2),1);
rank = zeros(max_route_length,1);
best_routes = {max_route_length};
route_dist = {max_route_length};

for m=1 : max_route_length
    bad = routes(t(m)).CNNs;
        
    if m > 1
        if strcmp(turns, 'true')
            turn = T(m-1);
            [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % filter based on turn
            [R_, dist_] = Nclosest_v4(bad,R_,routes,dist_,N(m)); % filter based on sorting
            % [R_, dist_, prob_] = Nclosest_v6(bad,R_,routes,dist_,N,accuracy);
        else
            [R_, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
            % [R_, dist_, prob_] = Nclosest_v6(bad,R,routes,dist,N,accuracy);
        end
    else
        [R_, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
        % [R_, dist_, prob_] = Nclosest_v6(bad,R,routes,dist,N,accuracy);
    end
    
    if m < max_route_length
        [R, dist] = RRextend_v5(R_, dist_, routes); 
    end
    
    % rank of the current route
    gt_point = t(m);
    [gt_indices, ~] = find(R_(:,m) == gt_point);
    if size(gt_indices) > 0
        point_rank = gt_indices(1);
    else 
        point_rank = [gt_indices,1];  % check!!!!
    end    
    rank(m,1) = point_rank;

    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    best_routes{m} = t_;
    route_dist{m} = dist_;
    % route_dist{m} = prob_;
    
end

if ~isempty(t_)
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end