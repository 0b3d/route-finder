function [rank, best_routes, best_top5_routes, route_dist, bootstrapping_length] = RouteSearching_BSD_bs(routes, N, max_route_length, threshold, R_init, t, T, turns, overlap, s_number)
R = R_init;
dist = zeros(size(routes,2),1);
rank = zeros(max_route_length,1);
best_routes = {max_route_length};
best_top5_routes = {max_route_length};
route_dist = {max_route_length};
loop = 1; % bootstrapping
flag_bs = false;
bootstrapping_length = max_route_length; % initialize bootstrapping length

for m=1 : max_route_length
    bad = routes(t(m)).CNNs;
    
    if m == 1
        [R_, dist_] = Nclosest_bsd(bad,R,routes,dist,N(m)); % filter based on sorting
        t_ = R_(1,:);
        [R, dist] = RRextend(R_, dist_, routes); 
        t_f = t_;
    else
        if size(R_, 1) > 0
            if strcmp(turns, 'true')
                turn = T(m-1);
                if ~flag_bs
                    [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % filter based on turn
                    [R_, dist_] = Nclosest_bsd(bad,R_,routes,dist_,N(m)); % filter based on sorting
                    t_ = R_(1,:);
                    
                    % bootstrapping v1
%                     loop = consistency_criteria(t_, t_f, loop, overlap); % t_f is the front best estimated route
%                     if loop == s_number % reach the bootstrapping
%                         bootstrapping_length = m;
%                         min_dist = dist_(1);
%                         flag_bs = true;
%                     else
%                         [R, dist] = RRextend(R_, dist_, routes); 
%                         t_f = t_; % record the best routes for comparison
%                     end
                    % bootstrapping v2
                    if m == 20 % start the bootstrapping after 20 
                        bootstrapping_length = m;
                        min_dist = dist_(1);
                        flag_bs = true;
                    else
                        [R, dist] = RRextend(R_, dist_, routes); 
                        t_f = t_; % record the best routes for comparison
                    end
                else
                    [R, dist] = boot_strapping(t_, min_dist, routes, bootstrapping_length);
                    [R_, dist_] = Turn_filter(R, dist, turn, routes, bootstrapping_length, threshold); % filter based on turn
                    [R_, dist_] = Nclosest_bsd(bad,R_,routes,dist_,100); % N = 100
                    if ~isempty(R_)
                        t_ = R_(1,:);
                        min_dist = dist_(1);
                    end
                end
            else
                if ~flag_bs
                    [R_, dist_] = Nclosest_bsd(bad,R,routes,dist,N(m)); % filter based on sorting
                    t_ = R_(1,:);
                     % bootstrapping v1
%                     loop = consistency_criteria(t_, t_f, loop, overlap); % t_f is the front best estimated route
%                     if loop == s_number % reach the bootstrapping
%                         bootstrapping_length = m;
%                         min_dist = dist_(1);
%                         flag_bs = true;
%                     else
%                         [R, dist] = RRextend(R_, dist_, routes); 
%                         t_f = t_; % record the best routes for comparison
%                     end
                    % bootstrapping v2
                    if m == 20 % start the bootstrapping after 20 
                        bootstrapping_length = m;
                        min_dist = dist_(1);
                        flag_bs = true;
                    else
                        [R, dist] = RRextend(R_, dist_, routes); 
                        t_f = t_; % record the best routes for comparison
                    end
                else
                    [R, dist] = boot_strapping(t_, min_dist, routes, bootstrapping_length);
                    [R_, dist_] = Nclosest_bsd(bad,R,routes,dist,100); % filter based on sorting
                    if ~isempty(R_)
                        t_ = R_(1,:);
                        min_dist = dist_(1);
                    end
                end            
            end
        else
            t_ = [];
            dist_ = [];
        end
    end   
    
    % rank of the current route
    gt_point = t(m);
    if ~flag_bs
        [gt_indices, ~] = find(R_(:,m) == gt_point);
    else
        [gt_indices, ~] = find(R_(:,bootstrapping_length) == gt_point);
    end

    if size(gt_indices) > 0
        point_rank = gt_indices(1);
    else 
        point_rank = size(R_init,1)+1; 
    end    
    rank(m,1) = point_rank;
    
    % current best estimated route
    best_routes{m} = t_;
    route_dist{m} = dist_;

    if size(R_, 1) > 5
        top5 = R_(1:5,:);
    else
        top5 = R_;
    end
    best_top5_routes{m} = top5; 
end

end
