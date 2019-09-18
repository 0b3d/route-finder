% generate turn patterns
load('Data/london_center/test_route_500.mat'); 
load('Data/london_center/routes_small_withBSD_75.mat');
test_turn = [];
threshold = 30; %60
for i=1:size(test_route,1)
    t = test_route(i,:);
    % true turn patterns
    T = zeros(1, size(t, 2)-1);
    for j=1:size(t, 2)-1
        theta1 = routes(t(j)).gsv_yaw;
        theta2 = routes(t(j+1)).gsv_yaw;
        T(j) = turn_pattern(theta1, theta2, threshold);
    end
    test_turn = [test_turn; T];
end
save('Data/london_center/test_turn_500_30thresh.mat','test_turn');