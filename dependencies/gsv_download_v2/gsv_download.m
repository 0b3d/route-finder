function gsv_download(roads, download_num, zoom)
count = 0;
outfolder = 'testimages';

if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

for i=1:size(roads, 1)
    curroad = roads(i).coords;
    for j=1:size(curroad, 1)
        lat = num2str(curroad(j,1));
        lon = num2str(curroad(j,2));
        url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat,',',lon); 
        filename = 'tmp.xml';
        folder = websave(filename,url);
        
        str = fileread(fullfile(folder));
        pano_ind = strfind(str, 'pano_id=');
        panoid = panoExtract(pano_ind(1), str);
        fname = fullfile(outfolder,sprintf('%s.xml',panoid));
        [~] = websave(fname,url);
        
        skip = false;
        downloadGSV(panoid, outfolder, zoom, skip);
        
        disp(count)
        count = count + 1;
    end
    if count > download_num
        break
    end    
end




end