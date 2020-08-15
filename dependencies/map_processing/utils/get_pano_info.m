function panos = get_pano_info(boundary, files)
% For each pano, extract lat, lng, yaw, "outdoorsness" and ensure within osm map range
minlat = boundary(1);
minlon = boundary(2);
maxlat = boundary(3);
maxlon = boundary(4);

% Iterate through panos
str = fileread(files);
try
    pano_ind = strfind(str, 'pano_id=');
    panos.id = panoExtract(pano_ind(1), str); 
    lat_ind = strfind(str, 'lat='); lng_ind = strfind(str, 'lng=');
    lat = str2double(panoExtract(lat_ind(1), str)); lng = str2double(panoExtract(lng_ind(1), str));
    assert(lat < maxlat && lat > minlat); assert(lng < maxlon && lng > minlon);
    panos.coords = [lat, lng];
    yaw_ind = strfind(str, 'pano_yaw_deg=');
    panos.yaw = str2double(panoExtract(yaw_ind, str));
    tiltyaw_ind = strfind(str, 'tilt_yaw_deg=');
    panos.tiltyaw = str2double(panoExtract(tiltyaw_ind, str));
    tiltpitch_ind = strfind(str, 'tilt_pitch_deg=');
    panos.tiltpitch = str2double(panoExtract(tiltpitch_ind, str));
    panos.remove = false;
catch
    panos.coords = [0,0];
    panos.yaw = NaN;
    panos.tiltyaw = NaN;
    panos.tiltpitch = NaN;
    panos.remove = true;
end

end
