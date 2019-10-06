function [location, rank, R, t_] = RouteSearching_BSD_withT_v2(routes, accuracy, N, max_route_length, threshold, R_init, t, T)
R = R_init;
dist = zeros(size(routes,2),1);
rank = zeros(max_route_length,1);

for m=1 : max_route_length
    % we can flip the BSDs based on CNN accuracy online or generate them
    % offline
    % good = routes(location).BSDs;
    % bad = bit_flipped(good, accuracy); 
    bad = routes(t(m)).CNNs;
        
    if m > 1
        turn = T(m-1);
        [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % filter based on turn
        [R_, dist_] = Nclosest_v4(bad,R_,routes,dist_,N(m)); % filter based on sorting
    else
        [R_, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
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
        point_rank = [gt_indices,1];
    end
    
    rank(m,1) = point_rank;
    
end

if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    t_ = [];
    location = [];
end

end