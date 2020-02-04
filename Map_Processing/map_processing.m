% map parsing and map processing
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

disp('OSM Processing......');
if ~exist(['Data/',dataset],'dir')
    [inters, buildings, roads] = OSMProcessing(dataset, mapfile, road_dense_distance);
    disp('OSM Finished');
else
    disp('Folder in Data already exists')
end