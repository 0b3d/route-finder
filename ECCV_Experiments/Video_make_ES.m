% generate video
clear all;
close all;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path)); 

% Configuration
dataset = 'unionsquare5k';
model = 'v2_12';
zoom = 'z19';
params.turns = 'false';
params.probs = 'false';
params.test_num = 500;
loops = 40;
route_index = 1;  % anyone you want

% load testing routes and turn information
load(['Localisation/test_routes/',dataset,'_routes_', num2str(params.test_num),'_' , '60','.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(params.test_num), '_' , '30','.mat']);


% Load ES best estimated routes
params.features_type = 'ES';
results_filename = ['results/ES/',model,'/',zoom,'/',dataset,'/',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'best_estimated_routes', 'routes');
es_ber = best_estimated_routes;
es_routes = routes;

% Find boundaries limits
coords = zeros(5000,2);
for i=1:5000 
    coords(i,:) = es_routes(i).gsv_coords;
end

limits = [min(coords(:,2)) max(coords(:,2)) min(coords(:,1)) max(coords(:,1))];  
range_x = abs(limits(1) - limits(2));
range_y = abs(limits(3) - limits(4));

% Create the map
map = Map(limits, [],[],-1);
hold on;

F(loops) = struct('cdata',[],'colormap',[]);
parfor_progress('searching', loops);


for key_frame = 1:loops
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
    es_estimates = es_ber{1, route_index}{key_frame};
    eshd = display_top_routes(routes, es_estimates, 'g', 25); 
    txhd = text(true_x1(key_frame) + 0.0005, true_y1(key_frame)+ 0.0005, num2str(key_frame),'FontSize',15);
    
    if key_frame < 2
        lgd = legend([hd(1) eshd(1)], ['Ground Truth',' (Route Length = ',num2str(key_frame),')'], 'Embedding Space','Location', 'NorthWest');
        position = lgd.Position;
    else
        lgd = legend([hd(1) eshd(1)], ['Ground Truth',' (Route Length = ',num2str(key_frame),')'], 'Embedding Space','Position',position);        
    end

   F(key_frame) = getframe(map.ax);  
    if key_frame ~= loops
        delete(bsdhd);
        delete(eshd);
        delete(hd(2)); % delete gt circle
        delete(txhd);
    end
    parfor_progress('searching');
end

if strcmp(params.turns, 'false')
    name = [dataset, '_', num2str(route_index), '_', 'without_turn.avi'];
else
    name = [dataset, '_', num2str(route_index), '_', 'with_turn.avi'];
end
    
v = VideoWriter(name, 'Motion JPEG AVI');
v.Quality = 95;
v.FrameRate = 1; % smaller, slower
open(v)
writeVideo(v,F)
close(v)

