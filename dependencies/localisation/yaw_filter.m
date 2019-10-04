function [R_,dist_] = yaw_filter(R_, dist_, routes, m, t)

% Given the observation theta1 filter all the posible routes that are in
% range  observed_yaw - 10 < yaw < observed yaw + 10
% be aware of angules > 360 and < 0
Yaws = zeros(size(R_,1),1);
for i=1:size(R_, 1)
    ground_truth_index = t(m);
    observed_yaw = routes(ground_truth_index).gsv_yaw;
    
    current_test_point_index = R_(i, m);
    test_yaw = routes(current_test_point_index).gsv_yaw;
    
    lower_limit = observed_yaw - 5;
    if lower_limit < 0
        lower_limit = lower_limit + 360;
    end
    upper_limit = observed_yaw + 5;
    if upper_limit > 360
        upper_limit = upper_limit - 360;
    end
    
    if (test_yaw >= lower_limit) && (test_yaw < upper_limit)
        Yaws(i) = 1;
%         if current_test_point_index == ground_truth_index
%             disp('enocntrado')
%         end
    end
        
end

k = find(Yaws == 1);
R_ = R_(k,:);
dist_ = dist_(k,:);

% mem = ismember(ground_truth_index, R_(:,m))
% if mem == false
%     disp('problem')
% end

% filter all routes that match the criterium
%(get all the points in R_ that match the criterium)

%T_ = zeros(size(R_, 1), 1); % observed turn pattern
% for i=1:size(R_, 1)
%     idx1 = R_(i, m-1); % first point index in the test route
%     idx2 = R_(i, m); % second point index in the test route
%     theta1 = routes(idx1).gsv_yaw; % teta1
%     theta2 = routes(idx2).gsv_yaw; %teta2
%     if isempty(theta1) || isempty(theta2)
%         T_(i) = 3;
%     else
%         T_(i) = turn_pattern(theta1, theta2, threshold);
%     end
% end 
% k = find(T_ == turn);
% R_ = R_(k,:);
% dist_ = dist_(k,:);

% just randomly discard some routes that are not the original
% gt_point = t(m);
% k = find(R_(:,m) == gt_point);
% 
% fake_indices = randi([1, size(R_,1)],1,fix(size(R_,1)*0.70));
% 
% for i=1:size(k,1)
%     kk = k(i);
%     mem = ismember(kk, fake_indices);
%     if mem == false
%         fake_indices = [fake_indices,kk];
%     end
% end

end