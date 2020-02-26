clc
clear all
close all

model = 'v1';
zoom = 'z18'

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

dataset = 'unionsquare5k'
range = 1:1:40;
k = 5

% load ES data
ESresults_filename =  fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'.mat']);
load(ESresults_filename, 'ranking');
ranking_ES = ranking;

res = sum(ranking_ES <= k, 1)/size(ranking,1);
plot(range, 100*res(range),  'LineStyle','-', 'LineWidth',2.0)
hold on 

accs = {'70','75','80','90','100'};
ax = gca
for i = 1:length(accs)
    acc = accs{i};
    BSDresults_filename = fullfile('sub_results/BSD',dataset,params.turns,['ranking_',acc, '.mat'])
    load(BSDresults_filename, 'ranking')
    res = sum(ranking <= k, 1)/size(ranking,1);
    plot(ax, range, 100*res(range),  'LineStyle','--', 'LineWidth',1)
    hold on
end

grid on
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Correct localisations (%)', 'FontName', 'Times', 'FontSize', 10)
legend_text = {'ES','BSD 70 %','BSD 75 %','BSD 80 %','BSD 90 %','BSD 100 %'}
set(ax,'Ytick',0:20:100)

fig = gcf
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts', ['ESvsBSD_turns_',params.turns,'_',dataset,'_top_',num2str(k)]);
saveas(ax, filename,'epsc')

