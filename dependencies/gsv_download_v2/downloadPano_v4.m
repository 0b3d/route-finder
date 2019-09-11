function [panoids, fname, pname] = downloadPano_v4(panoid, outfolder,zoom, skip)
fname = fullfile(outfolder,sprintf('%s.xml',panoid)); %  build full file name
pname = fullfile(outfolder,sprintf('%s.jpg',panoid));
zoom0_width = 416;
zoom0_height = 208;

% panoid = 'FkgEXZ_1fdvtZw8CHryixQ';
% url https://maps.googleapis.com/maps/api/streetview?size=600x300&pano=FkYAmhfFdc6IV3HZVnluPw&heading=151.78&pitch=-0.76&key=AIzaSyCWSewH0VZP_v9BS6v3nELiCNwc6Zihxqk
% https://www.google.com/maps/@51.4559253,-2.604981,3a,75y,307.29h,90t/data=!3m7!1e1!3m5!1sZ-p-nIeQijNMyX9kGZKCig!2e0!6s%2F%2Fgeo3.ggpht.com%2Fcbk%3Fpanoid%3DZ-p-nIeQijNMyX9kGZKCig%26output%3Dthumbnail%26cb_client%3Dmaps_sv.tactile.gps%26thumb%3D2%26w%3D203%26h%3D100%26yaw%3D49.911278%26pitch%3D0%26thumbfov%3D100!7i16384!8i8192
if(~skip)
    if zoom==5
        width = 512*(31+1);
        height = 512*(15+1);
        pano =  uint8(zeros(height,width,3));  % tile size: 512 * 512
        for x=0:31
            for y=0:15
                try
                    im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=5&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                catch
                    width = zoom0_width * bitshift(1, 5);
                    height = zoom0_height * bitshift(1, 5);
                    break; 
                end
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end
    elseif zoom==4
        width = 512*(15+1);
        height = 512*(7+1);
        pano =  uint8(zeros(height,width,3));
        for x=0:15
            for y=0:7
                try
                    im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=4&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                catch
                    width = zoom0_width * bitshift(1, 4);
                    height = zoom0_height * bitshift(1, 4);
                    break;  
                end
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end
    elseif zoom==3
        width = 512*(7+1);
        height = 512*(3+1);
        pano =  uint8(zeros(height,width,3));
        for x=0:7
            for y=0:3
                try
                    im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=3&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                catch
                    width = zoom0_width * bitshift(1, 3);
                    height = zoom0_height * bitshift(1, 3);
                    break;
                end
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end  
    elseif zoom==2
        width = 512*(3+1);
        height = 512*(1+1);
        pano =  uint8(zeros(height,width,3));
        for x=0:3
            for y=0:1
                try
                    im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=2&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                catch
                    width = zoom0_width * bitshift(1, 2);
                    height = zoom0_height * bitshift(1, 2);
                    break; 
                end
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end 
    elseif zoom==1
        width = 512*(2);
        height = 512*(1);
        pano =  uint8(zeros(height,width,3));
        for x=0:1
            for y=0
                try
                    im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=1&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                catch
                    width = zoom0_width * bitshift(1, 1);
                    height = zoom0_height * bitshift(1, 1);
                    break; 
                end
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end
        %pano = pano(1:416,1:832,:); % Seff
    end   
    
    pano = pano(1 : height, 1 : width,:);
    imwrite(pano,pname,'Quality',100);
    
    url = sprintf('http://maps.google.com/cbk?output=xml&cb_client=maps_sv&hl=en&dm=1&pm=1&ph=1&renderer=cubic,spherical&v=4&panoid=%s',panoid);
    cmdLine     = 'wget "%s" -t 2 -T 5 -O %s --user-agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6"';
    system(sprintf(cmdLine, url, fname)); % execute system command and return result.
end


str = file2string(fname);

pos = strfind(str,'pano_id='); % strfind, can find panoids of adjacent panorams

panoids = {};
cnt = 0;

for i=1:length(pos)
    panoid_new = str((pos(i)+9):(pos(i)+8+length(panoid)));
    if ~strcmp(panoid_new,panoid)
        cnt = cnt+1;
        panoids{cnt} = panoid_new;  
    end
end

end