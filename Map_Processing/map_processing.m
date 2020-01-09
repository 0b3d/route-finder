% map parsing and map processing
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

disp('OSM Processing......');
if ~exist(['Data/',dataset],'dir')
    [inters, buildings, roads] = OSMProcessing_v2(dataset, mapfile, road_dense_distance);
    disp('OSM Finished');
else
    disp('Folder in Data already exists')
end

%generate routes dataset
if ~isfile(['Data/',dataset,'/routes.mat'])
    disp('Dataset Generating......')
    [routes] = GenDataset_v2(roads, dataset);
    save(['Data/',dataset,'/routes.mat'], 'routes');
    disp('Dataset Finished');
else
    disp('Routes file already exists, if need a new one remove old first')
end
