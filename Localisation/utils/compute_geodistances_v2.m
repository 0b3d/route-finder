% This script will compute geographic distances (in meters) from the gt point in each route
% to the top-5 best estimated points in each localisation step (m)
% It will save a 3-D matrix with shape (500,40,5) into the results folder

%% Parameters 
clear all
parameters;
option = [features_type, turns ,probs]; 
% Load routes struct
load(fullfile('Data/streetlearn/', [dataset,'_new.mat']));

%% Load test routes
load(fullfile('localisation/test_routes/', [dataset,'_routes_500_',num2str(threshold),'.mat']));

% Load best estimated top 5 routes
if strcmp(features_type, 'ES') 
    ESresults_filename =  fullfile('results/ES', model, tile_test_zoom, dataset,[option,'.mat']);
    %load(ESresults_filename, 'ranking');
    load(ESresults_filename, 'best_estimated_top5_routes');
else
    accuracy = 0.7;
    BSDresults_filename = fullfile(['results/BSD/', dataset,'/', option ,'_',num2str(accuracy*100),'.mat']); 
    load(BSDresults_filename, 'best_estimated_top5_routes');
end

%% Now for each test route compute the distance in meters to the top-5 best
% estimated points
geo_distances = ones(500,40,5)*3000; %Initialization
for r=1:500
   for m=1:40
       gt_index = test_route(r,m);
       gt_coords = routes(gt_index).gsv_coords;
       top_points = best_estimated_top5_routes{1,r}{1,m}(:,m);
       np = size(top_points,1); % returns a vector column with the top 5 points or less in some cases.
       np = min(5, np);
       for p=1:np
            estimated_point = top_points(p,1);
            pred_coords = routes(estimated_point).gsv_coords;
            d = distance(gt_coords(1), gt_coords(2), pred_coords(1), pred_coords(2));
            geo_distance = deg2km(d)*1000;
            geo_distances(r,m,p) = geo_distance; 
       end
   end
end

%% Save results in specified folder
if strcmp(features_type, 'ES') 
    save(fullfile('results/ES', model, tile_test_zoom, dataset,[option,'_distance_threshold_5.mat']), 'geo_distances')
else
    save(['sub_results/BSD/',dataset,'/',option,'_',num2str(accuracy*100),'_distance_threshold_5.mat'],'geo_distances');
end
