% features generation
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['Data/',dataset,'_',area,'.mat']);
load(['Data/',dataset,'/ways.mat']);
load(['Data/',dataset,'/inters.mat']);
load(['Data/',dataset,'/buildings.mat']);

inters = inters_filter_v2(inters, ways, thresh); 
save(['Data/',dataset,'/inters_after_filter.mat'], 'inters');
% routes = BSD_generation(routes, inters, buildings, radius, range, thresh_jc, thresh_bd, thresh_dist);
routes = BSD_generation_v2(routes, inters, buildings, radius, range);
save(['features/',features_type,'/',area,'/',features_type,'_', dataset,'_',area,'.mat'],'routes');

