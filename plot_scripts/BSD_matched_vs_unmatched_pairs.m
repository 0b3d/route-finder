clc
clear all;
close all;
datasets = {'unionsquare5k', 'wallstreet5k'};
norm = 'count';
% parameters;
dataset = datasets{1};
fig_title = 'Union Square';
model = 'v1';
zoom = 'z18';

bins = 41;
step_y = 100;
step_x = 10;
lim_y = 1500;
lim_x = 50;
% Read the features
features_type = 'BSD';
city = 'manhattan';
% accuracy = 0.75;
% load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');

% load all the possible routes
load(['sub_results/','routes_uq_20.mat'], 'R');
Y = [];
X = [];
for i=1:size(R,1)
    yy = [];
    xx = [];
    for j=1:size(R,2)
        y = routes(R(i,j)).CNNs;
        x = routes(R(i,j)).BSDs;
        yy = [yy,y];
        xx = [xx,x];
    end
    Y = [Y;yy];
    X = [X;xx];    
end

n = size(Y,1);
matched_pairs = zeros(1,n);
unmatched_pairs = zeros(1,n);
distances = (pdist2(Y,X,'Hamming')).*(bins-1);
% Extract matched and unmatched distances
for i=1:n
    matched_pairs(1,i) = distances(i,i);
    % unmatched example
    j = randi(n,1);
    while i==j
        j = randi(n,1);
    end
    unmatched_pairs(1,i) = distances(i,j);
end 

figure
subplot(1,2,1)
binedges = 0.5:1:(bins+1);
hm = histogram(matched_pairs, binedges,'Normalization', norm);
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(unmatched_pairs, binedges, 'Normalization', norm );
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
%title(ax, fig_title);

set(gca,'Ytick',0:step_y:lim_y)
set(gca,'Xtick',0:step_x:lim_x)
%title(ax, fig_title);
ylim([0, lim_y]);
xlim([0, lim_x]);
%title(ax, 'Union Square')
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
%legend({'Matched pairs', 'Unmatched pairs'})
grid on
basic_plot_configuration;

% parameters;
dataset = datasets{2};
fig_title = 'Wall Street';

% Read the features
subplot(1,2,2)
% load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');

% load all the possible routes
load(['sub_results/','routes_ws_20.mat'], 'R');
Y = [];
X = [];
for i=1:size(R,1)
    yy = [];
    xx = [];
    for j=1:size(R,2)
        y = routes(R(i,j)).CNNs;
        x = routes(R(i,j)).BSDs;
        yy = [yy,y];
        xx = [xx,x];
    end
    Y = [Y;yy];
    X = [X;xx];    
end

%[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
n = size(Y,1);
matched_pairs = zeros(1,n);
unmatched_pairs = zeros(1,n);
distances = (pdist2(Y,X,'Hamming')).*(bins-1);
% Extract matched and unmatched distances
for i=1:n
    matched_pairs(1,i) = distances(i,i);
    % unmatched example
    j = randi(n,1);
    while i==j
        j = randi(n,1);
    end
    unmatched_pairs(1,i) = distances(i,j);
end 
hm = histogram(matched_pairs, binedges, 'Normalization', norm );
hm.FaceColor = [0 1 0]; % green
%hm.FaceAlpha = 0.2
hold on
hu = histogram(unmatched_pairs, binedges, 'Normalization', norm );
hu.FaceColor = [1 0 0]; % red
%hu.FaceAlpha = 0.4
%EdgeColor = 'none'
ax = ancestor(hm, 'axes');
set(gca,'Ytick',0:step_y:lim_y)
set(gca,'Xtick',0:step_x:lim_x)
%title(ax, fig_title);
ylim([0, lim_y]);
xlim([0, lim_x]);
%title(ax, 'Wallstreet')
xlabel(ax, 'Distance')
%ylabel(ax, 'Number of pairs','FontName', 'Times','FontSize',12)
%legend({'Matched pairs','Unmatched pairs'})
grid on

fig = gcf;
basic_plot_configuration;
fig.PaperPosition = [0 0 12 6]; % 12 x 9  cm 
% set(fig, 'InvertHardCopy', 'off');
% set(fig, 'Color', [1 1 1]);
filename = fullfile('results_for_bsd', 'BSD_distance_histogram_20');
saveas(ax, filename,'png')
