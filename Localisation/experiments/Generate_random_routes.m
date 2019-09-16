% generate random routes
clear all
load('Data/features/new.mat');
threshold = 60;
max_route_length_init = 40;
R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

test_route = [];
test_turn = [];
f = 1; % flag
while f == 1 || size(test_route, 1) < 500 % 500 test routes
    f = 0;
    [t, max_route_length] = RandomRoutes(R_init, routes, max_route_length_init);
%     for i=1:max_route_length
%         if isempty(routes(t(i)).BSDs)% || isempty(routes(t(i)).x) 
%             f = 1;
%             break;
%         end  
%     end
    if f == 0
        if ~isempty(test_route) && sum(ismember(test_route, t, 'rows')) % check the uniqueness 
            continue;
        else
            T = zeros(1, size(t, 2)-1);
            for i=1:size(t, 2)-1
                theta1 = routes(t(i)).gsv_yaw;
                theta2 = routes(t(i+1)).gsv_yaw;
                T(i) = turn_pattern(theta1, theta2, threshold);
            end
            test_route = [test_route; t];
            test_turn = [test_turn; T];
        end
    end
end
save('Data/test_turn_500.mat', 'test_turn');
save('Data/test_route_500.mat','test_route');
