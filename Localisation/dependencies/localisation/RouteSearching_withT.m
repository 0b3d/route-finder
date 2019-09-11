function [location, location_, m_, flag, dist_] = RouteSearching_withT(routes, N, max_route_length, R_init, t, T, overlap, s_number, threshold)
R = R_init;
dist = zeros(size(routes,2),1);
loop = 0;

for m=1 : max_route_length
    location = t(m);
    bad = routes(location).x;
        
    if m > 1
        turn = T(m-1);
        [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % filter based on turn
        [R_, dist_] = Nclosest_uc(bad,R_,routes,dist_,N(m)); % filter based on sorting 
    else
        [R_, dist_] = Nclosest_uc(bad,R,routes,dist,N(m)); % filter based on sorting 
    end
    
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        location_ = [];
        m_ = m;
        flag = 0;
        % disp('couldn not find correct location!');
        break;
    end
    
    t_c = t(1:m);
    count = 0;
    for c=1:m
        if(t_(c) == t_c(c))
            count = count+1;
        end
    end
    overlap_ = count/m;
    if overlap_ >= overlap
        loop = loop+1;
    else 
        loop = 0;
    end
    
    if loop == s_number
        location_ = t_(m);
        m_ = m;
        flag = 1;
        break;
    else
        if m < max_route_length
            [R, dist] = RRextend_v5(R_, dist_, routes); 
        else
            location_ = [];
            m_ = m;
            flag = 0;
            % disp('could not find correct location!')
        end
    end       
end
end