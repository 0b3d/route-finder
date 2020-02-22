clc
clear all
close all

model = 'v1';
zoom = 'z18'

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

dataset = 'wallstreet5k'
range = 1:1:40;
k = 1

% load ES data
ESresults_filename =  fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'.mat']);
load(ESresults_filename, 'ranking');
ranking_ES = ranking;

res = sum(ranking_ES <= k, 1)/size(ranking,1);
plot(range, 100*res(range),  'LineStyle','-', 'LineWidth',2.0)
hold on 

accs = {'70','75','80','90','100'};
for i = 1:length(accs)
    acc = accs{i};
    BSDresults_filename = fullfile('sub_results/BSD',dataset,params.turns,['ranking_',acc, '.mat'])
    load(BSDresults_filename, 'ranking')
    res = sum(ranking <= k, 1)/size(ranking,1);
    plot(range, 100*res(range),  'LineStyle','--', 'LineWidth',1.5)
    hold on
end

grid on
xlabel('Route length', 'FontName', 'Times', 'FontSize', 12)
ylabel('Correct localisations (%)', 'FontName', 'Times', 'FontSize', 12)
legend_text = {'ES','BSD 70 %','BSD 75 %','BSD 80 %','BSD 90 %','BSD 100 %'}
legend(legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 10)
