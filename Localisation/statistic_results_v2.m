% statistic results v2
clear all
close all
parameters;
option = [features_type, turns ,probs]; 
if strcmp(features_type, 'ES') 
    load(['Data/',area,'/results/',option,'.mat']);
else
    load(['Data/',area,'/results/',option,'_',num2str(accuracy*100),'.mat'])
end
accuracy_within_topK = accuracy_within_topK';
accuracy_with_threshold = accuracy_with_threshold';

% save(['results/',area,'/',ranking_',num2str(accuracy*100),'.mat'],  'ranking');
% save(['results/',area,'/','best_estimated_routes_',num2str(accuracy*100),'.mat'], 'best_estimated_routes');

