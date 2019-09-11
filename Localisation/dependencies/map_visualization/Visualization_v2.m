% visualization
clear all
load('ways.mat');
load('buildings.mat');
load('naturals.mat');
load('leisures.mat');
load('boundary.mat');
load('test_route_manually_2.mat');
load('test_turn_manually_2.mat');
load('london_BSD_80.mat');

% localization parameters
threshold = 60; % Turn
max_route_length = 25;
N = [100, 100, 100, 100, 100, 100, 95, 95, 95, 90, 90, 90, 85, 85, 85, 80,...
    100, 100, 100, 100, 100, 100, 100, 100, 100];
R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

% frames
loops = max_route_length;
F(loops) = struct('cdata',[],'colormap',[]);
route_length = 16;

parfor_progress('searching', loops);
for key_frame = 1:loops
    % draw background image     
    display_map_v3(ways, buildings, naturals, leisures, boundary);
    hold on;
    
    set(gcf, 'position', get(0,'screensize'));
    
    % display the route
    t = test_route(13,:);
    T = test_turn(13,:);
    if key_frame < 2
        R = R_init;
        dist = zeros(size(routes,2),1);
        loop = 0;
    elseif key_frame < route_length+1
        [R, dist] = RRextend_v5(R_, dist_, routes);
    else
        [R, dist] = Bootstrapping(t_, min_dist, routes, route_length);
    end
    
    % display with turn
    [R_, dist_, t_, min_dist] = display_route(t, routes, R, N(key_frame), dist, key_frame, T, threshold);
    F(key_frame) = getframe(gcf);  
    parfor_progress('searching');
end
% load('F_UNI.mat');
% movie(F,1,1);
v = VideoWriter('demo_london_BSD.avi','Uncompressed AVI');
% v.Quality = 100;
v.FrameRate = 1;
open(v)
writeVideo(v,F)
close(v)

