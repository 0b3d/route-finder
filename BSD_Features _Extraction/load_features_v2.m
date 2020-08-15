% correlate each image with features from combined network
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load features
load('models/combined/hd_features.mat','features')

% correlate features
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
for i=1:length(routes)
    bad = double(features(i,:));
    routes(i).CNNs = bad;    
end
save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',network,'.mat'],'routes');







