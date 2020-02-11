% features generation
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['Data/','streetlearn/',dataset,'.mat']);
load(['Data/',city,'/ways.mat']);
load(['Data/',city,'/inters.mat']);
load(['Data/',city,'/buildings.mat']);

file = ['Data/',city,'/inters_after_filter.mat'];
if ~exist(file,'file')
    inters = inters_filter_v2(inters, ways, thresh); 
    save(['Data/',city,'/inters_after_filter.mat'], 'inters');
else
    load(['Data/',city,'/inters_after_filter.mat'], 'inters');
end

directory = ['features/',features_type,'/',dataset,'/'];
if ~exist(directory, 'dir')
    % routes = BSD_generation(routes, inters, buildings, radius, range, thresh_jc, thresh_bd, thresh_dist);
    routes = BSD_generation_v2(routes, inters, buildings, radius, range);
    save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
    disp('BSD Finishes');
else
    disp('Folder in features already exists')
end

