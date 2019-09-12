% generate turn patterns
load('test_route_new_500_small.mat');
load('routes_small_withBSDT_75.mat');
test_turn = [];
threshold = 60; %60
for i=1:size(test_route,1)
    t = test_route(i,:);
    % true turn patterns
    T = zeros(1, size(t, 2)-1);
    for j=1:size(t, 2)-1
        theta1 = routes(t(j)).yaw;
        theta2 = routes(t(j+1)).yaw;
        T(j) = turn_pattern(theta1, theta2, threshold);
    end
    test_turn = [test_turn; T];
end
save('test_turn_new_500_small_T.mat','test_turn');