clc
clear all;
close all;
parameters;

model = 'v2_12';
zoom = 'z18'

datasets = {'hudsonriver5k','unionsquare5k', 'wallstreet5k'}
%legend_text = {'Hudson River', 'Union Square', 'Wall Street'}
legend_text = {'HR', 'US', 'WS'}


fig_title = 'Euclidean';
[~, ndatasets] = size(datasets);

for k=1:ndatasets
    %Read the features
    dataset = datasets{k};
    %load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);
    features_filename = ['features/ES/',model,'/', zoom, '/',dataset,'.mat'];
    % regenerate to be sure to use latest features
    load(features_filename, 'X', 'Y');
    %[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);
    
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
    new_score = 1 - score / 64.0;
    prec_rec(new_score, target, 'holdFigure', 1, 'plotROC', 0, 'plotPR', 1, 'plotBaseline', 0, 'holdFigure', 1);
end
ax =gca
legend(legend_text)
ylim([0.5 1])
%set(ax,'Ytick',0:0.1:1)
set(ax,'Xtick',0:0.25:1)
yticks([0.5 0.6 0.7 0.8 0.9 1.0])
yticklabels({'0.5','0.6','0.7','0.8','0.9','1.0'})
xticklabels({'0.0','0.25','0.50','0.75','1.0'})
grid on
basic_plot_configuration;
legend(ax,legend_text, 'Location','southwest','FontName', 'Times', 'FontSize', 8)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts_16d', 'precision_recall');
saveas(ax, filename,'epsc')


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
