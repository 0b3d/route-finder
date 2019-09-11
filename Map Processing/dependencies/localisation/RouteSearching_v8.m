function [location, t_] = RouteSearching_v8(routes, tests, accuracy, N, max_route_length, threshold, R_init, t, T, interv)
R = R_init;
dist = zeros(size(routes,2),1);

for m=1 : max_route_length
    good = tests(t(m)).BSDs_o;
    bad = bit_flipped(good, accuracy); 
    
    [R_, ~, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
    
    if m < max_route_length
        [R, dist] = RRextend_ds(R_, dist_, routes, interv(m));
    else
        % turn patterns
        T_ = zeros(size(R_, 1), size(R_, 2)-1);
        T_dist = zeros(size(R_, 1),1);
        for i=1:size(R_, 1)
            for j=1:size(R_, 2)-1
                idx1 = R_(i,j);
                idx2 = R_(i,j+1);
                theta1 = routes(idx1).yaw;
                theta2 = routes(idx2).yaw;
                T_(i, j) = turn_pattern(theta1, theta2, threshold);
            end 
            T_dist(i) = size(find(T_(i,:)~=T), 2); 
        end 
        k = T_dist == 0;
        R_ = R_(k,:);
    end   
end
if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    t_ = [];
    location = [];
end