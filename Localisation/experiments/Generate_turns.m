% generate turn patterns
clear all
close all 
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

if strcmp(dataset,'cmu5k')
    load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) '_', subset,'.mat']);
    threshold = 45;
    turn_filename = ['Localisation/test_routes/',dataset,'_turns_', num2str(test_num),'_' , num2str(threshold) , '_', subset,'.mat'];
else
    load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']);
    threshold = 45;
    turn_filename = ['Localisation/test_routes/',dataset,'_turns_', num2str(test_num),'_' , num2str(threshold) ,'.mat'];
end

load(['Data/','streetlearn/',dataset,'_new','.mat'],'routes');

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
save(turn_filename, 'test_turn');
