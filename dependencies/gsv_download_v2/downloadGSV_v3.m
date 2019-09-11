function downloadGSV_v3(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip)
% download panoramas
if(~skip)
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
    
    % crop the pano to snapshots
    rotation = rotation3_z(yaw - tiltyaw).' * rotation3_y(tiltpitch) * rotation3_z(-tiltyaw);
    isDoubleImage = true;
    imageSize = [1240 480];
    fov = 65 * pi / 180;
    isVerticalFov = true;
    bicubic = true;

    if fov > 2 * pi
        warning('Vertical field of view is more than 2pi - perhaps you forgot to convert to radians?');
    end

    if ~isVerticalFov
        horizontalFov = fov;
        verticalFov = 2 * atan(tan(horizontalFov / 2) * imageSize(1) / imageSize(2) );
    else
        verticalFov = fov;
        horizontalFov = 2 * atan(tan(verticalFov / 2) * imageSize(2) / imageSize(1) );
    end

    destIm_f = snp_download_v1(pano, yaw, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_b = snp_download_v1(pano, yaw + 3.1414, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_r = snp_download_v1(pano, yaw + 1.5707, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_l = snp_download_v1(pano, yaw + 4.7123, imageSize, verticalFov, rotation, bicubic, isDoubleImage);

    destIm_fs = imresize(destIm_f,[227 227]);
    destIm_bs = imresize(destIm_b,[227 227]);
    destIm_rs = imresize(destIm_r,[227 227]);
    destIm_ls = imresize(destIm_l,[227 227]);

    imwrite(destIm_fs,fullfile(outfolder_s,sprintf('%s_front.jpg',panoid)));
    imwrite(destIm_bs,fullfile(outfolder_s,sprintf('%s_back.jpg',panoid)));
    imwrite(destIm_rs,fullfile(outfolder_s,sprintf('%s_right.jpg',panoid)));
    imwrite(destIm_ls,fullfile(outfolder_s,sprintf('%s_left.jpg',panoid)));
end

end