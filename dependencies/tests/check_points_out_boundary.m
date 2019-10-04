% check points out of boundary
clear all
load('Data/london_center/routes_small_withBSD.mat');
load('Data/london_center/boundary.mat');
out = [];
BSDs_out = [];
for i=1:length(routes)
    location = routes(i).gsv_coords;
    BSD = routes(i).BSDs;
    if location(1)<boundary(1) || location(1)>boundary(3) || location(2)<boundary(2) ||location(2)>boundary(4)
        out = [out; i];
        BSDs_out = [BSDs_out; BSD];
        % display images
        id = routes(i).id;
        filepath = 'Data/snaps_fov90_r30/';
        filename_f = strcat(filepath, id, '_front.jpg');
        filename_r = strcat(filepath, id, '_right.jpg');
        filename_b = strcat(filepath, id, '_back.jpg');
        filename_l = strcat(filepath, id, '_left.jpg');
        figure(1)
        img_f = imresize(imread(filename_f), [512, 512]);
        subplot(2,2,1), imshow(img_f);
        title(strcat('front', num2str(BSD(1))));

        img_r = imresize(imread(filename_r), [512, 512]);
        subplot(2,2,2), imshow(img_r);
        title(strcat('right', num2str(BSD(2))));

        img_b = imresize(imread(filename_b), [512, 512]);
        subplot(2,2,3), imshow(img_b);
        title(strcat('back', num2str(BSD(3))));

        img_l = imresize(imread(filename_l), [512, 512]);
        subplot(2,2,4), imshow(img_l);
        title(strcat('left', num2str(BSD(4))));
    end
end

