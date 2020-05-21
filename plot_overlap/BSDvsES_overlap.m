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
% option = {features_type,turns, probs};

dataset = 'unionsquare5k';
range = 5:1:40;

% load ES data
ESresults_filename =  fullfile('sub_results/ES',dataset,params.top,params.turns,'ranking.mat');
load(ESresults_filename, 'res');

ranking = sum(res == 1, 1)/size(res,1);
plot(range, 100*ranking(range),  'LineStyle','-', 'LineWidth',2.0)
hold on 

networks = {'resnet18','resnet50','alexnet','vgg','googlenet'};
ax = gca;
for i = 1:length(networks)
    network = networks{i};
    BSDresults_filename = fullfile('sub_results/BSD',dataset,params.top,params.turns,['ranking_',network, '.mat']);
    load(BSDresults_filename, 'res')
    ranking = sum(res == 1, 1)/size(res,1);
    plot(ax, range, 100*ranking(range),  'LineStyle','--', 'LineWidth',1)
    hold on
end

grid on
title('Union Square')
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Top-1 Localisations (%)', 'FontName', 'Times', 'FontSize', 10)
legend_text = {'ES','BSD resnet18','BSD resnet50','BSD alexnet','BSD vgg','BSD googlenet'};
set(ax,'Ytick',0:20:100)

fig = gcf;
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_bsd', 'charts_network', ['ESvsBSD_turns_',params.turns,'_',dataset,'_',params.top]);
saveas(ax, filename,'epsc')

