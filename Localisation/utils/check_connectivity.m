% check connectivity
clear all
close all
parameters;

load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 
load(['Data/',city,'/ways.mat']);
load(['Data/',city,'/inters.mat']);
load(['Data/',city,'/buildings.mat']);
load(['Data/',city,'/naturals.mat']);
load(['Data/',city,'/leisures.mat']);

T = struct2table(routes);
Coords = T.gsv_coords;
lowerlat = min(Coords(:,1));
upperlat = max(Coords(:,1));
lowerlon = min(Coords(:,2));
upperlon = max(Coords(:,2));
boundary = [lowerlat, lowerlon, upperlat, upperlon];
display_map_v4(ways, buildings, naturals, leisures, boundary);

test_num = size(test_route, 1);
F(test_num) = struct('cdata',[],'colormap',[]);
figure(1)
set(gcf, 'position', get(0,'screensize'));

for i=1%1:test_num
    max_route_length = max_route_length_init;
    t = test_route(i,1:5);
    % display each route
    for j=1:size(t,2)
        point = routes(t(j)).gsv_coords;
        yaw = double(routes(t(j)).gsv_yaw);
        BSD = routes(t(j)).BSDs;
        figure(1)
        plot(point(2), point(1), '*r');
        hold on
        display_searchcircles(point, yaw, radius, BSD, range);
    end 
    F(i) = getframe(gcf);    
end

% F = F(1:100);
% v = VideoWriter('check_connectivity.avi','Uncompressed AVI');
% v.FrameRate = 2;
% open(v)
% writeVideo(v,F)
% close(v)