% check connectivity
clear all
close all
parameters;

load(['features/',features_type,'/',area,'/',features_type,'_', dataset,'_',area,'_',num2str(accuracy*100),'.mat'],'routes');
load(['Localisation/test_routes/',area,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
% load(['Data/',dataset,'/ways.mat']);
% load(['Data/',dataset,'/inters.mat']);
% load(['Data/',dataset,'/buildings.mat']);
% load(['Data/',dataset,'/naturals.mat']);
% load(['Data/',dataset,'/leisures.mat']);

boundary = [lowerlat, lowerlon, upperlat, upperlon];
% display_map_v4(ways, buildings, naturals, leisures, boundary);

test_num = size(test_route, 1);
F(test_num) = struct('cdata',[],'colormap',[]);
figure(1)
set(gcf, 'position', get(0,'screensize'));

for i=1:test_num
    max_route_length = max_route_length_init;
    t = test_route(i,1:max_route_length);
    % display each route
    for j=1:size(t,2)
        point = routes(t(j)).gsv_coords;
        figure(1)
        plot(point(2), point(1), '*r');
        hold on
    end 
    F(i) = getframe(gcf);    
end

F = F(1:100);
v = VideoWriter('check_connectivity.avi','Uncompressed AVI');
v.FrameRate = 2;
open(v)
writeVideo(v,F)
close(v)