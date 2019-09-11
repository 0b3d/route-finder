clear all
close all


addpath(genpath('dependencies'));

disp('OSM Processing......');
[inters, buildings, roads] = OSMProcessing_v2();
disp('OSM Finished');

disp('Dataset Generating......')
[routes] = GenDataset_v2(roads);
save('routes.mat', 'routes');
disp('Dataset Finished');

