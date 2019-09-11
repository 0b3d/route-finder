clear all
close all
load('inters.mat');
load('buildings.mat');
load('roads.mat');
load('routes.mat');

radius = 30; % search radius is 30m
thresh = 10; % filter inters if their angles is below 10 degree
inters = inters_filter_v2(inters, roads, thresh);  
routes = BSD_generation_v2(routes, inters, buildings, radius);
save('routes.mat','routes');