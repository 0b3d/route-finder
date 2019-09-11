function [location, location_, m_, flag] = RouteSearching_onlyT(routes, max_route_length, R_init, t, T, overlap, s_number, threshold)
R = R_init;
loop = 0;

for m=1 : max_route_length
    location = t(m);
    if m > 1
        turn = T(m-1);
        R_ = Turn_filter_v2(R, turn, routes, m, threshold);
    else
        R_ = R;
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
            R = RRextend_v6(R_, routes);
        else
            location_ = [];
            m_ = m;
            flag = 0;
            % disp('could not find correct location!')
        end
    end       
end

end