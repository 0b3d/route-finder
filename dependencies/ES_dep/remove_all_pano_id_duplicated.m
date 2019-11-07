% Find easy examples
% Find all the pairwise distances and select the 100 smaller examples
clc
clear all
close all

dataset = 'luton_v4';
features_filename = ['features/ES/ES_',dataset,'.mat'];
% regenerate to be sure to use latest features
load(features_filename)
pano_ids = {};
i = 1;
for k=1:size(routes,2)
    pano_id = routes(k).id;
    if ~ismember(pano_id, pano_ids)
        pano_ids{i} = pano_id;
        routes_nd(i).loc_id = k;
        routes_nd(i).id = routes(k).id;
        routes_nd(i).coords = routes(k).coords;
        routes_nd(i).gsv_coords = routes(k).gsv_coords;
        routes_nd(i).yaw = routes(k).yaw;
        routes_nd(i).wayidx = routes(k).wayidx;
        routes_nd(i).neighbor = routes(k).neighbor;
        routes_nd(i).gsv_yaw = routes(k).gsv_yaw;
        routes_nd(i).x = routes(k).x;
        routes_nd(i).y = routes(k).y;
        i = i + 1;
    else
        disp('duplicated');
    end
end
routes = routes_nd;
save(['features/ES/','ES_',dataset,'_nd','.mat'],'routes');