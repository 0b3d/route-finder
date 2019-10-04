function [location, rank, R, t_] = RouteSearching_ES_Probs(routes, N, max_route_length, threshold, R_init, t, T)
R = R_init;
probs = ones(size(routes,2),1);
rank = zeros(max_route_length,1);

for m=1 : max_route_length
    y = routes(t(m)).y;
    
%     pano_id = routes(t(m)).id;
%     impath = ['Data/london_center_09_19/panos/',pano_id,'.jpg']
%     imshow(impath)
%         
    if m > 1
        turn = T(m-1); 
        %[R_, probs_] = fake_turn_filter(R, probs, turn, routes, m, threshold, t);
        [R_, probs_] = Turn_filter(R, probs, turn, routes, m, threshold); % filter based on turn (normal)
        %[R_, probs_] = yaw_filter(R, probs, routes, m, t); % filter based on turn  
        
        [R_, probs_] = Nclosest_uc_probs(y,R_,routes,probs_,N(m),t,m); % filter based on sorting
    else
        %[R_, probs_] = yaw_filter(R, probs, routes, m, t);
        [R_, probs_] = Nclosest_uc_probs(y,R,routes,probs,N(m),t,m); % filter based on sorting
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
        point_rank = [gt_indices,1];
    end
    
    rank(m,1) = point_rank;
    
end

if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else
    t_ = [];
    location = [];
end

end