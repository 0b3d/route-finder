% generate video
clear all;
close all;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path)); 

% Configuration
dataset = 'unionsquare5k';
city = 'manhattan';
model = 'v1';
zoom = 'z18';
params.turns = 'false';
params.probs = 'false';
params.test_num = 500;
params.accuracy = '75';
loops = 40;

load(['sub_results/','final_routes','_',dataset,'_',params.turns,'.mat'],'final_routes');
route_index = 73; % manually pick
k = find(final_routes(:,1)==route_index);
successful_route_length_es = final_routes(k,2); % successfully localised length for es
successful_route_length_bsd = final_routes(k,3);% successfully localised length for bsd

% load testing routes and turn information
load(['Localisation/test_routes/',dataset,'_routes_', num2str(params.test_num),'_' , '60','.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(params.test_num), '_' , '30','.mat']);


% Load BSD features and best estimated routes
path = fullfile('sub_results/old/BSD/', dataset, params.turns, ['best_estimated_routes_', params.accuracy, '.mat']);
load(path, 'best_estimated_routes');
bsd_ber = best_estimated_routes;

% Load BSD features
load(['features/BSD/',dataset,'/BSD','_', city,'_',dataset,'_',params.accuracy,'.mat'],'routes');
bsd_routes = routes;


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
% t = test_route(route_index,:);
% for i=1:40
%     coords(i,:) = es_routes(t(i)).gsv_coords;
% end
limits = [min(coords(:,2)) max(coords(:,2)) min(coords(:,1)) max(coords(:,1))];  
range_x = abs(limits(1) - limits(2));
range_y = abs(limits(3) - limits(4));

% Create the map
map = Map(limits, [],[],-1);
hold on;

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
        min_dist = 0;
    else        
        [bsd_estimates, min_dist] = boot_strapping(gt(key_frame), bsd_estimates, min_dist, bsd_routes, successful_route_length_bsd, 'BSD');
    end

    if key_frame <= successful_route_length_es
        es_estimates = es_ber{1, route_index}{key_frame};
        min_dist = 0;
    else        
        [es_estimates, min_dist] = boot_strapping(gt(key_frame),es_estimates, min_dist, es_routes, successful_route_length_es, 'ES');
    end
    
    
    bsdhd = display_top_routes(routes, bsd_estimates, 'b', 20);
    eshd = display_top_routes(routes, es_estimates, 'g', 25); 
    txhd = text(true_x1(key_frame) + 0.0005, true_y1(key_frame)+ 0.0005, num2str(key_frame),'FontSize',15);
    
    if key_frame < 2
        lgd = legend([hd(1) bsdhd(1) eshd(1)], ['Ground Truth',' (Route Length = ',num2str(key_frame),')'], 'BSD', 'Embedding Space','Location', 'NorthWest');
        position = lgd.Position;
    else
        lgd = legend([hd(1) bsdhd(1) eshd(1)], ['Ground Truth',' (Route Length = ',num2str(key_frame),')'], 'BSD', 'Embedding Space','Position',position);        
    end


%     px = [abs(true_x1(key_frame) - limits(1) + 0.0005),abs(true_x1(key_frame) - limits(1))]/range_x;
%     py = [abs(true_y1(key_frame) - limits(3) + 0.0005),abs(true_y1(key_frame) - limits(3))]/range_y;
%     anhd = annotation('textarrow',py,px,'String',['Route Length = ',num2str(key_frame)]);
%     dim = [0.2 0.5 0.3 0.3];
%     anhd = annotation('rectangle',dim,'FaceColor','white','String',['Route Length = ',num2str(key_frame)],'FitBoxToText','on');
    F(key_frame) = getframe(map.ax);  
    if key_frame ~= loops
        delete(bsdhd);
        delete(eshd);
        delete(hd(2)); % delete gt circle
        delete(txhd);
%         delete(anhd);
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

