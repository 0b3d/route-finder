% generate turn patterns
load('test_route_1500_small.mat');
load('london_BSD_new75_small.mat');
test_turn = [];
threshold = 60; %60
for i=1:size(test_route,1)
    t = test_route(i,:);
    % true turn patterns
    T = zeros(1, size(t, 2)-1);
    for j=1:size(t, 2)-1
        theta1 = routes(t(j)).gsv_yaw;
        theta2 = routes(t(j+1)).gsv_yaw;
        T(j) = turn_pattern_v2(theta1, theta2, threshold);
    end
    test_turn = [test_turn; T];
end
save('test_turn_1500LR_small.mat','test_turn');