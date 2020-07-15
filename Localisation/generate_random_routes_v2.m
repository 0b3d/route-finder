% generate random routes
clear all
close all 
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

directory = 'Localisation/test_routes_special/';

if strcmp(dataset,'cmu5k')
    turn_filename = ['Localisation/test_routes_special/',dataset,'_turns_', num2str(test_num),'_' , num2str(threshold_) , '_', subset,'.mat'];
    route_filename = ['Localisation/test_routes_special/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) '_', subset,'.mat'];
else
    turn_filename = ['Localisation/test_routes_special/',dataset,'_turns_', num2str(test_num),'_' , num2str(threshold_) ,'.mat'];
    route_filename = ['Localisation/test_routes_special/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat'];
end


if ~exist(directory, 'dir')
    mkdir(directory)
end

if (isfile(route_filename) || isfile(turn_filename))
    display('warning! file not created because it already existed. If you need a new one remove old file or rename it')
else
    load(['Data/','streetlearn/',dataset,'_new','.mat'],'routes');
    if strcmp(dataset,'wallstreet5k') || strcmp(dataset,'hudsonriver5k')
        load(['Data/','streetlearn/',dataset,'_','highwayflags','.mat'],'highway_flag');
    else
        highway_flag = zeros(1,5000);
    end

    R_init = zeros(size(routes,2),1);
    for i = 1:size(routes,2)
        R_init(i) = i;   
    end

    test_route = [];
    test_turn = [];
    while size(test_route, 1) < test_num % 50 test routes
        [t, max_route_length] = RandomRoutes(R_init, routes, max_route_length_init);
        if (~isempty(test_route) && sum(ismember(test_route, t, 'rows'))) || ~sum(highway_flag(t))% check the uniqueness 
            continue;
        else
            T = zeros(1, size(t, 2)-1);
            for i=1:size(t, 2)-1
                theta1 = routes(t(i)).gsv_yaw;
                theta2 = routes(t(i+1)).gsv_yaw;
                T(i) = turn_pattern(theta1, theta2, threshold_);
            end
            test_route = [test_route; t];
            test_turn = [test_turn; T];
        end
    end
    save(turn_filename, 'test_turn');
    save(route_filename,'test_route');
    
end




