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


datasets = {'london_10_19', 'edinburgh_10_19','oxford_10_19'};
color_map = {'r','b','g'};
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
    if features_type == 'ES'
        line = '--';
    else
        line = '-';
    end
    plot(sum(ranking <= k, 1)./size(result_final,1), 'LineStyle', line, 'Color', color)
    hold on
end

xlabel('Node')
ylabel('Percentage of routes ranked in top 1')
legend_names = {'ES London','ES Edinburgh', 'ES Oxford'}
legend(string(legend_names))

% %plot the top k accuracy
% figure(1)
% plot(ks, results)
% xlabel('Top k accuracy')

