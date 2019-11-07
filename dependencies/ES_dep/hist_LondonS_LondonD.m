clc
clear all;
close all;
% parameters;
dataset = 'scattered_london';
fig_title = 'LondonS';

%Read the features
load(['features/ES/', dataset,'.mat'], 'X', 'Y', 'pano_id');
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
hm = histogram(matched_pairs, 100);
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(unmatched_pairs, 100);
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
%title(ax, fig_title);
xlim([0, 6]);
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
legend({'Matched pairs LondonS', 'Unmatched pairs LondonS'})
grid on

% parameters;
dataset = 'london_10_19';
fig_title = 'LondonD';

%Read the features
subplot(2,1,2)
load(['features/ES/', dataset,'.mat'], 'X', 'Y', 'pano_id');
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
hm = histogram(matched_pairs, 100);
hm.FaceColor = [0 0 1]; % green
%hm.FaceAlpha = 0.2
hold on
hu = histogram(unmatched_pairs, 100);
hu.FaceColor = [1 0 1]; % red
%hu.FaceAlpha = 0.4
%EdgeColor = 'none'
ax = ancestor(hm, 'axes');
%title(ax, fig_title);
xlim([0, 6]);
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
legend({'Matched pairs LondonD','Unmatched pairs LondonD'})
grid on