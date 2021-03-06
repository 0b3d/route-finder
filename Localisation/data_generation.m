% data generation
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
load('Data/features/ES_london_center_09_19.mat');
load('Data/routes_small.mat');
routes2 = routes;

%% generate delete set
str = 'None                  ';
for i=1:length(pano_id)
    if strcmp(pano_id(i,:), str)
        routes(i).id = [];
        routes(i).gsv_coords = [];
        routes(i).gsv_yaw = [];
        routes(i).neighbor = [];
        routes(i).x = [];
        routes(i).y = [];
    else
        routes(i).id = pano_id(i,:);
        routes(i).gsv_coords = [gsv_lat(i), gsv_lon(i)];
        routes(i).gsv_yaw = gsv_yaw(i);
        routes(i).neighbor = routes2(i).neighbor;
        routes(i).x = X(i,:);
        routes(i).y = Y(i,:);
    end
end
save('Data/features/new.mat','routes');