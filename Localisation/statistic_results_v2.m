% statistic results v2
clear all
close all
parameters;
option = [features_type, turns ,probs]; 
if strcmp(features_type, 'ES') 
    resultsPath = ['results/', features_type, '/', model, '/', tile_test_zoom, '/', dataset];
    load( [resultsPath,'/', option ,'.mat'])
else
    resultsPath = ['results/', features_type,'/',dataset];
    load([resultsPath,'/', option ,'_',num2str(accuracy*100),'.mat']);
end
accuracy_within_topK = accuracy_within_topK';
accuracy_with_threshold = accuracy_with_threshold';

% save(['results/',dataset,'/',ranking_',num2str(accuracy*100),'.mat'],  'ranking');
% save(['results/',dataset,'/','best_estimated_routes_',num2str(accuracy*100),'.mat'], 'best_estimated_routes');

