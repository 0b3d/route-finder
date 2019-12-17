% video
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

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

% frames
idx = 1;
loops = 30;
F(loops) = struct('cdata',[],'colormap',[]);
successful_route_length = 20; % successfully localised length

% draw background image     
display_map_v3(ways, buildings, naturals, leisures, boundary);
hold on;
% limits = [boundary(2) boundary(4) boundary(1) boundary(3)];
% map = Map(limits); % plot OSM map
% hold on;
set(gcf, 'position', get(0,'screensize'));

parfor_progress('searching', loops);
for key_frame = 1:loops
    title(strcat('Number of move #', num2str(key_frame)));
    % display the route
    t = test_route(idx,:);
    T = test_turn(idx,:);
    if key_frame < 2
        R = R_init;
        dist = zeros(size(routes,2),1);

    elseif key_frame < successful_route_length+1
        [R, dist] = RRextend_v5(R_, dist_, routes);
    else
        [R, dist] = Bootstrapping(t_, min_dist, routes, successful_route_length);
    end
    
    % display with turn
    [R_, dist_, t_, min_dist, hd, hg] = display_route(t, routes, R, N(key_frame), dist, key_frame, T, threshold, successful_route_length);
    legend([hg hd(3)], 'Ground Truth', 'BSD');
    F(key_frame) = getframe(gcf); 
    delete(hd);
    parfor_progress('searching');
end
v = VideoWriter('demo_london_BSD.avi','Uncompressed AVI');
v.FrameRate = 1;
open(v)
writeVideo(v,F)
close(v)




