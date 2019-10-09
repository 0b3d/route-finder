% check the correctness of BSDs with visualization
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['features/BSD/','BSD2_',dataset,'.mat']);
routes2 = routes;
load(['features/BSD/','BSD5_',dataset,'.mat']);
load(['Data/',dataset,'/ways.mat']);
load(['Data/',dataset,'/inters_after_filter.mat']);
load(['Data/',dataset,'/buildings.mat']);
load(['Data/',dataset,'/naturals.mat']);
load(['Data/',dataset,'/leisures.mat']);
load(['Data/',dataset,'/boundary.mat']);
load(['Data/',dataset,'/diff.mat']);

% display the whole map
% figure(1)
% display_map_v3(ways, buildings, naturals, leisures, boundary);
% display_inters(inters, boundary);
% hold on

% randomly display the descriptors (100 times) and relevant cropped images
for i=40:size(diff,1)
    figure(1)
    display_map_v3(ways, buildings, naturals, leisures, boundary);
    display_inters(inters, boundary);
    
    idx = diff(i);
    location = routes(idx).gsv_coords;
    yaw = routes(idx).gsv_yaw;
    BSD1 = routes(idx).BSDs; % 5 degree
    BSD2 = routes2(idx).BSDs;% 2 degree
    figure(1)
    display_searchcircles(location, yaw, radius, BSD1, 5);
               
    % new axes: zoom
    arclen = radius*2 / (2*earthRadius*pi) * 360;
    [circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[yaw, yaw+360],[],[],4);
    bounary_new(1) = min(circle(:,1));
    bounary_new(3) = max(circle(:,1));
    bounary_new(2) = min(circle(:,2));
    bounary_new(4) = max(circle(:,2));
    axis([bounary_new(2) bounary_new(4) bounary_new(1) bounary_new(3)])
    hold off
    
    figure(2)
    display_map_v3(ways, buildings, naturals, leisures, boundary);
    display_inters(inters, boundary);
    display_searchcircles(location, yaw, radius, BSD2, 2);
    axis([bounary_new(2) bounary_new(4) bounary_new(1) bounary_new(3)])
    hold off
    
    % display images
    id = routes(idx).id;
    filepath = 'images/edinburgh_v2/snaps/';
    filename_f = strcat(filepath, id, '_front.jpg');
    filename_r = strcat(filepath, id, '_right.jpg');
    filename_b = strcat(filepath, id, '_back.jpg');
    filename_l = strcat(filepath, id, '_left.jpg');
    figure(3)
    img_f = imresize(imread(filename_f), [512, 512]);
    subplot(2,2,1), imshow(img_f);
    title('front');
    
    img_r = imresize(imread(filename_r), [512, 512]);
    subplot(2,2,2), imshow(img_r);
    title('right');
    
    img_b = imresize(imread(filename_b), [512, 512]);
    subplot(2,2,3), imshow(img_b);
    title('back');
    
    img_l = imresize(imread(filename_l), [512, 512]);
    subplot(2,2,4), imshow(img_l);
    title('left');
    disp(idx);
    print(1, ['Results/','ex',num2str(i),'_bsd5'],'-djpeg');
    print(2, ['Results/','ex',num2str(i),'_bsd2'],'-djpeg');
    print(3, ['Results/','ex',num2str(i),'_gsv'],'-djpeg');
end
 


