% statistic reults
clear all
close all
parameters;
option = [features_type, turns ,probs]; 
load(['Data/',dataset,'/results/',option,'.mat']);

% statistic results based on final locations
percent_final = sum(result_final(:,3))/size(result_final,1);
disp(percent_final);

% statistic results based on overlap
percent_overlap = sum(result_overlap(:,3))/size(result_overlap,1);
disp(percent_overlap);