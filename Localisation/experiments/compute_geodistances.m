% This script will compute accuracy based on the top-k last point
% This means a route will be given by localised if the last point of the
% estimated route is within a radius of R meters from the gt 

% load routes file 
clear all
dataset = 'unionsquare5k';
model = 'v1'
zoom = 'z18'

% Load routes struct
load(fullfile('Data/streetlearn/', [dataset,'.mat']));

% Load test routes
load(fullfile('localisation/test_routes/', [dataset,'_routes_500_60.mat']));
load(fullfile('localisation/test_routes/', [dataset,'_turns_500_60.mat']));

% Load ES best estimated routes
params.features_type = 'ES';
params.turns = 'true';
params.probs = 'false';
ESresults_filename =  fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'.mat']);
%load(ESresults_filename, 'ranking');
load(ESresults_filename, 'best_estimated_top5_routes');

% Now for each test route check if the estimated point is within a radius R of the gt
geo_distances = ones(500,40)*3000;
for r=1:500
   for m=1:40
       gt_index = test_route(r,m);
       gt_coords = routes(gt_index).gsv_coords;
       top_points = best_estimated_top5_routes{1,r}{1,m}(:,m);       % returns a vector column with the top 5 points.
       best_estimated_point = top_points(1,1);
       pred_coords = routes(best_estimated_point).gsv_coords;
       d = distance(gt_coords(1), gt_coords(2), pred_coords(1), pred_coords(2));
       geo_distance = deg2km(d)*1000;
       geo_distances(r,m) = geo_distance; 
       %if geo_distance < R
       %     results(r,m) = 1;
       %end
   end
end

% Save results in specified folder
save(fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'_distance_threshold.mat']), 'geo_distances')