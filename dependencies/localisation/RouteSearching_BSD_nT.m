function [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_BSD_v2(routes, N, max_route_length, threshold, R_init, t, T, turns)
R = R_init;
dist = zeros(size(routes,2),1);
rank = zeros(max_route_length,1);
best_routes = {max_route_length};
best_top5_routes = {max_route_length};
route_dist = {max_route_length};
bad_route = zeros(1,max_route_length*4);
for m=1 : max_route_length
    bad = routes(t(m)).CNNs; 
    bad_route(1,(m-1)*4+1:m*4) = bad;
    if m > 1
        if strcmp(turns, 'true')
            turn = T(m-1);
            [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % filter based on turn
            [R_, dist_,I] = Nclosest_v4(bad,R_,routes,dist_,N(m)); % filter based on sorting
        else
            file = ['turns_false/','R_',num2str(m),'.mat'];
            if ~exist(file,'file')
                [R_, dist_,I] = Nclosest_v4(bad,R,routes,dist,N(m)); 
            else
                [R_] = Nclosest_nT(bad_route,dist_,I,R,routes,N(m));          
            end
        end
    else
        [R_, dist_,I] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
    end
    
    if m < max_route_length        
        if strcmp(turns, 'false')  
            file = ['turns_false/','R_',num2str(m+1),'.mat'];
            if ~exist(file,'file')
                [R, dist] = RRextend_v5(R_, dist_, routes);
                save(file,'R')               
            else
                load(file,'R');                     
            end
        else
            [R, dist] = RRextend_v5(R_, dist_, routes); 
        end
    end
    
    % rank of the current route
    gt_point = t(m);
    [gt_indices, ~] = find(R_(:,m) == gt_point);
    if size(gt_indices) > 0
        point_rank = gt_indices(1);
    else 
        point_rank = size(R_init,1)+1;  % check!!!!
    end    
    rank(m,1) = point_rank;

    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    best_routes{m} = t_;
    route_dist{m} = dist_;
    % route_dist{m} = prob_;
    
    if size(R_, 1) > 5
        top5 = R_(1:5,:);
    else
        top5 = R_;
    end
    best_top5_routes{m} = top5;
    
    
    
end

if ~isempty(t_)
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end