% features generation
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['features/',dataset,'/routes_small.mat']);

inters = inters_filter_v2(inters, ways, thresh); 
routes = BSD_generation_v2(routes, inters, buildings, radius);
save(['features/','BSD_',dataset,'.mat'],'routes');
save(['Data/',dataset,'/inters_after_filter.mat'], 'inters');
