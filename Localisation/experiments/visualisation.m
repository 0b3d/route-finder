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

load(['Data/',dataset,'/buildings.mat'])
load(['Data/',dataset,'/ways.mat'])
load(['Data/',dataset,'/naturals.mat'])
load(['Data/',dataset,'/leisures.mat'])
load(['Data/',dataset,'/boundary.mat'])
%fH = axes;
route = 2; %14

% Extract limits of the bounding box (ROI)
indices = ranked_points_of_routes{route};

coords = zeros(test_num,2);
for i=1:test_num 
    coords(i,:) = routes(i).gsv_coords;
end

limits = [min(coords(:,2)) max(coords(:,2)) min(coords(:,1)) max(coords(:,1))];
%display_map_v3(ways, buildings, naturals, leisures, boundary)
map = Map(limits); % plot OSM map
hold on;

%% Extract most freuent points in the dataset
% extract the most frequent points
% points = reshape(indices,[size(indices,1)*size(indices,2),1]);
% unique_points = unique(points);
% 
% for i=1:size(unique_points,1)
%     point = unique_points(i,1);
%     count = sum(points(:,1) == point);
%     suma(i,1)=count;
% end
% probabilities = sort(suma / size(suma,1));
% [probabilities, I] = sort(probabilities,'descend'); % core
% unique_points = unique_points(I,:) 
%plot_openstreetmap('Alpha', 0.4, 'Scale', 2);

% for i=1:min(size(indices,1),50)
%     % Plot the top 40 ranked points in blue 
%     idx = indices(i,20);
%     coords = routes(idx).gsv_coords;
%     hd(i) = plot(coords(2),coords(1),'ob','tag',num2str(idx));
%         
%     %text(coords(2)+0.0001,coords(1),num2str(i));
%     %plot the most repeating points in the dataset in green
% %     idx = unique_points(i,1);
% %     coords = routes(idx).gsv_coords;
% %     plot(coords(2),coords(1),'og');
% %     hold on;
% end

%% Plot top 10 routes 
count = 1;
for j=1:min(10,size(indices,1))
    % Plot the top 10 routes 
    for i=1:max_route_length_init
        idx = indices(j,i);
        coords = routes(idx).gsv_coords;
        hd(count) = plot(coords(2),coords(1),'ob','tag',num2str(idx));
        count = count + 1;
    end
    text(coords(2), coords(1),num2str(j))
end


%% Plot the grouth truth route
% plot the grounth truth route in yellow
gt_indices = test_route(route,:);
for i=1:max_route_length_init
    idx = gt_indices(i);
    coords = routes(idx).gsv_coords;
    hr(i) = plot(coords(2),coords(1),'oy','tag',num2str(idx));
end

%% Plot ground truth location
ground_truth = test_route(route,max_route_length);
coords_t = routes(ground_truth).gsv_coords;
hgt = plot(coords_t(2),coords_t(1),'or','tag',num2str(ground_truth));
hold on;

% To enable interactive 
set(hd,'hittest','off'); % so you can click on the Markers
set(hr,'hittest','off'); % so you can click on the Markers
set(hgt,'hittest','off'); % so you can click on the Markers
set(map.ax,'ButtonDownFcn',@getCoord2); % Defining what happens when clicking
uiwait(f) %so multiple clicks can be used
