function [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_ES_Gen(routes, N, max_route_length, threshold, R_init, t, T, turns_flag, pairwise_dist,min_num_candidates)

R = R_init;
metric = zeros(size(routes,2),1);
rank = zeros(max_route_length,1);
best_routes = {max_route_length};
best_top5_routes = {max_route_length};
route_dist = {max_route_length};

for m=1 : max_route_length
    y = routes(t(m)).y;
            
    if m > 1 
            if strcmp(turns_flag, 'true')
                turn = T(m-1); 
                [R_, metric_] = Turn_filter(R, metric, turn, routes, m, threshold); % turn filter
                [R_, metric_] = Nclosest_es( t(m), R_, metric_, N(m), pairwise_dist, min_num_candidates); % filter based on sorting
            else
                [R_, metric_] = Nclosest_es( t(m), R, metric, N(m), pairwise_dist, min_num_candidates); % filter based on sorting
            end            
            
    else % first observation
            [R_, metric_] = Nclosest_es( t(m), R, metric, N(m), pairwise_dist, min_num_candidates); % call dist filter 
    end
    
    if m < max_route_length
        [R, metric] = RRextend(R_, metric_, routes); 
    end
    
    % rank of the current route
    gt_point = t(m);
    [gt_indices, ~] = find(R_(:,m) == gt_point);
    if size(gt_indices) > 0
        point_rank = gt_indices(1);
    else 
        point_rank = size(R_init,1)+1;
    end
    
    rank(m,1) = point_rank;
    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    best_routes{m} = t_;
    route_dist{m} = metric_;
    
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