function downloadGSV(panoid, outfolder, zoom, skip)

if(~skip)
    if zoom==5
        pano =  uint8(zeros(512*(12+1),512*(25+1),3));  % tile size: 512 * 512
        for x=0:25
            for y=0:12
                im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=5&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end
    elseif zoom==4
        pano =  uint8(zeros(512*(6+1),512*(11+1),3));
        for x=0:11
            for y=0:6
                im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=4&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end
    elseif zoom==1
        pano =  uint8(zeros(512*(1),512*(2),3));
        for x=0:1
            for y=0
                im = imresize(imread(sprintf('http://maps.google.com/cbk?output=tile&zoom=1&x=%d&y=%d&cb_client=maps_sv&fover=2&onerr=3&renderer=spherical&v=4&panoid=%s',x,y,panoid)),[512 512]);
                pano(512*y+(1:512),512*x+(1:512),:) = im;
            end
        end
    end
      
    imwrite(pano,fullfile(outfolder,sprintf('%s.jpg',panoid)),'Quality',100);
    
end

end