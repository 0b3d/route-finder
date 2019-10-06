clear all
close all
clc
parameters;


datasets = {'london_10_19', 'edinburgh_10_19','oxford_10_19'};
turns = 'true';
probs = 'true';

features_type = 'ES';
option = [features_type, turns ,probs]; 

%plot the top k accuracy
figure(1)
plot(ks, results)
xlabel('Top k accuracy')

%% plot the percent of routes correctly localized as a function of length route
% It only takes into account the last position 
    
figure(2)
k = 1;
for d=1:length(datasets)
    dataset = datasets{d};
    load(['Data/',dataset,'/results/',option,'.mat']); %the results
    plot(sum(ranking <= k, 1)./size(ranking,1))
    hold on
end

xlabel('Node')
ylabel('Percentage of routes ranked in top 1')
legend(string(datasets))

% Distribution of points in ranked_points

