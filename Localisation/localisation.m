% localisation with fixed-route length
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load('Data/features/new.mat');
load('Data/routes_small_withBSD_50_75.mat'); % load your own features
load('Data/test_route_500.mat');
load('Data/test_turn_500.mat');
% load('Data/cardiff/routes_small_withBSD_75.mat');
% load('Data/test_routes/tonbridge_routes_500_30.mat'); 
% load('Data/test_routes/tonbridge_turns_500_30.mat');



accuracy = 0.75;
threshold = 60;
max_route_length_init = 20; % change the route length here
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];


R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

test_num = size(test_route, 1);
result = zeros(test_num, 3);
failed_set = [];

tic;
parfor_progress('searching', test_num);
for i=1:test_num  

    max_route_length = max_route_length_init;
    t = test_route(i,1:max_route_length);
    T = test_turn(i,1:max_route_length-1);
    
%     location = RouteSearching_onlyT_v2(routes, max_route_length, R_init, T, threshold);
%     location = RouteSearching_BSD_withoutT_v2(routes, N, max_route_length, R_init, t, accuracy);
    location = RouteSearching_BSD_withT_v2(routes, accuracy, N, max_route_length, threshold, R_init, t, T);
%     location = RouteRearching_ES_withoutT_v2(routes, N, max_route_length, R_init, t);
%     location = RouteRearching_ES_withT_v2(routes, N, max_route_length, threshold, R_init, t, T);
    
    
    result(i,1) = t(1, size(t, 2));
    if size(location) == 0
        result(i,2) = 0;
    else
        result(i,2) = location;
    end
    
    if result(i,1) == result(i,2)
        result(i,3) = 1;
    else
        result(i,3) = 0;
        failed_set = [failed_set;result(i,:) i];
    end
      
    parfor_progress('searching');
end
time = toc;
avg_time = time/test_num;
percent = sum(result(:,3))/size(result,1);
