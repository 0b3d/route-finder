% localisation with fixed-route length
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

if strcmp(features_type, 'ES') 
    load(['features/',features_type,'/',model,'/', tile_test_zoom, '/',features_type,'_', dataset,'.mat'],'routes');
    % load(['features/',features_type,'/',model,'/', tile_test_zoom, '/',features_type,'_', dataset,'_pr2 ','.mat']);
else
    % real classifier
    load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',network,'.mat'],'routes');
    % load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_pr','.mat'],'routes');
    % simulated classifier
    % load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
end

% run 'Generate_random_routes' to get random test routes and turns
directory = 'Localisation/test_routes_special/';
if strcmp(dataset,"cmu5k")
    load([directory, dataset,'_turns_', num2str(test_num),'_' , num2str(threshold_) , '_', subset,'.mat']);
    load([directory, dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) '_', subset,'.mat']);
else
    load([directory, dataset,'_turns_', num2str(test_num), '_' , num2str(threshold_),'.mat']);
    load([directory, dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
end

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

% in case of ES precompute pairwise distances 
if strcmp(features_type, 'ES') 
    pairwise_dist = pairwise_distances(routes);
end

test_num = size(test_route, 1);
ks = [1, 5, 10, 15, 20]; % The top k metrics will be computed
rs = [5, 10, 15, 20, 25, 30, 35, 40]; % different route length
distance_thresholds = [0 0.01 0.02 0.03];

accuracy_with_different_length = zeros(2, size(rs,2)); % row 1: final location; row 2: overlap
accuracy_within_topK = zeros(size(rs,2), size(ks,2));
accuracy_with_threshold = zeros(size(rs,2),size(distance_thresholds,2));

ranking = zeros(test_num, max_route_length_init);
best_estimated_routes = {test_num};
best_estimated_top5_routes = {test_num};
dist = {test_num};
failed_estimated_routes = {size(rs, 2)};

tic;
parfor_progress('searching', test_num);
for i=1:test_num
    max_route_length = max_route_length_init;
    t = test_route(i,1:max_route_length);
    T = test_turn(i,1:max_route_length-1);
    
    option = [features_type, turns, probs]; 
    switch option
        %% ES FEATURES
        case {'EStruetrue', 'ESfalsetrue', 'EStruefalse', 'ESfalsefalse'}
            [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_ES_Gen(routes, N, max_route_length, threshold_, R_init, t, T, turns, pairwise_dist,min_num_candidates);
            dist{i} = route_dist;
        %% BSD FEATURES
        case {'BSDtruefalse', 'BSDfalsefalse'}    
            [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_BSD(routes, N, max_route_length, threshold_, R_init, t, T, turns, min_num_candidates);
            dist{i} = route_dist;
        %% JUST TURNS
        case {'BSDonlyfalse', 'ESonlytrue', 'ESonlyfalse'}
            [location, rank, best_routes, best_top5_routes] = RouteSearching_onlyT(routes, max_route_length, R_init, t, T, threshold_);            
        otherwise
            warning('Unexpected configuration')      
    end
    
    ranking(i,:) = rank;
    best_estimated_routes{i} = best_routes; 
    best_estimated_top5_routes{i} = best_top5_routes;

    parfor_progress('searching');
end

time = toc;
avg_time = time/test_num;

% Accuracy with different route length based on final location
for i = 1:size(rs,2)
    r = rs(i);
    accuracy_with_different_length(1,i) = sum(ranking(:,r) == 1)/test_num;
    failed_estimated_routes{i} = find(ranking(:,r) ~= 1);
end

% Accuracy with different route length based on overlap
for i = 1:size(rs,2)
    r = rs(i);
    for j = 1:test_num
        t = test_route(j,1:r); 
        t_e = best_estimated_routes{1,j}{1,r};
        idx = find(ismember(t, t_e));
        overlap_ = size(idx,2)/size(t_e,2);   
        if overlap_ >= overlap
            accuracy_with_different_length(2,i) = accuracy_with_different_length(2,i) + 1;
        end
    end
    accuracy_with_different_length(2,i) = accuracy_with_different_length(2,i)/test_num;
end

% Top k accuracy based on final location with different route length
for i = 1:size(rs,2)
    r = rs(i);
    for j = 1:size(ks,2)
        k = ks(j);
        accuracy_within_topK(i,j) = sum(ranking(:,r)<=k)/test_num;
    end
end

% Accuracy given a threshold in km with different route length
for i = 1:size(rs, 2)
    r = rs(i);
    for j = 1:size(distance_thresholds, 2)
        dt = distance_thresholds(j);
        for p = 1:test_num
            gt_index = test_route(p,r);
            gt_coords = routes(gt_index).gsv_coords;
            % I added the line bellow to prevent a bug when best estimated
            % routes is empty
            if ~isempty(best_estimated_routes{1,p}{1,r})
                pred_index = best_estimated_routes{1,p}{1,r}(r);
                pred_coords = routes(pred_index).gsv_coords;
                d = distance(gt_coords(1), gt_coords(2), pred_coords(1), pred_coords(2));
                geo_distance = deg2km(d);
                if geo_distance <= dt
                    accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j) + 1;
                end
            else
                accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j) + 1; 
            end
        end
        accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j)/test_num;        
    end    
end

%% Save localization test information
if strcmp(features_type, 'ES')
    if strcmp(dataset,"cmu5k")
        resultsPath = ['results/', features_type, '/', model, '/', tile_test_zoom, '/', dataset,'_',subset];
    else
        resultsPath = ['results/', features_type, '/', model, '/', tile_test_zoom, '/', dataset];
    end
    
    if ~exist(resultsPath, 'dir')
        mkdir(resultsPath)
    end
%     save([resultsPath,'/', option ,'.mat'],  '-v7.3')
else

    if strcmp(dataset,"cmu5k")
        resultsPath = ['results/', features_type,'/',dataset,'_',subset];
    else
        resultsPath = ['results/', features_type,'/',dataset];
    end
    

    if ~exist(resultsPath, 'dir')
        mkdir(resultsPath)
    end
    % real classifier
%     save([resultsPath,'/', option,'_', network,'.mat'],  '-v7.3')
    % simulated classifier
    % save([resultsPath,'/', option ,'_',num2str(accuracy*100),'.mat'],  '-v7.3')
end

% endofscript;
