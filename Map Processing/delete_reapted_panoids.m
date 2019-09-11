% delete repeated nodes with same panoid
clear all
close all
load('routes.mat','routes');
load('roads.mat','roads');

%% Find Delete sets 
Delete = [];
panoidAll = {'start'};
for i=1:length(routes)
    panoid = routes(i).id;
    isInter = size(routes(i).neighbor, 1) > 1;
    if isempty(panoid)
        Delete = [Delete;i];
    else
        idx = find(ismember(panoidAll, panoid));
        if ~isempty(idx) && ~isInter
            Delete = [Delete;i];
        else
            panoidAll{end+1} = panoid;
        end
    end    
end

%% Delete repeated nodes shared the same GSV images
[roads] = delete_some_nodes(roads,Delete);
[routes] = GenDataset_v2(roads);
save('roads.mat','roads');
save('routes.mat','routes');
