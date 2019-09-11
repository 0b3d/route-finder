% read .csv file to .mat file in struct
clear all
% csv to mat (struct)
% Out = csv2cell('UC_v3.csv','fromfile');
% R = struct();
% R.ind = str2double(Out{2,1});
% R.coords = [str2double(Out{2,2}), str2double(Out{2,3})];
% R.wayidx = str2double(Out{2,4});
% R.id = Out{2,5};
% R.yaw = str2double(Out{2,8});
% R.x = Out{2,9};
% R.y = Out{2,10};

% mat to struct
load('small_london_z19.mat');
R = struct();
for i=1:length(loc_id)
    R(i).oidx = loc_id(i);
    R(i).coords = [lat(i), lon(i)];
    R(i).yaw = osm_yaw(i);
    R(i).id = pano_id(i,:);
    R(i).wayidx = wayidx(i);
    R(i).x = X(i,:);
    R(i).y = Y(i,:);   
end

routes2 = struct();
idx1 = 1;
idx2 = 1;
str = 'None                  ';
for i=1:length(R)
    if strcmp(R(i).id, str)
        Delete(idx1,1) = R(i).oidx;
        idx1 = idx1+1;
    else
        routes2(idx2).coords = [lat(i), lon(i)];
        routes2(idx2).yaw = osm_yaw(i);
        routes2(idx2).id = pano_id(i,:);
        routes2(idx2).wayidx = wayidx(i);
        routes2(idx2).x = X(i,:);
        routes2(idx2).y = Y(i,:);
        idx2 = idx2+1;
    end
end
% save('Delete.mat', 'Delete');

% use test to generate new routes
load('routes_emb.mat', 'routes');
for i=1:length(routes)
    routes(i).coords_o = routes2(i).coords;
    routes(i).yaw =routes2(i).yaw;
    routes(i).id = routes2(i).id;
    routes(i).x = routes2(i).x;
    routes(i).y = routes2(i).y;    
end

