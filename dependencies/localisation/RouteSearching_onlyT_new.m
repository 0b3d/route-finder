function [location, location_, m_, flag] = RouteSearching_onlyT_new(routes, max_route_length, R_init, t, T, overlap, s_number, threshold)
R = R_init;
loop = 1;

for m=1 : max_route_length
    location = t(m);
    if m > 1
        turn = T(m-1);
        R_ = Turn_filter_v2(R, turn, routes, m, threshold);
    else
        R_ = R;
    end
        
    if size(R_, 1) > 0
        t_c = R_(1,:);
    else
        location_ = [];
        m_ = m;
        flag = 0;
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
        break;
    else
        if m < max_route_length
            R = RRextend_v6(R_, routes);
            t_f = t_c;
        else
            location_ = [];
            m_ = m;
            flag = 0;
            % disp('could not find correct location!')
        end
    end       
end

end