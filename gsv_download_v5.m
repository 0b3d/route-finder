function panos = gsv_download_v5(panos, download_num, dataset)
count = 0;
city = dataset;
key = 'AIzaSyCtqNCE0Fmmk2xpP4E4zOwqrNnUGYXxoiM';

panoidAll = {'start'};

for i=1:length(panos)
    tic;
    curroad = panos(i).coords;
    % panos(i).yaw = [];
    curyaw = panos(i).yaw;
    lat = num2str(curroad(1), '%.20f');
    lon = num2str(curroad(2), '%.20f');
    heading = num2str(curyaw, '%.20f');
    % url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat,',',lon); 
    url = strcat('https://maps.googleapis.com/maps/api/streetview/metadata?','location=',lat,',',lon,'&heading=',heading,'&key=',key); 
    filename = 'metadata.json';
    folder = websave(filename,url);
    str = fileread(folder);
    data = jsondecode(str);
    panos(i).status = data.status;
    if strcmp(data.status,'OK')
        panoid = data.pano_id;
        panos(i).id = panoid;
        panos(i).coords_t = [data.location.lat, data.location.lng];
        panos(i).yaw = curyaw;
        count = count + 1;
        disp([city ' image ' num2str(count) ' took ' num2str(toc) ' seconds']);
    end
     

    
    if count > download_num
        break
    end 
end

end