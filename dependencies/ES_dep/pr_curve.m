clc
clear all;
close all;
parameters;

model = 's2v700k_v1';

%cvpr_datasets = {'edinburgh_10_19', 'london_10_19', 'luton_v4', 'newyork_10_19', 'toronto_v1'}
%legend_text = {'Edinburgh', 'London', 'Luton', 'New York', 'Toronto'}

%cvpr_datasets = {'edinburgh_10_19', 'london_10_19', 'luton_v4', 'newyork_10_19', 'toronto_v1'}
%legend_text = {'Edinburgh', 'London', 'Luton', 'New York', 'Toronto'}

% datasets = { 'edinburgh_10_19', 'london_10_19','luton_v4','oxford_10_19', 'tonbridge_v2'}
% legend_text = {'Random', 'Edinburgh','London','Luton', 'Oxford', 'Tonbridge'};

%datasets = {'newyork_10_19', 'paris_10_19', 'rome_v1', 'toronto_v1', 'washington_10_19'}
%legend_text = {'Random','New York','Paris', 'Rome', 'Toronto','Washington'};

datasets = {'scattered_london','edinburgh_10_19', 'london_10_19', 'luton_v4', 'newyork_10_19', 'toronto_v1'}
legend_text = {'Random','LondonS','Edinburgh', 'London', 'Luton', 'New York', 'Toronto'}

fig_title = 'Euclidean';
[~, ndatasets] = size(datasets);

for k=1:ndatasets
    %Read the features
    dataset = datasets{k};
    %load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);
    features_filename = ['features/ES/',model,'/',dataset,'.mat'];
    % regenerate to be sure to use latest features
    load(features_filename, 'X', 'Y', 'pano_id');
    [pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
    
    distances = pdist2(Y,X);
    n = size(X,1);
    matched_pairs = zeros(1,n);
    unmatched_pairs = zeros(1,n);
    
    for i=1:n
        j = randi(n,1);
        while i==j
            j = randi(n,1);
        end
        matched_pairs(1,i) = distances(i,i);      
        unmatched_pairs(1,i) = distances(i,j);        
    end 
    % concatenate matched and unmatched distances
    score = [matched_pairs, unmatched_pairs];
    target = [ones(1,n), zeros(1,n)];

    % change scale
    new_score = 1 - score / 6.0;
    prec_rec(new_score, target, 'holdFigure', 1, 'plotROC', 0, 'plotPR', 1, 'plotBaseline', 1, 'holdFigure', 1);
end

legend(legend_text)
ylim([0.4 1])
grid on

% 
% figure
% hm = histogram(matched_pairs, 100);
% hm.FaceColor = [0 1 0]; % green
% hold on
% hu = histogram(unmatched_pairs, 100);
% hu.FaceColor = [1 0 0]; % red
% ax = ancestor(hm, 'axes');
% title(ax, fig_title);
% xlabel(ax, 'Distance')
% ylabel(ax, 'Number of pairs')
% grid on
% 
