% statistic results v2
clear all
close all
parameters;
option = [features_type, turns ,probs]; 
if strcmp(features_type, 'ES') 
    resultsPath = ['results/', features_type, '/', model, '/', tile_test_zoom, '/', dataset];
    load( [resultsPath,'/', option ,'.mat'])
    sub_resultsPath = ['sub_results/', features_type, '/', model, '/', tile_test_zoom, '/', dataset,'/',turns];
else
    resultsPath = ['results/', features_type,'/',dataset];
    load([resultsPath,'/', option ,'_',num2str(accuracy*100),'.mat']);
    sub_resultsPath = ['sub_results/old/', features_type,'/',dataset,'/',turns];
end
accuracy_within_topK = accuracy_within_topK';
accuracy_with_threshold = accuracy_with_threshold';

if ~exist(sub_resultsPath,'dir')
    mkdir(sub_resultsPath);
end
save([sub_resultsPath,'/','ranking_',num2str(accuracy*100),'.mat'],  'ranking');
save([sub_resultsPath,'/','best_estimated_routes_',num2str(accuracy*100),'.mat'], 'best_estimated_routes');

