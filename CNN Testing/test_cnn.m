% implement CNN classifier
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load('models/junctions_latest.pth.tar');
load(['features/',features_type,'/',features_type,'_', dataset,'_',num2str(accuracy*100),'.mat']);

filepath = ['images/',dataset,''];
[Tjc, Tbd] = genTabel_testing(filepath, routes);

parfor_progress('generating', length(routes));
for i = 1:length(routes)
    bad = Cnn_classifier_v2(net1,Tjc1,net2,Tbd1,i); 
    routes(i).CNNs = bad; 
    parfor_progress('generating');
end
save(['features/',features_type,'/',features_type,'_', dataset,'.mat'],'routes');