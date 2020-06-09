% check errors
clear all
addpath(genpath('dataset'));
% load('routes_10m_final.mat', 'routes');
load('gsv_10m_yaw.mat','descriptors');
load('routes_10m_5.mat', 'routes');

% calculate the distance
% if the nodes share the same panoid, calculate their distance
T = struct2table(routes);
I = T.id;
C = unique(I);
P_DIST = struct();
for i = 1:length(C)
    id = C(i);
    panos(i).id = id;
    idx = find(ismember(I,id));
    dist = [];
    if length(idx) > 1
        for j=1:length(idx)-1
            lat1 = routes(idx(j)).coords(1);
            lon1 = routes(idx(j)).coords(2);
            lat2 = routes(idx(j+1)).coords(1);
            lon2 = routes(idx(j+1)).coords(2);
            [arclen,~] = distance(lat1, lon1, lat2, lon2);
            interval = arclen / 360 * (2*earthRadius*pi);
            dist= [dist, interval];
            
%             lat11 = num2str(lat1, '%.20f');
%             lon11 = num2str(lon1,'%.20f');
%             url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat11,',',lon11); 
%             filename = 'tmp_1.xml';
%             folder = websave(filename,url);
%             
%             lat22 = num2str(lat2, '%.20f');
%             lon22 = num2str(lon2, '%.20f');
%             url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat22,',',lon22); 
%             filename = 'tmp_2.xml';
%             folder = websave(filename,url);
            
        end
        P_DIST(i).same_id_dist = dist;
    else
        P_DIST(i).same_id_dist = 0;
    end
end

% calculate the distance between the true coordinates and their
% id_coodinate
T_DIST = struct();
for i=1:length(routes)
    lat1 = routes(i).coords(1);
    lon1 = routes(i).coords(2);
    lat2 = routes(i).coords_t(1);
    lon2 = routes(i).coords_t(2);
    [arclen,~] = distance(lat1, lon1, lat2, lon2);
    dist = arclen / 360 * (2*earthRadius*pi);
    T_DIST(i).coords = routes(i).coords;
    T_DIST(i).coords_t = routes(i).coords_t;
    T_DIST(i).dist = dist;   
end
