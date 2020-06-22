% data generation
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
load(['features/ES/',model,'/',tile_test_zoom, '/',  dataset,'.mat']); % Load features
load(['Data/streetlearn/',dataset,'_new.mat']);

%% generate delete set
for i=1:5000
        %if index(1,i) == routes(i).oidx
        routes(i).x = X(i,:);
        routes(i).y = Y(i,:);
        %else
        %    error("Indices not match, check files ...")
        %end
end
save(['features/ES/', model,'/' , tile_test_zoom, '/','ES_',dataset,'.mat'],'routes');