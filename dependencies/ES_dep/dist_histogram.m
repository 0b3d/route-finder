clc
clear all;
close all;
parameters;
datasets = {'edinburgh_10_19', 'london_10_19', 'paris_10_19', 'rome_v1', 'newyork_10_19', 'washington_10_19', 'toronto_v1'};
fig_title = 'Euclidean';


% For each datset get n samples of matched and unmatched pairs
n = 2500;
[~, ndatasets] = size(datasets);
matched_pairs = zeros(1,ndatasets*n);
unmatched_pairs = zeros(1,ndatasets*n);

for k=1:ndatasets
    %Read the features
    dataset = datasets{k};
    load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);
    % Extract matched and unmatched distances
    for i=1:n
        idx1 = randi(n,1);
        idx2 = randi(n,1);
        while i==j
            j = randi(n,1);
        end
        
        x = routes(idx1).x;
        y = routes(idx1).y;
        d = sqrt(sum((x-y).^2));
        %d = sum(abs(x-y));
        matched_pairs(1,n*(k-1)+i) = d;      
        xu = routes(idx2).x;
        d = sqrt(sum((xu-y).^2));
        %d = sum(abs(xu-y));
        unmatched_pairs(1,n*(k-1)+i) = d;
    end 
end


hm = histogram(matched_pairs, 100);
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(unmatched_pairs, 100);
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
title(ax, fig_title);
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
grid on
