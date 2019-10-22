clc
clear all;
close all;
parameters;
datasets = {'edinburgh_10_19', 'london_10_19', 'paris_10_19', 'rome_v1', 'newyork_10_19', 'washington_10_19', 'toronto_v1'};
%datasets = { 'paris_10_19'};
fig_title = 'All cities';


for d=1:size(datasets,2)
    dataset = datasets{d};
    distances = zeros(1,size(dataset,2));
    distances_nn = zeros(1,size(dataset,2));
    %Read the features
    load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);
    % load testing routes 
    for i=1:size(routes,2)
        neighbors = routes(i).neighbor;
        xi = routes(i).x;
        yi = routes(i).y;
        k = randi(size(routes, 2));
        xk = routes(k).x;
         
        if ~isempty(neighbors)
            %for n=1:size(neighbors, 1)
            j = neighbors(1,1);
            xj = routes(j).x;
            yj = routes(j).y;
            dxixj = sqrt(sum((xi-xj).^2));
            dxixk = sqrt(sum((xi-xk).^2));
            dyiyj = sqrt(sum((yi-yj).^2));
            
            distances(i) = dxixj - dyiyj; % distance between neighbords
            distances_nn(i) =  dxixk - dyiyj;
            %end
        else
            distances(i) = 10;
            distances_nn(i) = 10;
        end
    end
    
end

I = find(distances ~= 10);
dist1 = distances(I);
I = find(distances_nn ~= 10);
dist2 = distances_nn(I);
dist3 = [dist1,dist2];
n = size(routes,2);
matched_pairs = zeros(1,n);
unmatched_pairs = zeros(1,n);

hm = histogram(dist1, 100);
hm.FaceColor = [0 1 0]; % green
hold on
hu = histogram(dist2, 100);
hu.FaceColor = [1 0 0]; % red
ax = ancestor(hm, 'axes');
title(ax, fig_title);
xlabel(ax, 'Distance')
ylabel(ax, 'Number of pairs')
legend('Geographic neighbors','Random pairs')
grid on
