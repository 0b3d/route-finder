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



%% plots section
clear all
close all
clc
parameters;


datasets = {'london_10_19', 'edinburgh_10_19','paris_10_19', 'newyork_10_19', 'washington_10_19', 'toronto_v1', 'rome_v1'};
color_map = {'r','b','g','y','m','c','k'};
turns = 'true';
probs = 'true';

features_type = 'ES';
option = [features_type, turns ,probs]; 

%% plot the percent of routes correctly localized as a function of length route
% It only takes into account the last position 
    
figure(2)
k = 1;
for d=1:length(datasets)
    dataset = datasets{d};
    color = color_map{d};
    load(['Data/',dataset,'/results/',option,'.mat']); %the results
    if strcmp(features_type, 'ES')
        line = '-';
    else
        line = '--';
    end
    plot(sum(ranking <= k, 1)./size(result_final,1), 'LineStyle', line, 'Color', color)
    grid on
    hold on
end

xlabel('Node')
ylabel('Percentage of routes ranked in top 1')
legend_names = {'London','Edinburgh', 'Paris', 'New York', 'Washington', 'Toronto', 'Rome'};
legend(string(legend_names), 'Location', 'southeast')

