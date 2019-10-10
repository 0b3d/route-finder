% localisation with fixed-route length
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);
% run 'Generate_random_routes' to get random test routes and turns
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(test_num), '_' , num2str(threshold),'.mat']);

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
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
dist = {test_num};

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
        % case 'ESfalsefalse'
        %    location = RouteSearching_ES_withoutT_v2(routes, N, max_route_length, R_init, t);
        
        % ES with turns using probs
        case {'EStruetrue', 'ESfalsetrue'}
            [location, rank, ranked_points, route_dist, t_e] = RouteSearching_ES_Probs(routes, N, max_route_length, threshold, R_init, t, T, turns);
        
        %% BSD FEATURES
        case {'BSDtruefalse', 'BSDfalsefalse'}    
            [location, rank, best_routes, route_dist] = RouteSearching_BSD(routes, N, max_route_length, threshold, R_init, t, T, turns, accuracy);
        
        %% JUST TURNS
        case 'ESonlyany' 
        [location, rank, ranked_points, route_dist, t_e] = RouteSearching_onlyT_v2(routes, max_route_length, R_init, T, threshold);
        
        otherwise
            warning('Unexpected configuration')      
    end
    
    ranking(i,:) = rank;
    best_estimated_routes{i} = best_routes;  
    dist{i} = route_dist;
    parfor_progress('searching');
end

time = toc;
avg_time = time/test_num;

% Accuracy with different route length based on final location
for i = 1:size(rs,2)
    r = rs(i);
    accuracy_with_different_length(1,i) = sum(ranking(:,r) == 1)/test_num;
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
            pred_index = best_estimated_routes{1,p}{1,r}(r);
            gt_coords = routes(gt_index).gsv_coords;
            if pred_index ~= 0
                pred_coords = routes(pred_index).gsv_coords;
                d = distance(gt_coords(1), gt_coords(2), pred_coords(1), pred_coords(2));
                geo_distance = deg2km(d);
                if geo_distance < dt
                    accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j) + 1;
                end
            end
        end
        accuracy_with_threshold(i,j) = accuracy_with_threshold(i,j)/test_num;        
    end    
end

%% Save localization test information
if ~exist(['Data/',dataset,'/results'], 'dir')
    mkdir(['Data/',dataset,'/results'])
end
save(['Data/',dataset,'/results/',option,'.mat'],  '-v7.3')
