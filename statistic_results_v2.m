% statistic results v2
clear all
close all
parameters;
option = [features_type, turns ,probs]; 
load(['Data/',dataset,'/results/',option,'.mat'])
accuracy_within_topK = accuracy_within_topK';
accuracy_with_threshold = accuracy_with_threshold';
