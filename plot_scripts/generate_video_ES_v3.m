% generate video
clear all;
close all;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
dataset = 'london_10_19';
model = 's2v700k_v1';
params.turns = 'false';
params.probs = 'false';
params.test_num = 500;
params.threshold = 60;
params.accuracy = 75;
loops = 20;
route_index = 200;

% % Load ES best estimated routes
results_filename = ['ES_results/',model,'/',dataset,'_','ES',params.turns,params.probs,'.mat'];
load(results_filename, 'best_estimated_routes', 'routes')
es_ber = best_estimated_routes;


% % read features
% features_filename = ['features/ES/',model,'/',dataset,'.mat'];
% load(features_filename, 'X', 'Y')
% [pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);

% get pairwise distances
distances = pairwise_distances(routes);
%distances = pdist2(Y,X); %y-x distances

[sorted_distances, sorted_indices] = sort(distances, 2, 'ascend'); 
%labels = [1:1:size(Y,1)];


%Find boundaries
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
    gt_location = gt(1,key_frame);
    
    % true location
    true_x1 = zeros(key_frame,1);
    true_y1 = zeros(key_frame,1);
    
    for i=1:key_frame
        true_x1(i) = routes(gt(i)).gsv_coords(2);
        true_y1(i) = routes(gt(i)).gsv_coords(1);      
    end
        
    % display the top5 best estimated routes
    es_estimates = es_ber{1, route_index}{key_frame};
    es_location = es_estimates(1,key_frame);
    topk_indices = sorted_indices(gt_location, :);
    topk_indices = remove_duplicates_to_display_on_map(topk_indices, routes, 5);
       
    hd(1) = plot(true_x1(:,1), true_y1(:,1), '*', 'MarkerFaceColor', 'r','MarkerSize', 5, 'MarkerEdgeColor','r');
    hd(2) = plot(true_x1(key_frame), true_y1(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 15, 'LineWidth', 5);
    eshd = display_top_routes(routes, es_estimates, 'g', 20);
    rankhd = display_ranked_points_on_map(routes, topk_indices, 'none', 12);
    
    %legend([hd(1) bsdhd(1) eshd(1)], 'Ground Truth', 'BSD', 'Embedding Space');
    F(key_frame) = getframe(map.ax);  
    delete(eshd);
    delete(rankhd);
    delete(hd(2)); % delete gt circle
    parfor_progress('searching');
end

if strcmp(params.turns, 'false')
    name = [dataset, '_', num2str(route_index), '_', 'ESTop.avi'];
else
    name = [dataset, '_', num2str(route_index), '_', 'Estop.avi'];
end
    
v = VideoWriter(name,'Motion JPEG AVI');
v.FrameRate = 1;
open(v)
writeVideo(v,F)
%v.Quality = 95;
close(v)





