% check turns
clear clc
clear all
parameters;

load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num), '_' , num2str(threshold),'.mat']);
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['Localisation/test_routes/',dataset,'_turns_', num2str(test_num), '_' , num2str(threshold),'.mat']);

max_route_length = 20;
t = test_route(5,1:max_route_length);
T = test_turn(5,1:max_route_length-1)';

yaw = [];
for i=1:20
    idx = t(i);
    yaw = [yaw;routes(idx).gsv_yaw];  
end

T2 = zeros(1, size(t, 2)-1);
for i=1:size(t, 2)-1
    threshold = 45;
    theta1 = routes(t(i)).gsv_yaw;
    theta2 = routes(t(i+1)).gsv_yaw;
    T2(i) = turn_pattern(theta1, theta2, threshold);
end
T2 = T2';