clear all
close all
clc
parameters;


datasets = 'london_center_09_19';
turns = 'true';
probs = 'true';

features_type = 'ES';
option = [features_type, turns ,probs]; 
load(['Data/',dataset,'/results/',option,'.mat']); %the results

%plot the top k accuracy
figure(1)
plot(ks, results)

%plot the ranking 
% compute the number of routes ranked in number one


figure(2)
plot(ranking(1:10,:)) 