function panos = gsv_download_v4(panos, download_num, zoom)
count = 0;
outfolder = 'london_panos';
outfolder_s = 'london_snaps';
city = 'London';

if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

if ~exist(outfolder_s,'dir')
    mkdir(outfolder_s)
end

panoidAll = {'start'};

for i=1:length(panos)
    tic;
    curroad = panos(i).coords;
    panos(i).yaw = [];
        
    try
        lat = num2str(curroad(1), '%.20f');
        lon = num2str(curroad(2), '%.20f');
        url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat,',',lon); 
        filename = 'tmp.xml';
        folder = websave(filename,url);

        str = fileread(fullfile(folder));
        pano_ind = strfind(str, 'pano_id=');
        panoid = panoExtract(pano_ind(1), str); 
        panos(i).id = panoid;
        panos(i).remove = false;
        
        lat_ind = strfind(str, 'lat='); lng_ind = strfind(str, 'lng=');
        llat = str2double(panoExtract(lat_ind(1), str)); llng = str2double(panoExtract(lng_ind(1), str));
        panos(i).coords_t = [llat, llng];
        
        yaw_ind = strfind(str, 'pano_yaw_deg=');        
        yaw = str2double(panoExtract(yaw_ind, str));
        panos(i).yaw = yaw;
        yaw = yaw * pi / 180;
        
        tiltyaw_ind = strfind(str, 'tilt_yaw_deg=');
        tiltyaw = str2double(panoExtract(tiltyaw_ind, str));
        panos(i).tiltyaw = tiltyaw;
        tiltyaw = tiltyaw * pi / 180;
        
        tiltpitch_ind = strfind(str, 'tilt_pitch_deg=');
        tiltpitch = str2double(panoExtract(tiltpitch_ind, str));
        panos(i).tiltpitch = tiltpitch;
        tiltpitch = tiltpitch * pi / 180;
        
%         fname = fullfile(outfolder,sprintf('%s.xml',panoid));
%         [~] = websave(fname,url);

        skip = false; % check previously downloaded
        Lia = ismember(panoidAll, panoid);
        if (sum(Lia) > 0)
           skip = true;
           disp('skipping');
        else
            panoidAll{end+1} = panoid; 
        end
        
        %downloadGSV(panoid, outfolder, zoom, skip); % only download panos
        %downloadGSV_v1(panoid, outfolder, zoom); % only download panos
        %downloadGSV_v2(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip); % panos with snapshots
        %downloadGSV_v3(panoid, yaw, tiltyaw, tiltpitch, outfolder,outfolder_s, zoom, skip);% panos with snapshots
        %downloadGSV_v4(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip, img_num);
        
        count = count + 1;
        disp([city ' image ' num2str(count) ' took ' num2str(toc) ' seconds']);
        
        %disp(count)

    catch error
        disp(['Fail on image ' num2str(count)]);
        delete(fname);
        panos(i).remove = true;
        disp(error);
    end 
    
    if count > download_num
        break
    end 
end

end