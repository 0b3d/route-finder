function [location, rank, best_routes, route_dist] = RouteSearching_ES_Probs(routes, N, max_route_length, threshold, R_init, t, T, turns_flag, probs_flag)

pairwise_dist = pairwise_distances(routes);
[gm, pairwise_probs] = fitgmmodel(pairwise_dist);

R = R_init;
if strcmp(probs_flag, 'false')
    probs = zeros(size(routes,2),1);
else 
    probs = ones(size(routes,2),1);
end

rank = zeros(max_route_length,1);
best_routes = {max_route_length};
route_dist = {max_route_length};

for m=1 : max_route_length
    y = routes(t(m)).y;
            
    if m > 1 % not first iteration
        if strcmp(probs_flag, 'true')
            %% probs
            if strcmp(turns_flag, 'true') %turn with turns 
                turn = T(m-1); 
                %[R_, probs_] = fake_turn_filter(R, probs, turn, routes, m, threshold, t);
                [R_, probs_] = Turn_filter(R, probs, turn, routes, m, threshold); % filter based on turn (normal)
                %[R_, probs_] = yaw_filter(R, probs, routes, m, t); % filter based on turn  
                [R_, probs_] = Nclosest_uc_probs(y,R_,routes,probs_,N(m),t,m, pairwise_probs); % filter based on sorting
            else
                [R_, probs_] = Nclosest_uc_probs(y,R,routes,probs,N(m),t,m, pairwise_probs); % filter based on sorting
            end
        else
            %% dist
            if strcmp(turns_flag, 'true')
                turn = T(m-1); 
                [R_, probs_] = Turn_filter(R, probs, turn, routes, m, threshold); % filter based on turn (normal) 
                [R_, probs_] = Nclosest_uc(t(m),R_,routes,probs_,N(m),pairwise_distances); % filter based on sorting
            else
                [R_, probs_] = Nclosest_uc(t(m),R,routes,probs,N(m),pairwise_distances); % filter based on sorting
            end
        end            
            
    else % first observation
        if strcmp(probs_flag, 'true')
            [R_, probs_] = Nclosest_uc_probs(y,R,routes,probs,N(m),t,m, pairwise_probs); % call probs
        else
            [R_, probs_] = Nclosest_uc(t(m),R,routes,probs,N(m),pairwise_distances); % call dist filter 
        end
    end
    
    if m < max_route_length
        [R, probs] = RRextend_v5(R_, probs_, routes); 
    end
    
    % rank of the current route
    gt_point = t(m);
    [gt_indices, ~] = find(R_(:,m) == gt_point);
    if size(gt_indices) > 0
        point_rank = gt_indices(1);
    else 
        point_rank = size(R_init,1)+1;
    end
    
    rank(m,1) = point_rank;
    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    best_routes{m} = t_;
    %route_dist{m} = dist_;
    route_dist{m} = probs_;
    
end

if ~isempty(t_)
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end