% localisation with fixed-route length
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load(['features/',features_type,'/',features_type,'_',dataset,'.mat']);
% load('routes_small_withBSD_75.mat');
% run 'Generate_random_routes' to get random test routes and turns
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(test_num), '_' , num2str(threshold),'.mat']);
option = [features_type, turns, probs];
load(['Data/',dataset,'/results/',option,'.mat']);

%fH = axes;
route = 1; %14

coords = zeros(test_num,2);
for i=1:test_num 
    coords(i,:) = routes(i).gsv_coords;
end

limits = [min(coords(:,2)) max(coords(:,2)) min(coords(:,1)) max(coords(:,1))];   
indices = ranked_points_of_routes{route}{40};

%display_map_v3(ways, buildings, naturals, leisures, boundary)
map = Map(limits); % plot OSM map
pause;
hold on;
max_route_length_init = 40;
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 1;
open(writerObj);

%% Plot the grouth truth route
for m=1:max_route_length_init
    % Start with a clean chart
    if m > 1
        delete(hproposed);
    end
    %% Plot best ranked routes 
    % read 5 best routes
    pred_routes = ranked_points_of_routes{route}{1,m}(1:5,:);
    for i=1:size(pred_routes,1)
        for j=1:size(pred_routes,2)
            idx = pred_routes(i,j);
            coords = routes(idx).gsv_coords;
            hproposed(i,j) = plot(coords(2),coords(1),'ob','tag',num2str(idx));
        end
    end
    %% Plot ground truth
    idx = test_route(route,m);
    coords = routes(idx).gsv_coords;
    hr(m) = plot(coords(2),coords(1),'or','tag',num2str(idx));
    
    if idx == pred_routes(1,m)
        set(hr, 'color', 'g');
    end
    frame = getframe(map.ax);
    writeVideo(writerObj, frame);
    
    hold on;
    pause;
end
close(writerObj);

