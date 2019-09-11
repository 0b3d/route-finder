% test GSV images download
clear all
% load('routes_10m_gsv.mat', 'routes');
% load('routes_10m_4.mat', 'routes');
% load('ways.mat');
% load('buildings.mat');
% load('inters.mat');
% load('boundary.mat');
%% method1: given a test route, download its images
% parameters
% threshold = 60;
% R_init = zeros(size(routes,2),1);
% for i = 1:size(routes,2)
%     R_init(i) = i;   
% end
% 
% [t, T, max_route_length] = RandomRoutes(R_init, routes, threshold);
% % download images in advance
% tic;
% for j=1:size(t, 2)
%     curlocation = routes(t(j));
%     curlocation = gsv_download_v2(curlocation, 1, 3); % download_num = 1, zoom = 3
%     panos(j) = curlocation;
% end
% time = toc;

%% method2: randomly select a seed pano and directly download images along routes with neighbors
% seed_panoid = 'GKa0zsVzHhLCt9L9_18T5w'; % randomly choose a seed
% download_number = 10; 
% zoom = 3; 
% bfs_download_v2(seed_panoid,download_number,zoom);
% 
files = dir('new_panos/*.xml');
files = {files.name}'; 
% % [new_files,~] = sort_nat(files);
% % mapFile = 'small_london.osm'; % OSM extract
% panoDir = 'new_panos/'; 
% % 
% % % assign attributes to GSV panoramas based on OSM and store in "panos" struct
% panos = get_pano_locations_v2(panoDir, files);
% 
% % % calculate inervals
% for i=1:size(panos, 1) - 1
%     lat1 = panos(i).coords(1);
%     lon1 = panos(i).coords(2);
%     lat2 = panos(i+1).coords(1);
%     lon2 = panos(i+1).coords(2);
%     [arclen,~] = distance(lat1, lon1, lat2, lon2);
%     dist(i) = arclen / 360 * (2*earthRadius*pi);
% end
% 
% % display
% % figure(1)
% % display_map_v2(ways, inters, buildings, boundary, 1);
% % for i = 1:size(panos, 1)
% %     curlocation = panos(i).coords;
% %     plot(curlocation(2),curlocation(1),'r-o');
% %     text(curlocation(2),curlocation(1),num2str(i));
% %     hold on;    
% % end
% 
% crop the panos into four directions
load('routes_10m_8.mat', 'routes')
panoDir = 'new_panos/'; 
files_jpg = dir('new_panos/*.jpg');
files_jpg = {files_jpg.name}'; 
panos = get_pano_locations_v2(panoDir, files);
T = struct2table(routes);
I = T.id;
U = unique(I);  % 909  < 921, some of the images lost
for i=1:length(panos)
    try
    curPanoid = panos(i).id;
    idx = find(ismember(I, curPanoid));
    panos(i).yaw_o = routes(idx(1)).yaw_o;
    catch
        disp(i);  
    end
end
% [new_files,~] = sort_nat(files_jpg);
snp_download_v2(panos, panoDir, files_jpg);

% T = struct2table(routes);
% I = T.id;
% new_imgH = 227;        % horizontal resolution = width
% new_imgShort = 227;    % vertical resolution = height
% %fov = 90;
% fov = 65;
% fov = pi * fov / 180;
% snp_download(new_imgH, new_imgShort, fov, panoDir, files, files_jpg, routes, I);

%% method 3: randomly select a seed, then download images in a uniform interval
% latitude: boundary(1)~boundary(3)
% longitude: boundary(2)~boundary(4)
% N = 10;
% lat0 = boundary(1)+(boundary(3)-boundary(1))*rand(1);
% lon0 = boundary(2)+(boundary(4)-boundary(2))*rand(1);
% panos.coords = [lat0 lon0];
% dense = 90;  % every 10m
% arclen = dense / (2*earthRadius*pi) * 360;
% panos = gsv_download_v3(panos, 1, 3, 1);
% az = panos.yaw; 
% [lat, lon] = track1(lat0,lon0,az,arclen,[],[],10);  
% 
% arclen = distance(lat0, lon0, lat(1), lon(1));  % lat0 = lat(1)
% dist = arclen / 360 * (2*earthRadius*pi);
% % calculate inervals
% for i=1:9
%     lat1 = lat(i);
%     lon1 = lon(i);
%     lat2 = lat(i+1);
%     lon2 = lon(i+1);
%     [arclen,~] = distance(lat1, lon1, lat2, lon2);
%     dist(i) = arclen / 360 * (2*earthRadius*pi);
% end
% 
% for i=2:N
%     curlocation.coords = [lat(i), lon(i)];
%     curlocation = gsv_download_v3(curlocation, 1, 3, i); % download_num = 1, zoom = 3
%     panos(i) = curlocation;
% end

%% method4: randomly select a seed pano and directly download images in a certain area
% seed_panoid = 'GKa0zsVzHhLCt9L9_18T5w'; % randomly choose a seed
% download_number = 10; 
% zoom = 3; 
% panos = bfs_download_v3(seed_panoid,download_number,zoom, boundary);

% crop the panos into four directions
% files_jpg = dir('test/*.jpg');
% files_jpg = {files_jpg.name}'; 
% [new_files,~] = sort_nat(files_jpg);
% snp_download_v2(panos, panoDir, new_files);


