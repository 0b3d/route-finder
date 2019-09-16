% map parsing and map processing
clear all
close all

% Add repository path
path =  fullfile(pwd)
addpath(genpath(path));

disp('OSM Processing......');
[inters, buildings, roads] = OSMProcessing_v2();
disp('OSM Finished');

disp('Dataset Generating......')
[routes] = GenDataset_v2(roads);
save('Data/routes.mat', 'routes');
disp('Dataset Finished');

