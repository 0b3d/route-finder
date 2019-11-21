% generate video
clear all;
close all;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
dataset = 'luton_v4';
model = 's2v700k_v1';
params.turns = 'false';
params.probs = 'false';
params.test_num = 500;
params.threshold = 60;
params.accuracy = 75;

% Load ES best estimated routes
filename = ['Data/',dataset,'/results/ES',params.turns, params.probs,'.mat'];
load(filename, 'best_estimated_top5_routes', 'routes')
es_ber = best_estimated_top5_routes;

%Find boundaries
load(['Data/',dataset,'/boundary.mat']);
limits = [boundary(2) boundary(4) boundary(1) boundary(3)];

% Create the map
map = Map(limits, [],[],-1);
hold on;

% load testing routes and turn information
load(['Localisation/test_routes/',dataset,'_routes_', num2str(params.test_num),'_' , num2str(params.threshold) ,'.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(params.test_num), '_' , num2str(params.threshold),'.mat']);

loops = 20;
route_index = 432;
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
    
    
    if es_location == gt_location
        color = 'g';
    else
        color = 'r';
    end
    
    hd(1) = plot(true_x1(:,1), true_y1(:,1), '*', 'MarkerFaceColor', 'r','MarkerSize', 5, 'MarkerEdgeColor','r');
    hd(2) = plot(true_x1(key_frame), true_y1(key_frame), 'o', 'MarkerEdgeColor', color,'MarkerSize', 15, 'LineWidth', 5);
    eshd = display_top_routes_v2(routes, key_frame, es_estimates, 'b', 20);
    
    %legend([hd(1) bsdhd(1) eshd(1)], 'Ground Truth', 'BSD', 'Embedding Space');
    F(key_frame) = getframe(map.ax);  
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





