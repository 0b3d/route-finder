function location = RouteSearching_v3_noT(routes, accuracy, N, max_route_length, R_init, t)
R = R_init;
dist = zeros(size(routes,2),1);

for m=1 : max_route_length
    good = routes(t(m)).BSDs;
    bad = bit_flipped(good, accuracy);     
    [R_, ~, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting 
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