function [R_,dist_] = fake_turn_filter(R_, dist_, turn, routes, m, threshold, t)
%T_ = zeros(size(R_, 1), 1); % observed turn pattern
% for i=1:size(R_, 1)
%     idx1 = R_(i, m-1);
%     idx2 = R_(i, m);
%     theta1 = routes(idx1).gsv_yaw;
%     theta2 = routes(idx2).gsv_yaw;
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
gt_point = t(m);
k = find(R_(:,m) == gt_point);

fake_indices = randi([1, size(R_,1)],1,fix(size(R_,1)*0.70));

for i=1:size(k,1)
    kk = k(i);
    mem = ismember(kk, fake_indices);
    if mem == false
        fake_indices = [fake_indices,kk];
    end
end

R_ = R_(fake_indices,:);
dist_ = dist_(fake_indices,:);
end