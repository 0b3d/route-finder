clc
clear all;
close all;
datasets = {'unionsquare5k', 'cmu5k'};
norm = 'count';
% parameters;
dataset = datasets{1};
fig_title = 'Union Square';
model = 'v1';
zoom = 'z18';

%Read the features
load(['features/ES/',model,'/',zoom, '/', dataset,'.mat'], 'X', 'Y', 'pano_id');
[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
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
subplot(2,1,1)
hm = histogram(matched_pairs, 100,'Normalization', norm);
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(unmatched_pairs, 100, 'Normalization', norm );
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
%title(ax, fig_title);
xlim([0, 6]);
xlabel(ax, 'Distance','FontName', 'Times','FontSize',12)
ylabel(ax, 'Number of pairs','FontName', 'Times','FontSize',12)
legend({'Matched pairs Union Square', 'Unmatched pairs Union Square'},'FontName', 'Times','FontSize',10)
grid on

% parameters;
dataset = datasets{2};
fig_title = 'CMU';

%Read the features
subplot(2,1,2)
load(['features/ES/',model,'/', zoom, '/', dataset,'.mat'], 'X', 'Y', 'pano_id');
[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
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
hm = histogram(matched_pairs, 100, 'Normalization', norm );
hm.FaceColor = [0 1 0]; % green
%hm.FaceAlpha = 0.2
hold on
hu = histogram(unmatched_pairs, 100, 'Normalization', norm );
hu.FaceColor = [1 0 0]; % red
%hu.FaceAlpha = 0.4
%EdgeColor = 'none'
ax = ancestor(hm, 'axes');
%title(ax, fig_title);
xlim([0, 6]);
xlabel(ax, 'Distance','FontName', 'Times','FontSize',12)
ylabel(ax, 'Number of pairs','FontName', 'Times','FontSize',12)
legend({'Matched pairs CMU','Unmatched pairs CMU'},'FontName', 'Times','FontSize',10)
grid on