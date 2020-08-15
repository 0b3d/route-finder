% BSDs distribution statistic for non repeated panoids
clear all
close all
parameters;
% load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');

counts = zeros(2, 16);
for i=1:length(routes)
    idx1 = (bi2de(routes(i).BSDs))+1;
    % idx2 = (bi2de(routes(i).CNNs))+1;
    counts(1,idx1) = counts(1,idx1)+1;
    % counts(2,idx2) = counts(2,idx2)+1;
end 
bar(counts')
ax = gca;
% ylim([0,1600]);
% filename = fullfile('results_for_bsd', ['BSD_distribution',dataset,'_v3']);
% saveas(ax, filename,'png')