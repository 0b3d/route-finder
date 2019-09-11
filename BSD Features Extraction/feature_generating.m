% features generation
clear all
close all
load('inters.mat');
load('buildings.mat');
load('ways.mat');
load('routes_small.mat');

addpath(genpath('/Users/zhoumengjie/Desktop/route-finder/dependencies'));

radius = 30; % search radius is 30m
thresh = 10; % filter inters if their angles is below 10 degree
inters = inters_filter_v2(inters, ways, thresh);  
routes = BSD_generation_v2(routes, inters, buildings, radius);
save('routes_small_withBSD.mat','routes');