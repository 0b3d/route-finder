% check the correctness of BSDs with visualization
% clear all
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
load('Data/inters_new.mat');
load('Data/routes_small_withBSD_50.mat'); % descriptors
routes2 = routes;
load('Data/routes_small_withBSD.mat'); % descriptors
load('diff.mat','diff');

% display the whole map
figure(1)
display_map_v3(ways, buildings, naturals, leisures, boundary);
display_inters(inters, boundary);
hold on

figure(2)
display_map_v3(ways, buildings, naturals, leisures, boundary);
display_inters(inters, boundary);
hold on

% randomly display the descriptors (100 times) and relevant cropped images
for i=1:size(diff,1)
%     f = 1;
%     while f == 1
%         idx = randi(size(routes, 2));
%         idx = 1;
%         location = routes(idx).gsv_coords;
%         if location(1)<boundary(1) || location(1)>boundary(3) || location(2)<boundary(2) ||location(2)>boundary(4)
%             f = 1;
%         else
%             f = 0;
%         end
%     end
    % idx = diff(i);
    idx = 20;
    location = routes(idx).gsv_coords;
    yaw = routes(idx).gsv_yaw;
    BSD1 = routes(idx).BSDs;
    BSD2 = routes2(idx).BSDs;
    figure(1)
    display_searchcircles(location, yaw, 30, BSD1);
   
    % new axes: zoom
    arclen = 60 / (2*earthRadius*pi) * 360;
    [circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],4);
    bounary_new(1) = min(circle(:,1));
    bounary_new(3) = max(circle(:,1));
    bounary_new(2) = min(circle(:,2));
    bounary_new(4) = max(circle(:,2));
    axis([bounary_new(2) bounary_new(4) bounary_new(1) bounary_new(3)])
    
    figure(2)
    display_searchcircles(location, yaw, 50, BSD2);
   
    % new axes: zoom
    arclen = 100 / (2*earthRadius*pi) * 360;
    [circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],4);
    bounary_new(1) = min(circle(:,1));
    bounary_new(3) = max(circle(:,1));
    bounary_new(2) = min(circle(:,2));
    bounary_new(4) = max(circle(:,2));
    axis([bounary_new(2) bounary_new(4) bounary_new(1) bounary_new(3)])
    
    % display images
%     id = routes(idx).id;
%     filepath = 'Data/london_new/snaps_fov90/';
%     filename_f = strcat(filepath, id, '_front.jpg');
%     filename_r = strcat(filepath, id, '_right.jpg');
%     filename_b = strcat(filepath, id, '_back.jpg');
%     filename_l = strcat(filepath, id, '_left.jpg');
%     figure(2)
%     img_f = imresize(imread(filename_f), [512, 512]);
%     subplot(2,2,1), imshow(img_f);
%     title(strcat('front', num2str(BSD(1))));
%     
%     img_r = imresize(imread(filename_r), [512, 512]);
%     subplot(2,2,2), imshow(img_r);
%     title(strcat('right', num2str(BSD(2))));
%     
%     img_b = imresize(imread(filename_b), [512, 512]);
%     subplot(2,2,3), imshow(img_b);
%     title(strcat('back', num2str(BSD(3))));
%     
%     img_l = imresize(imread(filename_l), [512, 512]);
%     subplot(2,2,4), imshow(img_l);
%     title(strcat('left', num2str(BSD(4))));
    disp(idx);
end
 


