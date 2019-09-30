% localisation with consistency metric
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load('Data/routes_small_withBSD_75.mat'); % load your own features
load('Data/test_route_500.mat');
load('Data/test_turn_500.mat');
% load('Data/tonbridge/routes_small_withBSD_75.mat');
% load('Data/test_routes/route_tonbridge_500.mat'); 
% load('Data/test_routes/turn_tonbridge_500.mat');
% load('Data/test_routes/turn_tonbridge_500_30thresh.mat');

% parameters
threshold = 60; % if the degree between node is over 60 degree, there's a turn
max_route_length = 40;
accuracy = 0.75; % CNN accuracy 75%
failed_set = [];
% thresholding
% N = [100, 100, 100, 100, 100, 100, 95, 95, 95, 90, 90, 90, 85, 85, 85, 80, 80, 80,...
%     75, 75, 75, 70, 70, 70, 65, 65, 65, 60, 60, 60, 55, 55, 55, 50, 50, 50, 45, 45, 45, 40];
% brute-force
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
     
    
overlap = 0.8; % 80%
s_number = 5; % 5 successive locations

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

% test 200/500/1500 routes
test_num = size(test_route,1);
result = zeros(test_num, 5);
tic;
parfor_progress('searching', test_num);
for i=1:test_num  
    t = test_route(i,:);
    T = test_turn(i,:);
    
%     [location, location_, m_, flag] = RouteSearching_onlyT_new(routes, max_route_length, R_init, t, T, overlap, s_number, threshold);
%     [location, location_, m_, flag, ~] = RouteSearching_BSD_withoutT_new(routes, N, max_route_length, R_init, t, overlap, s_number, accuracy);
    [location, location_, m_, flag, ~] = RouteSearching_BSD_withT_new(routes, N, max_route_length, R_init, t, T, overlap, s_number, threshold, accuracy);
%     [location, location_, m_, flag, ~] = RouteSearching_ES_withoutT(routes, N, max_route_length, R_init, t, overlap, s_number);
%     [location, location_, m_, flag, ~] = RouteSearching_ES_withT(routes, N, max_route_length, R_init, t, T, overlap, s_number, threshold);
        
    result(i,1) = location;
    if size(location_) == 0
        result(i,2) = 0;
    else
        result(i,2) = location_;
    end

    if result(i,1) == result(i,2)
        result(i,3) = 1;
    else
        result(i,3) = 0;
    end
    
    
    result(i,4) = flag;
    result(i,5) = m_;     
    parfor_progress('searching');
end
time = toc;
avg_time = time/test_num;

% results statistic
num_5 = 0;
num_10 = 0;
num_15 = 0;
num_20 = 0;
num_25 = 0;
num_30 = 0;
num_35 = 0;
num_40 = 0;
for i=1:length(result)
    if result(i,3) == 1 
        route_length = result(i,5);
        if route_length <= 5
            num_5 = num_5 + 1;
        end
        if route_length <= 10
            num_10 = num_10 + 1;
        end
        if route_length <= 15
            num_15 = num_15 + 1;
        end
        if route_length <= 20
            num_20 = num_20 + 1;
        end 
        if route_length <= 25
            num_25 = num_25 + 1;
        end
        if route_length <= 30
            num_30 = num_30 + 1;
        end
        if route_length <= 35
            num_35 = num_35 + 1;
        end
        if route_length <= 40
            num_40 = num_40 + 1;
        end
    else
        failed_set = [failed_set;result(i,:) i];
    end    
end
percent_5 = num_5/test_num;
percent_10 = num_10/test_num;
percent_15 = num_15/test_num;
percent_20 = num_20/test_num;
percent_25 = num_25/test_num;
percent_30 = num_30/test_num;
percent_35 = num_35/test_num;
percent_40 = num_40/test_num;
% save('failed_set.mat','failed_set');
