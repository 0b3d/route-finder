function downloadGSV_v1(panoid, outfolder, zoom)
TILE_WIDTH = 512;
TILE_HEIGHT = 512;
ZOOM0_WIDTH = 416;
ZOOM0_HEIGHT = 208;
  
width = ZOOM0_WIDTH * bitshift(1, zoom);
height = ZOOM0_HEIGHT * bitshift(1, zoom);
  
im = uint8(zeros(height, width, 3) );
  
for tileY = 0 : ceil(height / TILE_HEIGHT) - 1
    for tileX = 0 : ceil(width / TILE_WIDTH) - 1
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
        % random - hopefully not Google kicking us off for over-doing it
        if tries >= 3
            sprintf('ERROR: third attempt failed to retrieve %s\n', url);
            rethrow(err);
        end
        
        if ~gotImage
            warning('Attempt %d failed to retrieve %s\n', tries, url);
            pause(3);  % Wait 10 seconds if we failed the first time.
        end
        end
        
        tileIm = imread(url);
        % Put into the main image
        xs = (tileX * TILE_WIDTH + 1) : ( (tileX + 1) * TILE_WIDTH);
        ys = (tileY * TILE_HEIGHT + 1) : ( (tileY + 1) * TILE_HEIGHT);
        im(ys, xs, 1:3) = uint8(tileIm);
    end
end

im = im(1 : height, 1 : width,:);
imwrite(im,fullfile(outfolder,sprintf('%s.jpg',panoid)),'Quality',100);

end