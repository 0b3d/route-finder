clc
clear all
close all

model = 'v2_2';
zoom = 'z19';

% choose features type
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

% load BSD data
networks = {'resnet18','resnet18N','resnet50','densenet161','alexnet3','vgg','googlenet'};
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
legend_text = {'ES','BSD resnet18','BSD resnet18N','BSD resnet50','BSD densenet161','BSD alexnet','BSD vgg','BSD googlenet'};
set(ax,'Ytick',0:20:100)

fig = gcf;
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts_th', ['ESvsBSD_turns_',params.turns,'_',dataset,'_',params.top]);
saveas(ax, filename,'epsc')

