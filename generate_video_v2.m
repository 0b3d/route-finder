% generate video -v2
% generate video
clear all;
close all;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% Configuration
dataset = 'luton_v4';
model = 's2v700k_v1';
params.turns = 'true';
params.probs = 'false';
params.test_num = 500;
params.threshold = 60;
params.accuracy = 75;
loops = 30;
successful_route_length_es = 20; % successfully localised length for es
successful_route_length_bsd = 20; % successfully localised length for bsd
route_index = 365;

% Load BSD features and estimated routes
%bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
%load(bsd_results_file, 'ranking')
if strcmp(params.turns, 'true')
    bsd_estimated_routes_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
    load(bsd_estimated_routes_file, 'best_estimated_routes');
else
    bsd_estimated_routes_file = ['ES_results/BSD/results/',dataset,'/results/', 'best_estimated_route','_',num2str(params.accuracy),'.mat'];
    load(bsd_estimated_routes_file, 'best_estimated_routes');
end

bsd_ber = best_estimated_routes;


% Load ES best estimated routes
params.features_type = 'ES';
results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'best_estimated_routes', 'routes');
es_ber = best_estimated_routes;

%Find boundaries limits
load(['Data/',dataset,'/boundary.mat']);
limits = [boundary(2) boundary(4) boundary(1) boundary(3)];

% Create the map
map = Map(limits, [],[],-1);
hold on;


% load testing routes and turn information
load(['Localisation/test_routes/',dataset,'_routes_', num2str(params.test_num),'_' , num2str(params.threshold) ,'.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(params.test_num), '_' , num2str(params.threshold),'.mat']);

F(loops) = struct('cdata',[],'colormap',[]);
parfor_progress('searching', loops);


for key_frame = 1:loops
    % draw background image     
    %display_map_v3(ways, buildings, naturals, leisures, boundary);
    
    % display the ground  truth
    gt = test_route(route_index,1:key_frame);
    
    % true location
    true_x1 = zeros(key_frame,1);
    true_y1 = zeros(key_frame,1);
    
    for i=1:key_frame
        true_x1(i) = routes(gt(i)).gsv_coords(2);
        true_y1(i) = routes(gt(i)).gsv_coords(1);      
    end
    
    hd(1) = plot(true_x1(:,1), true_y1(:,1), '*', 'MarkerFaceColor', 'r','MarkerSize', 5, 'MarkerEdgeColor','r');
    hd(2) = plot(true_x1(key_frame), true_y1(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 15, 'LineWidth', 5);
    
    % display the best estimated route
    if key_frame <= successful_route_length_bsd
        bsd_estimates = bsd_ber{1, route_index}{key_frame};
    else
        min_dist = hamming_dist(gt, bsd_estimates);
        [bsd_estimates, min_dist] = Bootstrapping_v2(bsd_estimates, min_dist, routes, successful_route_length_bsd);
    end

    if key_frame <= successful_route_length_es
        es_estimates = es_ber{1, route_index}{key_frame};
    else
        min_dist = hamming_dist(gt, es_estimates);
        [es_estimates, min_dist] = Bootstrapping_v2(es_estimates, min_dist, routes, successful_route_length_es);
    end
    
    
    bsdhd = display_top_routes(routes, bsd_estimates, 'b', 20);
    eshd = display_top_routes(routes, es_estimates, 'g', 25);    
    legend([hd(1) bsdhd(1) eshd(1)], 'Ground Truth', 'BSD', 'Embedding Space');
    F(key_frame) = getframe(map.ax);  
    delete(bsdhd);
    delete(eshd);
    delete(hd(2)); % delete gt circle
    parfor_progress('searching');
end

if strcmp(params.turns, 'false')
    name = [dataset, '_', num2str(route_index), '_', 'without_turn.avi'];
else
    name = [dataset, '_', num2str(route_index), '_', 'with_turn.avi'];
end
    
v = VideoWriter(name,'Uncompressed AVI');
v.FrameRate = 1;
open(v)
writeVideo(v,F)
close(v)

