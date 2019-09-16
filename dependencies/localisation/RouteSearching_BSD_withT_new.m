function [location, location_, m_, flag, dist_, t_r, t_e] = RouteSearching_BSD_withT_new(routes, N, max_route_length, R_init, t, T, overlap, s_number, threshold, accuracy)
R = R_init;
dist = zeros(size(routes,2),1);
loop = 1;

for m=1 : max_route_length
    location = t(m);
    t_r = t(1:m);
    % we can flip the BSDs based on CNN accuracy online or generate them offline
    % good = routes(location).BSDs;
    % bad = bit_flipped(good, accuracy);
    bad = routes(location).CNNs;
    
    if m > 1
        turn = T(m-1);
        [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % filter based on turn
        [R_, dist_] = Nclosest_v4(bad,R_,routes,dist_,N(m)); % filter based on sorting
    else
        [R_, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
    end
    
       
    if size(R_, 1) > 0
        t_c = R_(1,:);
    else
        location_ = [];
        m_ = m;
        flag = 0;
        t_e = [];
        % disp('couldn not find correct location!');
        break;
    end
    
    if m > 1
        loop = consistency_criteria(t_c, t_f, loop, overlap);
    end
    
    if loop == s_number
        location_ = t_c(m);
        m_ = m;
        flag = 1;
        t_e = t_c;
        break;
    else
        if m < max_route_length
            [R, dist] = RRextend_v5(R_, dist_, routes); 
            t_f = t_c; % record the best routes for comparison
        else
            location_ = [];
            m_ = m;
            flag = 0;
            t_e = [];
            % disp('could not find correct location!')
        end
    end  
    
end
end