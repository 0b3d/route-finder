function location = RouteSearching_v7(routes, net1, net2, N, max_route_length, threshold, R_init, Tjc, Tbd, T)
R = R_init;
dist = zeros(size(routes,2),1);

for m=1 : max_route_length
    bad = Cnn_classifier_v2(net1,Tjc,net2,Tbd,m);  % slowest
    if isempty(bad)
        max_route_length = max_route_length-1;
        continue;
    end
    
    [R_, ~, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
    
%     if m < max_route_length
        [R, dist] = RRextend_v5(R_, dist_, routes); 
%     else
%         % turn patterns
%         T_ = zeros(size(R_, 1), size(R_, 2)-1);
%         T_dist = zeros(size(R_, 1),1);
%         for i=1:size(R_, 1)
%             for j=1:size(R_, 2)-1
%                 idx1 = R_(i,j);
%                 idx2 = R_(i,j+1);
%                 theta1 = routes(idx1).yaw;
%                 theta2 = routes(idx2).yaw;
%                 T_(i, j) = turn_pattern(theta1, theta2, threshold);
%             end 
%             T_dist(i) = size(find(T_(i,:)~=T), 2); 
%         end 
%         k = T_dist == 0;
%         R_ = R_(k,:);
%     end   
end

% turn patterns
T_ = zeros(size(R_, 1), size(R_, 2)-1);
T_dist = zeros(size(R_, 1),1);
for i=1:size(R_, 1)
    for j=1:size(R_, 2)-1
        idx1 = R_(i,j);
        idx2 = R_(i,j+1);
        theta1 = routes(idx1).yaw;
        theta2 = routes(idx2).yaw;
        T_(i, j) = turn_pattern(theta1, theta2, threshold);
    end 
    T_dist(i) = size(find(T_(i,:)~=T(1:max_route_length-1)), 2); 
end 
k = T_dist == 0;
R_ = R_(k,:);
        
if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end