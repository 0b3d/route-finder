% localisation with fixed-route length
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load(['Data/',dataset,'/features/',features_type,'_', dataset,'.mat']);
% load('routes_small_withBSD_75.mat');
% run 'Generate_random_routes' to get random test routes and turns
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(test_num), '_' , num2str(threshold),'.mat']);

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

test_num = size(test_route, 1);
ks = [1, 5, 10, 15, 20]; % The top k metrics will be computed
distance_thresholds = [0.1 0.2 0.3 0.4 0.5];
result = zeros(test_num, 3);
results = zeros(1,size(ks,2));
accuracy_with_threshold = zeros(1,size(distance_thresholds,2));

ranking = zeros(test_num, max_route_length_init);
failed_set = [];
ranked_points_of_routes = {max_route_length_init};

tic;
parfor_progress('searching', test_num);
for i=1:test_num

    max_route_length = max_route_length_init;
    t = test_route(i,1:max_route_length);
    T = test_turn(i,1:max_route_length-1);
    
    option = [features_type, turns ,probs]; 
    switch option
        %% ES FEATURES
        % ES with turns using distances
        case 'EStruefalse'
            location = RouteSearching_ES_withT_v2(routes, N, max_route_length, threshold, R_init, t, T);  
        % ES without turns using distances
        case 'ESfalsefalse'
            location = RouteSearching_ES_withoutT_v2(routes, N, max_route_length, R_init, t);
        % ES with turns using probs
        case 'EStruetrue'
            [location, rank, ranked_points, t_e] = RouteSearching_ES_Probs(routes, N, max_route_length, threshold, R_init, t, T);
        
        %% BSD FEATURES
        % BSD without turns
        case 'BSDfalsefalse'
        location = RouteSearching_BSD_withoutT_v2(routes, N, max_route_length, R_init, t, accuracy);
        % BSD with turns
        case 'BSDtruefalse'
        location = RouteSearching_BSD_withT_v2(routes, accuracy, N, max_route_length, threshold, R_init, t, T);
        
        %% JUST TURNS
        case 'anytrueany' 
        location = RouteSearching_onlyT_v2(routes, max_route_length, R_init, T, threshold);
        
        otherwise
            warning('Unexpected configuration')      

    end
    
    result(i,1) = t(1, size(t, 2));
    ranking(i,:) = rank;
    ranked_points_of_routes{i} = ranked_points;
    
    if size(location) == 0
        result(i,2) = 0;
    else
        result(i,2) = location;
    end
    
    idx = find(ismember(t, t_e));
    overlap_ = size(idx,2)/size(t_e,2);
    
%     if (overlap_ >= overlap) && result(i,1) == result(i,2)
%         result(i,3) = 1;
%     else
%         result(i,3) = 0;
%     end
    
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

% Top k accuracy
for i = 1:size(ks,2)
    k = ks(i);
    results(i) = sum(ranking(:,max_route_length)<=k)/test_num;
end

%% Accuracy given a threshold in km
geo_distance = zeros(test_num,size(distance_thresholds,2)+1);

for m=1:test_num
    gt_route = test_route(m,:);
    gt_index = gt_route(max_route_length_init);
    % get the gt_coords
    gt_coords = routes(gt_index).gsv_coords;
    % get the coords of the predict location
    pred_index = result(m,2);
    pred_coords = routes(pred_index).gsv_coords;
    % compute the distance in meters of gt and pred locations
    d = distance(gt_coords(1), gt_coords(2), pred_coords(1), pred_coords(2));
    geo_distance(m,1) = deg2km(d);
    for d_thres = 1:size(distance_thresholds,2)
        distance_threshold = distance_thresholds(d_thres);
        if geo_distance(m,1) < distance_threshold
            geo_distance(m,d_thres+1) = 1;
        else
            geo_distance(m,d_thres+1) = 0;
        end
    end
end

for i=1:size(distance_thresholds,2)
    accuracy_with_threshold(i) = sum(geo_distance(:,i+1)) / test_num;
end

%% Save localization test information
if ~exist(['Data/',dataset,'/results'], 'dir')
    mkdir(['Data/',dataset,'/results'])
end
save(['Data/',dataset,'/results/',option,'.mat'])
