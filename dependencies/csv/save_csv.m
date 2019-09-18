% save .csv file
clear all
parameters;
load(['Data/',dataset,'/routes_small.mat'], 'routes');

filename = ['Data/',dataset,'/routes.csv'];
fid = fopen(filename, 'w');
fprintf(fid, [ '%s',',','%s',',','%s',',','%s',',','%s',',','%s',',','%s', ',', '%s', ',', '%s', ',', '%s', '\n'], ...
              'loc_id','osm_lat','osm_lon','osm_yaw','wayidx', 'neighbor', 'pano_id', 'gsv_lat', 'gsv_lon', 'gsv_yaw');   
for i=1:length(routes)
    osm_lat = routes(i).coords(1);
    osm_lon = routes(i).coords(2);
    osm_yaw = routes(i).yaw;
    wayidx = routes(i).wayidx;
    neigh = '';
    pano_id = routes(i).id;
    gsv_lat = routes(i).gsv_coords(1);
    gsv_lon = routes(i).gsv_coords(2);
    gsv_yaw = routes(i).gsv_yaw;
    % we should check the precision here!
    fprintf(fid, ['%d',',', '%.15f',',','%.15f',',','%.15e',',','%d', ',' , '%s', ',' , '%s', ',', '%.15f',',','%.15f',',','%.15e','\n'], ...
                     i, osm_lat, osm_lon, osm_yaw, wayidx, neigh, pano_id, gsv_lat, gsv_lon, gsv_yaw); 
end
fclose(fid);
