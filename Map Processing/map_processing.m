% map parsing and map processing
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

disp('OSM Processing......');
[inters, buildings, roads] = OSMProcessing_v2(dataset, mapfile);
disp('OSM Finished');

%generate routes dataset
disp('Dataset Generating......')
[routes] = GenDataset_v2(roads);
save(['Data/',dataset,'/routes.mat'], 'routes');
disp('Dataset Finished');