% localisation with fixed-route length
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

if strcmp(features_type, 'ES') 
    load(['features/',features_type,'/','s2v700k_v1','/',features_type,'_', dataset,'.mat']);
else
    load(['features/',features_type,'/',features_type,'_', dataset,'_',area,'_',num2str(accuracy*100),'.mat'],'routes');
end

% run 'Generate_random_routes' to get random test routes and turns
load(['Localisation/test_routes/',area,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
load(['Localisation/test_routes/',area,'_turns_', num2str(test_num), '_' , num2str(threshold),'.mat']);

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

% For eficiency pre-compute all pairwise distances in the dataset and its probabilities
% This arrays are only used in case of ES features
if strcmp(features_type, 'ES') 
    pairwise_dist = pairwise_distances(routes);
    matched_pairwise_probs = lognpdf(pairwise_dist,0.465901,0.309151);
    unmatched_pairwise_probs = evpdf(pairwise_dist, 4.34925, 0.489259);
    %dxy_match_probs = norm
    
    %[gm, pairwise_probs] = fitgmmodel(pairwise_dist);
end

test_num = size(test_route, 1);
ks = [1, 5, 10, 15, 20]; % The top k metrics will be computed
rs = [5, 10, 15, 20, 25, 30, 35, 40]; % different route length
distance_thresholds = [0.1 0.2 0.3 0.4 0.5];

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
    
    option = [features_type, turns ,probs]; 
    switch option
        %% ES FEATURES
        % ES with turns using distances
        %case {'EStruefalse', 'ESfalsefalse'}
        %    [location, rank, best_routes, route_dist] = RouteSearching_ES_withT_v2(routes, N, max_route_length, threshold, R_init, t, T, turns);        
        % ES with turns using probs
        case {'EStruetrue', 'ESfalsetrue', 'EStruefalse', 'ESfalsefalse'}
            [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_ES_Gen(routes, N, max_route_length, threshold, R_init, t, T, turns, probs, pairwise_dist, matched_pairwise_probs, unmatched_pairwise_probs);
        
        %% BSD FEATURES
        case {'BSDtruefalse', 'BSDfalsefalse'}    
            [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_BSD(routes, N, max_route_length, threshold, R_init, t, T, turns, accuracy);
        
        %% JUST TURNS
        case {'BSDonlyfalse', 'ESonlytrue', 'ESonlyfalse'}
        [location, rank, best_routes, best_top5_routes, route_dist] = RouteSearching_onlyT_v2(routes, max_route_length, R_init, t, T, threshold);
        
        otherwise
            warning('Unexpected configuration')      
    end
    
    ranking(i,:) = rank;
    best_estimated_routes{i} = best_routes; 
    best_estimated_top5_routes{i} = best_top5_routes;
    dist{i} = route_dist;
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
                if geo_distance < dt
                    accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j) + 1;
                end
            else
                accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j) + 1; % !!!!check
            end
        end
        accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j)/test_num;        
    end    
end

%% Save localization test information
if ~exist(['Data/',area,'/results'], 'dir')
    mkdir(['Data/',area,'/results'])
end

if strcmp(features_type, 'ES') 
    save(['Data/',area,'/results/',option,'.mat'],  '-v7.3')
else
    save(['Data/',area,'/results/',option,'_',num2str(accuracy*100),'.mat'],  '-v7.3')
end
