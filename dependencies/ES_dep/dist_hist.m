clc
clear all;
close all;
ESparams;

%Read the features
params.dataset = 'hudsonriver5k'
params.ESFeaturesPath = fullfile('features/ES',params.model, params.tile_test_zoom, [params.dataset, '.mat'])
load(params.ESFeaturesPath, 'X', 'Y', 'pano_id');
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
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(unmatched_pairs, 100);
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
%title(ax, fig_title);
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
legend({'Matched pairs', 'Unmatched pairs'})
grid on

