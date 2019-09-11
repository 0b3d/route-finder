function destIm = snp_download_v1(im, yaw, imageSize, verticalFov, rotation, bicubic, isDoubleImage)  
% Get panorama data
panoIm = im2double(im);
panoImSize = size(panoIm);

% Compute destination pixel indices
IJ = fast_cartprod( (1 : imageSize(2) ).', (1 : imageSize(1) ).');
destIs = IJ(:,1);
destJs = IJ(:,2);
  
% Compute pixel rays.  Note that in this coordinate system the camera is
% facing x, with z pointing upward.  This is so that in a spherical coordinate
% system the azimuth will map to the column of the panorama image, and the
% elevation will map to the row.
  
focalLength = imageSize(2) / (2 * tan(verticalFov / 2) );
ys = (-0.5 + destJs(:) - imageSize(1) / 2);
zs = -(-0.5 + destIs(:) - imageSize(2) / 2);
xs = focalLength(ones(size(destIs) ),:);
rays = unitCols([ xs ys zs ].');
  
  
% Transform pixel rays due to pose of vehicle in the world.  It is assumed
% that the middle pixel of the panorama image is facing the same direction
% as the vehicle, so we 'undo' the vehicle pose to get a panorama image
% facing due north.
% Also rotate by 180 degrees around z because the middle of the image is the
% heading, not the origin.
  
rays = rotation * rotation3_z(yaw) * rays;
  
% Compute spherical coordinates and map to (fractional) sphere pixels
azimuth = atan2(rays(2,:), rays(1,:) );
elevation = atan2(sqrt(rays(1,:).^2 + rays(2,:).^2), rays(3,:) );
srcIs = 1 + panoImSize(1) * elevation / pi;
srcJs = panoImSize(2) * (azimuth + pi) / (2 * pi) + 1;
  
% Generate output image  
if bicubic
    % Bicubic interpolation
    srcIs = reshape(srcIs, imageSize(2), imageSize(1));
    srcJs = reshape(srcJs, imageSize(2), imageSize(1));
    destIm = ba_interp2(im2double(panoIm), srcJs, srcIs, 'cubic'); 
    %figure(1)
    %imshow(destIm);
    if isDoubleImage
        destIm(destIm > 1) = 1;
        destIm(destIm < 0) = 0;
        %destIm = destIm - min(destIm(:) ); % Could scale image values rather than
        %destIm = destIm / max(destIm(:) ); % threshold, but we lose some contrast.
    end
else
    % Nearest neighbour interpolation
    srcIs = round(srcIs).';
    srcJs = round(srcJs).';
    srcIs(srcIs > panoImSize(1) ) = panoImSize(1);
    srcJs(srcJs > panoImSize(2) ) = panoImSize(2);
    % Put into destination image
    one = ones(size(destIs) );
    destIm = uint8(zeros(imageSize(2), imageSize(1), 3) );
    destIm(sub2ind(size(destIm), destIs, destJs, one) ) = ...
        panoIm(sub2ind(size(panoIm), srcIs, srcJs, one) );
    destIm(sub2ind(size(destIm), destIs, destJs, 2 * one) ) = ...
        panoIm(sub2ind(size(panoIm), srcIs, srcJs, 2 * one) );
    destIm(sub2ind(size(destIm), destIs, destJs, 3 * one) ) = ...
        panoIm(sub2ind(size(panoIm), srcIs, srcJs, 3 * one) );
end

end