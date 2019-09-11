function gsv_download_v1(roads, download_num, zoom)
count = 0;
outfolder = 'test';
outfolder_s = 'test_snaps';

if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

if ~exist(outfolder_s,'dir')
    mkdir(outfolder_s)
end

for i=1:size(roads, 1)
    if mode == 1
        curroad = roads(i).coords;
    else
        curroad = roads(i).dense_coords;
    end
        
%     if roads(i).remove == 1
%         continue;
%     end
    for j=1:size(curroad, 1)
        try
            lat = num2str(curroad(j,1));
            lon = num2str(curroad(j,2));
            url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat,',',lon); 
            filename = 'tmp.xml';
            folder = websave(filename,url);

            str = fileread(fullfile(folder));
            pano_ind = strfind(str, 'pano_id=');
            panoid = panoExtract(pano_ind(1), str); 
            yaw_ind = strfind(str, 'pano_yaw_deg=');
            yaw = str2double(panoExtract(yaw_ind, str));
            yaw = yaw * pi / 180;
            tiltyaw_ind = strfind(str, 'tilt_yaw_deg=');
            tiltyaw = str2double(panoExtract(tiltyaw_ind, str));
            tiltyaw = tiltyaw * pi / 180;
            tiltpitch_ind = strfind(str, 'tilt_pitch_deg=');
            tiltpitch = str2double(panoExtract(tiltpitch_ind, str));
            tiltpitch = tiltpitch * pi / 180;
            fname = fullfile(outfolder,sprintf('%s.xml',panoid));
            [~] = websave(fname,url);

            skip = false;
            %downloadGSV(panoid, outfolder, zoom, skip);
            %downloadGSV_v1(panoid, outfolder, zoom);
            %downloadGSV_v2(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom);
            downloadGSV_v3(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip);

            count = count + 1;
            disp(count)
            
        catch error
        disp(['Fail on image ' num2str(count)]);
        delete(fname);
        disp(error);
        end
    end
    if count > download_num
        break
    end    
end


end