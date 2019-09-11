function panos = get_pano_locations_v2(panoDir, files)
% For each pano, extract lat, lng, yaw, "outdoorsness" and ensure within osm map range

panos(length(files),1).id = []; % panoid
panos(length(files),1).coords = []; % geographic coordinates
panos(length(files),1).yaw = NaN; % yaw direction
panos(length(files),1).tiltyaw = NaN;
panos(length(files),1).tiltpitch = NaN;
panos(length(files),1).remove = false; % if this pano is invalid

% Iterate through panos
parfor_progress('pano coordinates',length(files));
for i = 1:length(files)
    panos(i).id = files{i}(1:end-4);
    str = fileread(fullfile(panoDir, files{i}));
    try
        lat_ind = strfind(str, 'lat='); lng_ind = strfind(str, 'lng=');
        lat = str2double(panoExtract(lat_ind(1), str)); lng = str2double(panoExtract(lng_ind(1), str));
        panos(i).coords = [lat, lng];
        yaw_ind = strfind(str, 'pano_yaw_deg=');
        panos(i).yaw = str2double(panoExtract(yaw_ind, str));
        tiltyaw_ind = strfind(str, 'tilt_yaw_deg=');
        panos(i).tiltyaw = str2double(panoExtract(tiltyaw_ind, str));
        tiltpitch_ind = strfind(str, 'tilt_pitch_deg=');
        panos(i).tiltpitch = str2double(panoExtract(tiltpitch_ind, str));
        panos(i).remove = false;
    catch
        disp(['pano ' num2str(i) ' is outside the map range (skipping)...']);
        panos(i).coords = [0,0];
        panos(i).yaw = NaN;
        panos(i).tiltyaw = NaN;
        panos(i).tiltpitch = NaN;
        panos(i).remove = true;
    end
    parfor_progress('pano coordinates');
end

end

