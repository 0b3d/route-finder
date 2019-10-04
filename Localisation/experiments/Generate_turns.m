% generate turn patterns
parameters;
load('Localisation/test_routes/route_tonbridge_500.mat'); % the test routes
load('Data/tonbridge/routes_small.mat');
test_turn = [];

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
save('Localisation/test_routes/new_turns.mat','test_turn');