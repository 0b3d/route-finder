function location = RouteSearching_ES_Probs(routes, N, max_route_length, threshold, R_init, t, T)
R = R_init;
probs = ones(size(routes,2),1);

for m=1 : max_route_length
    y = routes(t(m)).y;
        
    if m > 1
        turn = T(m-1);
        [R_, probs_] = Turn_filter(R, probs, turn, routes, m, threshold); % filter based on turn
        [R_, probs_] = Nclosest_uc_probs(y,R_,routes,probs_,N(m),t,m); % filter based on sorting
    else
        [R_, probs_] = Nclosest_uc_probs(y,R,routes,probs,N(m),t,m); % filter based on sorting
    end
    
    if m < max_route_length
        [R, probs] = RRextend_v5(R_, probs_, routes); 
    end
end

if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end