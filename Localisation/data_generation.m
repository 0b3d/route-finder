% data generation
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
load('mat_files/z19/epoch_8_locations/london_center_07_19.mat');

%% generate delete set
str = 'None                  ';
for i=1:length(routes)
    if strcmp(pano_id(i,:), str)
        routes(i).id = [];
        routes(i).gsv_coords = [];
        routes(i).gsv_yaw = [];
        routes(i).x = [];
        routes(i).y = [];
    else
        routes(i).id = pano_id(i,:);
        routes(i).gsv_coords = [str2double(gsv_lat(i,:)), str2double(gsv_lon(i,:))];
        routes(i).gsv_yaw = str2double(gsv_yaw(i,:));
        routes(i).x = X(i,:);
        routes(i).y = Y(i,:);
    end
end
