clc
clear all
close all

model = 'v1';
zoom = 'z18';

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
params.top = 'top1';
%option = {features_type,turns, probs};

dataset = 'unionsquare5k';
range = 5:1:40;

% load ES data
ESresults_filename =  fullfile('sub_results/ES',dataset,params.top,params.turns,'ranking.mat');
load(ESresults_filename, 'res');

ranking = sum(res == 1, 1)/size(res,1);
plot(range, 100*ranking(range),  'LineStyle','-', 'LineWidth',2.0)
hold on 

accs = {'70','75','80','90','100'};
ax = gca;
for i = 1:length(accs)
    acc = accs{i};
    BSDresults_filename = fullfile('sub_results/BSD',dataset,params.top,params.turns,['ranking_',acc, '.mat']);
    load(BSDresults_filename, 'res')
    ranking = sum(res == 1, 1)/size(res,1);
    plot(ax, range, 100*ranking(range),  'LineStyle','--', 'LineWidth',1)
    hold on
end

grid on
title('Union Square')
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Top-1 Localisations (%)', 'FontName', 'Times', 'FontSize', 10)
legend_text = {'ES','BSD 70 %','BSD 75 %','BSD 80 %','BSD 90 %','BSD 100 %'};
set(ax,'Ytick',0:20:100)

fig = gcf;
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_bsd', 'charts_overlap', ['ESvsBSD_turns_',params.turns,'_',dataset,'_',params.top]);
% filename = fullfile('results_for_bsd', ['ESvsBSD_turns_',params.turns,'_',dataset,'_',params.top]);
saveas(ax, filename,'epsc')

