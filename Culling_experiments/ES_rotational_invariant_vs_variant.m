clc
clear all
close all



% culling es parameters
p.results_dir = 'sub_results_th/ES';
p.datasets = {'hudsonriver5k','unionsquare5k','wallstreet5k'};
p.network = 'v2_2';
p.k = 1;
p.N = '0.5';
p.overlap = 1;
p.turns = 'false';
p.o = 5;
p.z = '19';

%% normal model
x = 5:5:40;
ax = gca;
for d=1:length(p.datasets)
    filename = ['culling_',p.N,'_zoom_',p.z,'.mat'];
    path = fullfile(p.results_dir, p.network, p.datasets{d},p.turns, filename);
    ranking = load(path).ranking;
    acc = sum(ranking <= p.k & ranking > 0 )/size(ranking,1);
    plot(ax,x,100*acc(x),'LineStyle', '-', 'LineWidth',1.5);
    hold on
end

%% invariant model
p.network = 'v2_4_no_aligned';
ax.ColorOrderIndex = 1;
x = 5:5:40;
ax = gca;
for d=1:length(p.datasets)
    filename = ['culling_',p.N,'_zoom_',p.z,'.mat'];
    path = fullfile(p.results_dir, p.network, p.datasets{d},p.turns, filename);
    ranking = load(path).ranking;
    acc = sum(ranking <= p.k & ranking > 0 )/size(ranking,1);
    plot(ax,x,100*acc(x),'LineStyle', '--', 'LineWidth',1.5);
    hold on
end



% style plot
ax = gca;
grid on 
%title('Localisation accuracy with 50% by iteration')
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, ['Top-',num2str(p.k),' Localisations (%)'], 'FontName', 'Times', 'FontSize', 10)
legend_text = {'Hudson River','Union Square','Wall Street','Hudson River RI','Union Square RI','Wall Street RI'};           

set(ax,'Ytick',0:20:100)
% 
fig = gcf;
font = 'Times';
ax.FontName = font;
ax.FontSize = 10;

%ax.XTickMode = 'manual';
%ax.YTickMode = 'manual';
%ax.ZTickMode = 'manual';
%ax.XLimMode = 'manual';
%ax.YLimMode = 'manual';
%ax.ZLimMode = 'manual';
%set(ax, 'defaultAxesTickLabelInterpreter','latex'); set(ax, 'defaultLegendInterpreter','latex');
grid on
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 8 6];
set(ax,'Ytick',0:20:100)
ylim([0,100]);
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7,'Orientation','horizontal','NumColumns',1)
%fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'final', ['ES_rotational_invariant_model',p.turns,'_top',num2str(p.k)]);
saveas(ax, filename,'epsc')

