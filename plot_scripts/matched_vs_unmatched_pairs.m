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

bins = 30
step = 100
lim = 500

%Read the features
load(['features/ES/',model,'/',zoom, '/', dataset,'.mat'], 'X', 'Y', 'pano_id');
%[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
n = size(Y,1);
matched_pairs = zeros(1,n);
unmatched_pairs = zeros(1,n);
distances = pdist2(Y,X);
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
hm = histogram(matched_pairs, bins,'Normalization', norm);
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(unmatched_pairs, bins, 'Normalization', norm );
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
%title(ax, fig_title);

set(gca,'Ytick',0:step:lim)
%title(ax, fig_title);
ylim([0, lim]);
xlim([0, 6]);
%title(ax, 'Union Square')
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
%legend({'Matched pairs', 'Unmatched pairs'})
grid on
basic_plot_configuration;

% parameters;
dataset = datasets{2};
fig_title = 'Wallstreet';

%Read the features
subplot(1,2,2)
load(['features/ES/',model,'/', zoom, '/', dataset,'.mat'], 'X', 'Y', 'pano_id');
%[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
n = size(Y,1);
matched_pairs = zeros(1,n);
unmatched_pairs = zeros(1,n);
distances = pdist2(Y,X);
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
hm = histogram(matched_pairs, bins, 'Normalization', norm );
hm.FaceColor = [0 1 0]; % green
%hm.FaceAlpha = 0.2
hold on
hu = histogram(unmatched_pairs, bins, 'Normalization', norm );
hu.FaceColor = [1 0 0]; % red
%hu.FaceAlpha = 0.4
%EdgeColor = 'none'
ax = ancestor(hm, 'axes');
set(gca,'Ytick',0:step:lim)
%title(ax, fig_title);
ylim([0, lim]);
xlim([0, 6]);
%title(ax, 'Wallstreet')
xlabel(ax, 'Distance')
%ylabel(ax, 'Number of pairs','FontName', 'Times','FontSize',12)
%legend({'Matched pairs','Unmatched pairs'})
grid on

fig = gcf 
basic_plot_configuration;
fig.PaperPosition = [0 0 12 6]; % 12 x 9  cm 
filename = fullfile('results_for_eccv', 'charts', 'ES_distance_histogram');
saveas(ax, filename,'epsc')
