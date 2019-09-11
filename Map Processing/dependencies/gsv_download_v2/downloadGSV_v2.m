function downloadGSV_v2(panoid, yaw, tiltyaw, tiltpitch, outfolder, outfolder_s, zoom, skip)
% download panoramas
if(~skip)
    tile_width = 512;
    tile_height = 512;
    width = tile_width*bitshift(1, zoom);
    height = tile_height*bitshift(1, zoom-1);
    zoom0_width = 416;
    zoom0_height = 208; 

    im = uint8(zeros(height, width, 3) );

    for tileY = 0 : ceil(height / tile_height) - 1
        for tileX = 0 : ceil(width / tile_width) - 1 
            tries = 0;
            gotImage = false;

            while ~gotImage
                % Download the tile image data
                url = sprintf('http://cbk0.google.com/cbk?output=tile&panoid=%s&zoom=%d&x=%d&y=%d&heading=340.78', ...
                panoid, zoom, tileX, tileY);

            try
                gotImage = true;
            catch err
                disp(err)
            end
            tries = tries + 1;

            % We'll try 3 times because when there is an error, it seems to be a bit
            % random - hopefully not Google kicking us off for over-doing it? :s
            if tries >= 3
                sprintf('ERROR: third attempt failed to retrieve %s\n', url);
                rethrow(err);
            end

            if ~gotImage
                warning('Attempt %d failed to retrieve %s\n', tries, url);
                break;
                pause(3);  % Wait 10 seconds if we failed the first time.
            end
            end

            try
                tileIm = imread(url);
            catch
                width = zoom0_width * bitshift(1, zoom);
                height = zoom0_height * bitshift(1, zoom);
                break;
            end
            % Put into the main image
            xs = (tileX * tile_width + 1) : ( (tileX + 1) * tile_width);
            ys = (tileY * tile_height + 1) : ( (tileY + 1) * tile_height);
            im(ys, xs, 1:3) = uint8(tileIm);
        end
    end

    im = im(1 : height, 1 : width,:);
    imwrite(im,fullfile(outfolder,sprintf('%s.jpg',panoid)),'Quality',100);

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

    destIm_f = snp_download_v1(im, yaw, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_b = snp_download_v1(im, yaw + 3.1414, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_r = snp_download_v1(im, yaw + 1.5707, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_l = snp_download_v1(im, yaw + 4.7123, imageSize, verticalFov, rotation, bicubic, isDoubleImage);

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