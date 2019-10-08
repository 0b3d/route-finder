% features generation
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['Data/',dataset,'/routes_small.mat']);
load(['Data/',dataset,'/ways.mat']);
load(['Data/',dataset,'/inters.mat']);
load(['Data/',dataset,'/buildings.mat']);

inters = inters_filter_v2(inters, ways, thresh); 
[routes, RRecord] = BSD_generation_v2(routes, inters, buildings, radius, range);
save(['features/BSD/','BSD2_',dataset,'.mat'],'routes');
save(['Data/',dataset,'/inters_after_filter.mat'], 'inters');
save(['Data/',dataset,'/Records_2.mat'], 'RRecord');
