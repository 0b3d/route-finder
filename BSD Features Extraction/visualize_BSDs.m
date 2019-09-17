% check the correctness of BSDs with visualization
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load('Data/ways.mat');
load('Data/buildings.mat');
load('Data/naturals.mat');
load('Data/leisures.mat');
load('Data/boundary.mat');
load('Data/inters.mat');
load('routes_small_withBSD.mat'); % descriptors

% display the whole map
f1 = figure(1);
display_map_v3(ways, buildings, naturals, leisures, boundary);
display_inters(inters, boundary);

% randomly display the descriptors (100 times)
for i=1:100
    f = 1;
    while f == 1
        idx = randi(size(routes, 2));
        location = routes(idx).gsv_coords;
        if location(1)<boundary(1) || location(1)>boundary(3) || location(2)<boundary(2) ||location(2)>boundary(4)
            f = 1;
        else
            f = 0;
        end
    end
    yaw = routes(idx).gsv_yaw;
    BSD = routes(idx).BSDs;
    radius = 30;
    display_searchcircles(location, yaw, radius, BSD);
    % new axes
    arclen = 60 / (2*earthRadius*pi) * 360;
    [circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],4);
    bounary_new(1) = min(circle(:,1));
    bounary_new(3) = max(circle(:,1));
    bounary_new(2) = min(circle(:,2));
    bounary_new(4) = max(circle(:,2));
    axis([bounary_new(2) bounary_new(4) bounary_new(1) bounary_new(3)])
end
 


