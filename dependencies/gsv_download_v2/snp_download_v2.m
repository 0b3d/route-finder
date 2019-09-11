function snp_download_v2(panos, panoDir, files_jpg)
outfolder = 'new_snaps_2';
if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

% required params
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
    %horizontalFov = 2 * atan(tan(verticalFov / 2) * imageSize(2) / imageSize(1) );
end

parfor_progress('snapshots',length(panos));
for i=1:length(panos)
    pano = imread(fullfile(panoDir, files_jpg{i}));
    panoid = panos(i).id;
%     yaw = panos(i).yaw * pi / 180;
    yaw = panos(i).yaw_o * pi / 180;
    tiltyaw = panos(i).tiltyaw * pi / 180;
    tiltpitch = panos(i).tiltpitch * pi / 180;
    rotation = rotation3_z(yaw - tiltyaw).' * rotation3_y(tiltpitch) * rotation3_z(-tiltyaw);
    
    destIm_f = snp_download_v1(pano, yaw, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_b = snp_download_v1(pano, yaw + 3.1414, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_r = snp_download_v1(pano, yaw + 1.5707, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    destIm_l = snp_download_v1(pano, yaw + 4.7123, imageSize, verticalFov, rotation, bicubic, isDoubleImage);
    
    destIm_fs = imresize(destIm_f,[227 227]);
    destIm_bs = imresize(destIm_b,[227 227]);
    destIm_rs = imresize(destIm_r,[227 227]);
    destIm_ls = imresize(destIm_l,[227 227]);

    imwrite(destIm_fs,fullfile(outfolder,sprintf('%s_front.jpg',panoid)));
    imwrite(destIm_bs,fullfile(outfolder,sprintf('%s_back.jpg',panoid)));
    imwrite(destIm_rs,fullfile(outfolder,sprintf('%s_right.jpg',panoid)));
    imwrite(destIm_ls,fullfile(outfolder,sprintf('%s_left.jpg',panoid)));
    parfor_progress('snapshots');   
end

end