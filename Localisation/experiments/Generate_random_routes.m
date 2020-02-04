% generate random routes
clear all
close all 
parameters;

directory = ['Localisation/test_routes/'];
turn_filename = ['Localisation/test_routes/',area,'_turns_', num2str(test_num),'_' , num2str(threshold) ,'.mat'];
route_filename = ['Localisation/test_routes/',area,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat'];

if ~exist(directory, 'dir')
    mkdir(directory)
end

if ( isfile(route_filename) || isfile(turn_filename))
    display('warning! file not created because it already existed. If you need a new one remove old file or rename it')
else
    load(['features/',features_type,'/',features_type,'_', dataset,'_',area,'.mat'],'routes');
    R_init = zeros(size(routes,2),1);
    for i = 1:size(routes,2)
        R_init(i) = i;   
    end

    test_route = [];
    test_turn = [];
    f = 1; % flag
    while f == 1 || size(test_route, 1) < test_num % 500 test routes
        f = 0;
        [t, max_route_length] = RandomRoutes(R_init, routes, max_route_length_init);
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
    save(turn_filename, 'test_turn');
    save(route_filename,'test_route');
end



