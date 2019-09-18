% data generation
clearvars -except dataset
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));
load(['Data/',dataset,'/features/',dataset,'.mat']);
load(['Data/',dataset,'/routes_small.mat']);
routes2 = routes;

%% generate delete set
str = 'None                  ';
for i=1:length(pano_id)
    if strcmp(pano_id(i,:), str)
        routes(i).id = [];
        routes(i).gsv_coords = [];
        routes(i).gsv_yaw = [];
        routes(i).neighbor = [];
        routes(i).x = [];
        routes(i).y = [];
    else
        routes(i).id = pano_id(i,:);
        routes(i).gsv_coords = [gsv_lat(i), gsv_lon(i)];
        routes(i).gsv_yaw = gsv_yaw(i);
        routes(i).neighbor = routes2(i).neighbor;
        routes(i).x = X(i,:);
        routes(i).y = Y(i,:);
    end
end
save(['Data/',dataset,'/features/final_routes.mat'],'routes');