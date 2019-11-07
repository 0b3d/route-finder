% Find easy examples
% Find all the pairwise distances and select the 100 smaller examples
clc
clear all
close all

dataset = 'luton_v4';
features_filename = ['features/ES/ES_',dataset,'_nd','.mat'];
% regenerate to be sure to use latest features
load(features_filename)

% get pairwise distances
distances = pairwise_distances(routes); %y-x distances
[sorted_distances, sorted_indices] = sort(distances, 2, 'ascend'); 
labels = [1:1:length(routes)];

ranking = zeros(1,size(labels,2));
for i=1:size(labels,2)
   ranking(1,i) = find(labels(1,i) == sorted_indices(i,:));
end
ranked_1 = find(ranking == 1);

for i=1:size(ranked_1, 2)
    index = ranked_1(1, i);    
    show_top_k(index, dataset, routes, sorted_indices, 8)
    disp(index)
    close all;
end