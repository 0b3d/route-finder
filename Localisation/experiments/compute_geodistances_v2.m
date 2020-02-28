% This script will compute geographic distances (in meters) from the gt point in each route
% to the top-5 best estimated points in each localisation step (m)
% It will save a 3-D matrix with shape (500,40,5) into the results folder

% load routes file 
clear all
dataset = 'unionsquare5k';
model = 'v1';
zoom = 'z18';

% Load routes struct
load(fullfile('Data/streetlearn/', [dataset,'.mat']));

% Load test routes
load(fullfile('localisation/test_routes/', [dataset,'_routes_500_60.mat']));
load(fullfile('localisation/test_routes/', [dataset,'_turns_500_60.mat']));

% Load ES best estimated routes
params.features_type = 'BSD';
params.turns = 'false';
params.probs = 'false';
if strcmp(params.features_type, 'ES') 
    ESresults_filename =  fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'.mat']);
    %load(ESresults_filename, 'ranking');
    load(ESresults_filename, 'best_estimated_top5_routes');
else
    option = [params.features_type, params.turns ,params.probs]; 
    accuracy = 0.7;
    BSDresults_filename = fullfile(['results/BSD/', dataset,'/', option ,'_',num2str(accuracy*100),'.mat']); 
    load(BSDresults_filename, 'best_estimated_top5_routes');
end

% Now for each test route compute the distance in meters to the top-5 best
% estimated points
geo_distances = ones(500,40)*3000; %Initialization
for r=1:500
   for m=1:40
       gt_index = test_route(r,m);
       gt_coords = routes(gt_index).gsv_coords;
       for p=1:5
            top_points = best_estimated_top5_routes{1,r}{1,m}(:,m);       % returns a vector column with the top 5 points.
            estimated_point = top_points(p,1);
            pred_coords = routes(estimated_point).gsv_coords;
            d = distance(gt_coords(1), gt_coords(2), pred_coords(1), pred_coords(2));
            geo_distance = deg2km(d)*1000;
            geo_distances(r,m,p) = geo_distance; 
       end
   end
end

% Save results in specified folder
if strcmp(params.features_type, 'ES') 
    save(fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'_distance_threshold.mat']), 'geo_distances')
else
    save(['sub_results/BSD/',dataset,'/',option,'_',num2str(accuracy*100),'_distance_threshold_5.mat'],'geo_distances');
end
