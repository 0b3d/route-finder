% localisation with fixed-route length
clear all
close all
addpath(genpath('/Users/zhoumengjie/Desktop/route-finder/dependencies'));
addpath(genpath('experiments'));
load('london_BSD_new75_small.mat');
% load('routes_small_withBSD_75.mat');
load('test_route_new_500_small.mat');
load('test_turn_new_500_small.mat');


accuracy = 0.75;
threshold = 60;
max_route_length_init = 20;
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];


R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

test_num = size(test_route, 1);
result = zeros(test_num, 3);
t_estimated = [];
t_truth = [];
failed_set = [];

tic;
parfor_progress('testing', test_num);
for i=1:test_num  

    max_route_length = max_route_length_init;
    t = test_route(i,1:max_route_length);
    T = test_turn(i,1:max_route_length-1);
    
%     location = RouteSearching_uc(routes, N, max_route_length, R_init, t);
%     location = RouteSearching_uc_withT(routes, N, max_route_length, threshold, R_init, t, T);
    [location,t_] = RouteSearching_v3(routes, accuracy, N, max_route_length, threshold, R_init, t, T); % bit_flipped
%     location = RouteSearching_v9(routes, N, max_route_length, threshold, R_init, t, T); % cnn_classifier
%     location = RouteSearching_v3_noT(routes, accuracy, N, max_route_length, R_init, t);
%     location = RouteSearching_v9_noT(routes, N, max_route_length, R_init, t);
    t_estimated = [t_estimated;t_];
    t_truth = [t_truth; t];
    
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
      
    parfor_progress('testing');
end
time = toc;
avg_time = time/test_num;
percent = sum(result(:,3))/size(result,1);
