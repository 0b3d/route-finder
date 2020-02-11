% features generation
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['Data/','streetlean/',dataset,'.mat']);
load(['Data/',city,'/ways.mat']);
load(['Data/',city,'/inters.mat']);
load(['Data/',city,'/buildings.mat']);

inters = inters_filter_v2(inters, ways, thresh); 
save(['Data/',city,'/inters_after_filter.mat'], 'inters');
% routes = BSD_generation(routes, inters, buildings, radius, range, thresh_jc, thresh_bd, thresh_dist);
routes = BSD_generation_v2(routes, inters, buildings, radius, range);
save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');

