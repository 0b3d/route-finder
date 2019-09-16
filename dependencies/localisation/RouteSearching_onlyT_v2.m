function location = RouteSearching_onlyT_v2(routes, max_route_length, R_init, T, threshold)
R = R_init;

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
end

if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end