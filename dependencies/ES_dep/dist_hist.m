clc
clear all;
close all;
parameters;
dataset = 'paris_10_19';
fig_title = 'Paris';


%Read the features
load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);

n = size(routes,2);
matched_pairs = zeros(1,n);
unmatched_pairs = zeros(1,n);

% Extract matched and unmatched distances
for i=1:n
    x = routes(i).x;
    y = routes(i).y;
    d = sqrt(sum((x-y).^2));
    matched_pairs(1,i) = d;
    % unmatched example
    j = randi(n,1);
    while i==j
        j = randi(n,1);
    end
    xu = routes(j).x;
    d = sqrt(sum((xu-y).^2));
    unmatched_pairs(1,i) = d;
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

