% features generation
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load('Data/inters.mat');
load('Data/buildings.mat');
load('Data/ways.mat');
load('Data/routes_small.mat');

radius = 30; % search radius is 30m
thresh = 10; % filter inters if their angles is below 10 degree
inters = inters_filter_v2(inters, ways, thresh);  
routes = BSD_generation_v2(routes, inters, buildings, radius);
save('Data/routes_small_withBSD.mat','routes');