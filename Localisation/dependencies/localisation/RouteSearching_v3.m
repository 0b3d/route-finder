function [location,t_] = RouteSearching_v3(routes, accuracy, N, max_route_length, threshold, R_init, t, T)
R = R_init;
dist = zeros(size(routes,2),1);

for m=1 : max_route_length
%     good = routes(t(m)).BSDs;
%     bad = bit_flipped(good, accuracy); 
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
end

if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    location = [];
end