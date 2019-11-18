% generate video
clear all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load(['features/',features_type,'/',features_type,'_', dataset,'_',num2str(accuracy*100),'.mat']);
% run 'Generate_random_routes' to get random test routes and turns
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
load(['Localisation/test_routes/',dataset,'_turns_', num2str(test_num), '_' , num2str(threshold),'.mat']);
load(['Data/',dataset,'/ways.mat']);
load(['Data/',dataset,'/buildings.mat']);
load(['Data/',dataset,'/naturals.mat']);
load(['Data/',dataset,'/leisures.mat']);
load(['Data/',dataset,'/boundary.mat']);

option = [features_type, turns ,probs]; 
load(['Data/',dataset,'/results/',option,'_',num2str(accuracy*100),'.mat'], 'best_estimated_routes');

loops = 20;
idx1 = 1;
idx2 = 2;
idx3 = 3;
F(loops) = struct('cdata',[],'colormap',[]);
parfor_progress('searching', loops);
for key_frame = 1:loops
    % draw background image     
    display_map_v3(ways, buildings, naturals, leisures, boundary);
    hold on;
    limits = [boundary(2) boundary(4) boundary(1) boundary(3)];
    set(gcf, 'position', get(0,'screensize'));
    
    % display the ground truth
    gt1 = test_route(idx1,1:key_frame);
    gt2 = test_route(idx2,1:key_frame);
    gt3 = test_route(idx3,1:key_frame);
    
    % true location
    true_x1 = zeros(key_frame,1);
    true_y1 = zeros(key_frame,1);
    true_x2 = zeros(key_frame,1);
    true_y2 = zeros(key_frame,1);
    true_x3 = zeros(key_frame,1);
    true_y3 = zeros(key_frame,1);    
    for i=1:key_frame
        true_x1(i) = routes(gt1(i)).gsv_coords(2);
        true_y1(i) = routes(gt1(i)).gsv_coords(1);
        true_x2(i) = routes(gt2(i)).gsv_coords(2);
        true_y2(i) = routes(gt2(i)).gsv_coords(1);
        true_x3(i) = routes(gt3(i)).gsv_coords(2);
        true_y3(i) = routes(gt3(i)).gsv_coords(1);        
    end
    plot(true_x1(:,1), true_y1(:,1), 'o', 'MarkerFaceColor', 'r','MarkerSize', 8, 'MarkerEdgeColor','r');
    plot(true_x2(:,1), true_y2(:,1), 'd', 'MarkerFaceColor', 'r','MarkerSize', 8, 'MarkerEdgeColor','r');
    plot(true_x3(:,1), true_y3(:,1), 's', 'MarkerFaceColor', 'r','MarkerSize', 8, 'MarkerEdgeColor','r');
    hold on;
    plot(true_x1(key_frame), true_y1(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 40, 'LineWidth', 5);
    plot(true_x2(key_frame), true_y2(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 40, 'LineWidth', 5);
    plot(true_x3(key_frame), true_y3(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 40, 'LineWidth', 5);
    hold on;
    
    % display the best estimated route
    et1 = best_estimated_routes{1, idx1}{key_frame};
    et2 = best_estimated_routes{1, idx2}{key_frame};
    et3 = best_estimated_routes{1, idx3}{key_frame};
    
    display_top_routes(routes, key_frame, et1, et2, et3, 'g');   
    F(key_frame) = getframe(gcf);  
    parfor_progress('searching');
end
v = VideoWriter('demo_3routes.avi','Uncompressed AVI');
v.FrameRate = 1;
open(v)
writeVideo(v,F)
close(v)





