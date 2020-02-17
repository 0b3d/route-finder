clear all
ESparams;
load(params.ESResultsPath, 'ranking', 'test_turn')

m = 20;
k = 1


num_turns_route = sum(test_turn(:,1:m-1), 2);
max_num_turns = max(num_turns_route);

acc = zeros(max_num_turns,1);
count = zeros(max_num_turns,2);

for th=0:max_num_turns
    routes_subset_indices = find(num_turns_route == th);
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
xlabel('Number of turns in route')
ylabel('Number of routes')
xticklabels(0:1:max_num_turns)
title('Localisation accuracy (route length=20)')