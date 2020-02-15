clear all
ESparams;
load(params.ESResultsPath, 'ranking', 'test_turn')

m = 20;
k = 1
acc = zeros(4,1);
count = zeros(4,2)

for th=0:4
    routes_subset_indices = find(sum(test_turn(:,1:m),2) >= th);
    routes_subset_rankings = ranking(routes_subset_indices,m);
    num_routes_subset = size(routes_subset_rankings, 1);
    num_routes_top1 = size(find(routes_subset_rankings(:,1) <= k),1);
    %count(th,:) = [size(routes_subset_rankings, 1), size(find(routes_subset_rankings(:,20) == 1), 1)];
    count(th+1,:) = [num_routes_top1, num_routes_subset - num_routes_top1];
    acc(th+1,1) = num_routes_top1 / num_routes_subset;
end
    
b = bar(count, 'stack')
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(acc);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend({'Localised routes', 'Not localised routes'})
xlabel('Number of turns in test route')
ylabel('Number of routes in testing subset')
xticklabels({'0','1','2','3','4'})
title('Localisation accuracy (route length=20)')