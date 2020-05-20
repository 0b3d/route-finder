% save label to csv
clear all
parameters;

if strcmp(city,'train')
    load(['Data/streetlearn/',dataset,'.mat']); % only
    routes2 = routes;
end
clear routes;
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');

filename = ['CSV_Files/',dataset,'.csv'];
fid = fopen(filename, 'w');
% fprintf(fid, [ '%s',',','%s',',','%s',',','%s',',','%s',',','%s',',','%s', ',', '%s', ',' ,'%s', '\n'], ...
%               'pano_id', 'gsv_lat', 'gsv_lon', 'gsv_yaw','front','right','back','left','city');   
for i=1:length(routes)
    pano_id = routes(i).id;
    gsv_lat = routes(i).gsv_coords(1);
    gsv_lon = routes(i).gsv_coords(2);
    gsv_yaw = routes(i).gsv_yaw;
    front = routes(i).BSDs(1);
    right = routes(i).BSDs(2);
    back = routes(i).BSDs(3);
    left = routes(i).BSDs(4);
    if strcmp(city,'train')
        city = routes2(i).city;
        % check
        pano_id_ = routes2(i).id;
        if ~strcmp(pano_id,pano_id_)
            disp('unmatched'); 
        end
    end
    % we should check the precision here!
    fprintf(fid, ['%s', ',', '%.20f',',','%.20f',',','%f',',','%f',',','%f',',','%f',',','%f',',','%s','\n'], ...
                     pano_id, gsv_lat, gsv_lon, gsv_yaw, front, right, back, left, city); 
end
fclose(fid);
