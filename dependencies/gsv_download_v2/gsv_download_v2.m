function panos = gsv_download_v2(panos, download_num, zoom, img_num)
count = 0;
outfolder = 'test';
outfolder_s = 'test_snaps';

if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

if ~exist(outfolder_s,'dir')
    mkdir(outfolder_s)
end

for i=1:size(panos, 2)
    curroad = panos(i).coords;
    yaw = panos(i).yaw;
    yaw = yaw * pi / 180;
        
    try
        lat = num2str(curroad(1),'%.20f');
        lon = num2str(curroad(2), '%.20f');
        url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat,',',lon); 
        filename = 'tmp.xml';
        folder = websave(filename,url);

        str = fileread(fullfile(folder));
        pano_ind = strfind(str, 'pano_id=');
        panoid = panoExtract(pano_ind(1), str); 
        %panos(i).id = panoid;
        panos(i).id = num2str(img_num);
        panos(i).pd = panoid;
        panos(i).remove = false;
        tiltyaw_ind = strfind(str, 'tilt_yaw_deg=');
        tiltyaw = str2double(panoExtract(tiltyaw_ind, str));
        tiltyaw = tiltyaw * pi / 180;
        tiltpitch_ind = strfind(str, 'tilt_pitch_deg=');
        tiltpitch = str2double(panoExtract(tiltpitch_ind, str));
        tiltpitch = tiltpitch * pi / 180;
        %fname = fullfile(outfolder,sprintf('%s.xml',panoid));
        fname = fullfile(outfolder,sprintf('%s.xml',num2str(img_num)));
        [~] = websave(fname,url);

        skip = false; % check previously downloaded, need to be completed
        % if(ismember(panoidAll{i}, panoid))
        %    skip = true;
        %    disp('skipping');
        % else
        %     panoidAll{end+1} = panoid; 
        % end
        
        %downloadGSV(panoid, outfolder, zoom, skip); % only download panos
        %downloadGSV_v1(panoid, outfolder, zoom); % only download panos
        %downloadGSV_v2(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip); % panos with snapshots
        %downloadGSV_v3(panoid, yaw, tiltyaw, tiltpitch, outfolder,outfolder_s, zoom, skip);% panos with snapshots
        downloadGSV_v4(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip, img_num);
        
        count = count + 1;
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