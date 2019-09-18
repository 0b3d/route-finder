function panorama_download(panoid, zoom, outfolder)
zoom0_width = 416;
zoom0_height = 208; 
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
end   
pano = pano(1 : height, 1 : width,:);
imwrite(pano,fullfile(outfolder,sprintf('%s.jpg',panoid)),'Quality',100); 
    
end