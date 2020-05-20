% check the correctness of BSDs with visualization
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load datas
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
load(['Data/',city,'/buildings.mat']);
load(['Data/',city,'/inters_after_filter.mat']);
% load(['Data/',city,'/ways.mat']);
% load(['Data/',city,'/naturals.mat']);
% load(['Data/',city,'/leisures.mat']);
% load(['Data/',city,'/boundary.mat']);

% input the id
% id = '--2c7yawIqdmNp7pzjIqoQ';
% T = struct2table(routes);
% ID = T.id;
% idx = find(ismember(ID,id));

idx = 256;

% display the descriptors and relevant cropped images
location = routes(idx).gsv_coords;
yaw = double(routes(idx).gsv_yaw);
BSD = routes(idx).BSDs;

%% Find buildings in search area
arclen = radius / (2*earthRadius*pi) * 360; 
circle = zeros(360/range, 2);  % search area, every 2 degree
[circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen, [],[],[],360/range);
figure(1)
plot(circle(:,2), circle(:,1),'-r'); % plot a map
hold on
buildings_in_circle = [];
junctions_in_circle = [];
    
for i=1:size(buildings,2)  % i=1:size(buildings,1)
    curcoord = buildings(i).coords;
    in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
    if(sum(in)) >= 1 && size(buildings(i).coords, 1) > 2
        buildings_in_circle = [buildings_in_circle; buildings(i)];
    end
end

%% Find junctions in search area
for i=1:size(inters,2)
    curcoord = inters(i).coords;
    in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
    if in == 1
        junctions_in_circle = [junctions_in_circle; inters(i)];
    end
end

% Find junctions which are not blocked (invisiable)
junctions_in_circle = getVisiableJC(junctions_in_circle, buildings_in_circle, location);

% display the whole map
figure(1)
display_buildings_and_inters(buildings_in_circle, junctions_in_circle);

figure(1)
display_searchcircles(location, yaw, radius, BSD, range); % need to comment circles
      
% new axes: zoom
% arclen = radius*2 / (2*earthRadius*pi) * 360;
% [circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[yaw, yaw+360],[],[],4);
% bounary_new(1) = min(circle(:,1));
% bounary_new(3) = max(circle(:,1));
% bounary_new(2) = min(circle(:,2));
% bounary_new(4) = max(circle(:,2));
% axis([bounary_new(2) bounary_new(4) bounary_new(1) bounary_new(3)])
% hold off
    
% display images
% filepath = 'images/london_10_19/snaps/';
% filename_f = strcat(filepath, id, '_front.jpg');
% filename_r = strcat(filepath, id, '_right.jpg');
% filename_b = strcat(filepath, id, '_back.jpg');
% filename_l = strcat(filepath, id, '_left.jpg');
% figure(2)
% img_f = imresize(imread(filename_f), [512, 512]);
% subplot(2,2,1), imshow(img_f);
% title(strcat('front', num2str(BSD(1))));
% 
% img_r = imresize(imread(filename_r), [512, 512]);
% subplot(2,2,2), imshow(img_r);
% title(strcat('right', num2str(BSD(2))));
% 
% img_b = imresize(imread(filename_b), [512, 512]);
% subplot(2,2,3), imshow(img_b);
% title(strcat('back', num2str(BSD(3))));
% 
% img_l = imresize(imread(filename_l), [512, 512]);
% subplot(2,2,4), imshow(img_l);
% title(strcat('left', num2str(BSD(4))));
% disp(idx);

 


