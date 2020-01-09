% delete repeated nodes with same panoid
% delete nodes out of boundary
clear all
close all
parameters;
addpath(genpath(pwd));
load(['Data/',dataset,'/routes.mat'],'routes');
load(['Data/',dataset,'/roads.mat'],'roads');
load(['Data/',dataset,'/boundary.mat'],'boundary');

%% Find Delete sets 
Delete = [];
Saved = [];
panoidAll = {'start'};
for i=1:length(routes)
    panoid = routes(i).id;
    location = routes(i).gsv_coords;
    isInter = size(routes(i).neighbor, 1) > 1;
    if isempty(panoid)
        Delete = [Delete;i];
    else
        % check boundary
        if location(1)<boundary(1) || location(1)>boundary(3) || location(2)<boundary(2) ||location(2)>boundary(4)
            Delete = [Delete;i];
        else
            % check repeated nodes
            idx = find(ismember(panoidAll, panoid));
            if ~isempty(idx) && ~isInter
               Delete = [Delete;i];
            else
               panoidAll{end+1} = panoid;
               Saved = [Saved;i];
            end
        end
    end
end

%% Delete repeated nodes shared the same GSV images
[roads] = delete_some_nodes(roads,Delete);
[routes2] = GenDataset_v3(roads);

%% Assign gsv_coordinates, gsv_yaw and pano_ids
for i=1:length(routes2)
    oidx = Saved(i);
    routes2(i).id = routes(oidx).id;
    routes2(i).gsv_coords = routes(oidx).gsv_coords;
    routes2(i).gsv_yaw = routes(oidx).gsv_yaw;
end
routes = routes2;
save(['Data/',dataset,'/roads_small.mat'],'roads');
save(['Data/',dataset,'/routes_small.mat'],'routes');
