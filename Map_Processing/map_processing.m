% map parsing and map processing
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

disp('OSM Processing......');
if ~exist(['Data/',city],'dir')
    [inters, buildings] = OSMProcessing(city, mapfile);
    disp('OSM Finished');
else
    disp('Folder in Data already exists')
end