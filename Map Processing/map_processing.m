% map parsing and map processing
clear all
close all

% In the next line 'dev' refers to an environment variable in my computer
% which is the path to the directory where I cloned this repository (my local working dir).
% I suggest you adding also an environment variable to your operative
% system and if you name it also 'dev' we won't have any problems with
% the paths. Otherwise just change the path to point to you repository and
% comment my line.

path = fullfile(getenv('dev'), 'route-finder');

addpath(genpath(path));

disp('OSM Processing......');
[inters, buildings, roads] = OSMProcessing_v2();
disp('OSM Finished');

disp('Dataset Generating......')
[routes] = GenDataset_v2(roads);
save('Data/routes.mat', 'routes');
disp('Dataset Finished');

