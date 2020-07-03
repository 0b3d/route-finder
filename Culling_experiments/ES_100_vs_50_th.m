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

%% ES N 100
p.results_dir = 'sub_results/ES';
filename = 'ranking.mat';
ax.ColorOrderIndex = 1;
for i=1:length(p.datasets)
    path = fullfile(p.results_dir,p.datasets{i}, ['top',num2str(p.k)], p.turns,filename);
    ranking = load(path).res;
    acc = sum(ranking <= p.k & ranking > 0 )/size(ranking,1);
    plot(ax,x,100*acc(x),'LineStyle', '--', 'LineWidth',1.0);
    hold on
end

%% BSD 50%

% bsd parameters
p.results_dir = 'sub_results/BSD/'; 
p.bsd_nets = {'resnet18N'};
%p.bsd_nets = {'resnet18','resnet50', 'densenet161','vgg','googlenet','alexnet3'};

ax.ColorOrderIndex = 1;
for i=1:length(p.datasets)
 for n=1:length(p.bsd_nets)
    filename = ['ranking_',p.bsd_nets{n},'.mat'];
    path = fullfile(p.results_dir,p.datasets{i},['top',num2str(p.k)],p.turns,filename);
    ranking = load(path).res;
    acc = sum(ranking <= p.k & ranking > 0 )/size(ranking,1);
    plot(ax,x,100*acc(x),'LineStyle', ':', 'LineWidth',1.0);
 end
end

%% BSD 100
% bsd parameters
p.results_dir = 'sub_results/BSD/'; 
p.bsd_nets = {'resnet18'};
%p.bsd_nets = {'resnet18','resnet50', 'densenet161','vgg','googlenet','alexnet3'};

ax.ColorOrderIndex = 1;
for i=1:length(p.datasets)
 for n=1:length(p.bsd_nets)
    filename = ['ranking_',p.bsd_nets{n},'.mat'];
    path = fullfile(p.results_dir,p.datasets{i},['top',num2str(p.k)],p.turns,filename);
    ranking = load(path).res;
    acc = sum(ranking <= p.k & ranking > 0 )/size(ranking,1);
    plot(ax,x,100*acc(x),'LineStyle', '-.', 'LineWidth',1.0);
 end
end


% style plot
ax = gca;
grid on 
title('Localisation accuracy with 50% by iteration')
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, ['Top-',num2str(p.k),' Localisations (%)'], 'FontName', 'Times', 'FontSize', 10)
% legend_text = {'ES Hudson River 50%','ES Union Square 50%','ES Wall Street 50%', ...
%                'ES Hudson River 100%','ES Union Square 100%','ES Wall Street 100%', ...
%                'BSD Hudson River 50%','BSD Union Square 50%','BSD Wall Street 50%', ...
%                'BSD Hudson River 100%','BSD Union Square 100%','BSD Wall Street 100%'};


legend_text = {'ES HR 50%','ES US 50%','ES WS 50%', ...
               'ES HR 100%','ES US 100%','ES WS 100%', ...
               'BSD HR 50%','BSD US 50%','BSD WS 50%', ...
               'BSD HR 100%','BSD US 100%','BSD WS 100%'};           

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
%fig.PaperPosition = [0 0 8 6];

%basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'south','FontSize', 7,'Orientation','horizontal','NumColumns',3)
%fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts_th', ['ESvsBSD_N50',p.turns,'_top',num2str(p.k)]);
saveas(ax, filename,'epsc')

