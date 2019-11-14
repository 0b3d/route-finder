clc
clear all
close all

model = 's2v700k_v1';

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

dataset = 'luton_v4'
range = 1:1:40;
k = 1

load('ES_results/BSD_accuracies.mat')
% load ES data
results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'accuracy_with_different_length', 'ranking');
ranking_ES = ranking;

if strcmp(params.turns, 'true')
    turns = [1];
else
    turns = [0];
end

switch dataset
    case 'luton_v4'
        dst = [1];
    case 'london_10_19'
        dst = [2];
    case 'edinburgh_10_19'
        dst = [3];
    case 'newyork_10_19'
        dst = [4];
    otherwise
        disp('op not found')    
end
% 
% x = 5:5:40;
% logfil = ismember(BSDaccuracies(:,1),turns) & ismember(BSDaccuracies(:,2),dst);
% BSDdata = BSDaccuracies(logfil,4:11);
% 
% plot(x, accuracy_with_different_length(1,:), 'LineStyle','-', 'LineWidth',2.0)
% hold on
% plot(x, BSDdata', 'LineStyle','--', 'LineWidth',2.0)
% legend_text = {'ES', 'BSD 50','BSD 60','BSD 70', 'BSD 75','BSD 80','BSD 90','BSD 100'};
% grid on
% legend(legend_text, 'Location', 'east')
% 
res = sum(ranking_ES <= k, 1)/size(ranking,1);
plot(range, 100*res(range),  'LineStyle','-', 'LineWidth',2.0)
hold on 

accs = {'70','75','80','90','100'};
for i = 1:length(accs)
    acc = accs{i};
    bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_', acc,'.mat'];
    load(bsd_results_file, 'ranking')
    res = sum(ranking <= k, 1)/size(ranking,1);
    plot(range, 100*res(range),  'LineStyle','--', 'LineWidth',1.5)
    hold on
end

grid on
xlabel('Route length', 'FontName', 'Times', 'FontSize', 12)
ylabel('Correct localisations (%)', 'FontName', 'Times', 'FontSize', 12)
legend_text = {'ES','BSD 70 %','BSD 75 %','BSD 80 %','BSD 90 %','BSD 100 %'}
legend(legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 10)
