function snp_download(new_imgH, new_imgShort, fov, panoDir, files, files_jpg, routes, I)

%outfolder = 'test_200_90';
outfolder_s = 'new_snaps_5';

% if ~exist(outfolder,'dir')
%     mkdir(outfolder)
% end

if ~exist(outfolder_s,'dir')
    mkdir(outfolder_s)
end

parfor_progress('snapshots',length(files));
for i = 1:length(files)
    curPanoid = files{i}(1:end-4);
    str = fileread(fullfile(panoDir, files{i}));
    panorama = imread(fullfile(panoDir, files_jpg{i}));
    panorama = double(panorama);

    % where is your center of the camera
    % x horizontal angle: range [-pi,   pi]
    % y vertical angle: range [-pi/2, pi/2]
    % front
    yaw_ind = strfind(str, 'pano_yaw_deg=');
    headings = str2double(panoExtract(yaw_ind, str));
    idx = find(ismember(I, curPanoid));
    headings_2 = routes(idx(1)).yaw_o;
    x = (headings_2 - headings)*pi/180; y = 0; 
    % x = 0; y = 0;
    % generate the crop
    %warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    warped_image = imgLookAt_v2(panorama, x, y, new_imgH, new_imgShort, fov );
    warped_image = uint8(warped_image);
    %warped_image = warped_image(round((new_imgH-new_imgShort)/2)+(1:new_imgShort),:,:);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_front.jpg',curPanoid)));

    small = imresize(warped_image, [227 227], 'bicubic');
    imwrite(small,fullfile(outfolder_s,sprintf('%s_front.jpg',curPanoid)));
        
    % back
    x = (headings_2 - headings)*pi/180-pi; y = 0;  
    % x = -pi; y = 0;
    % generate the crop
    %warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    warped_image = imgLookAt_v2(panorama, x, y, new_imgH, new_imgShort, fov );
    warped_image = uint8(warped_image);
    %warped_image = warped_image(round((new_imgH-new_imgShort)/2)+(1:new_imgShort),:,:);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_back.jpg',curPanoid)));

    small = imresize(warped_image, [227 227], 'bicubic');
    imwrite(small,fullfile(outfolder_s,sprintf('%s_back.jpg',curPanoid)));

    % left
    x = (headings_2 - headings)*pi/180-pi/2; y = 0;   
    % x = -pi/2; y = 0;
    % generate the crop
    %warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    warped_image = imgLookAt_v2(panorama, x, y, new_imgH, new_imgShort, fov );
    warped_image = uint8(warped_image);
    %warped_image = warped_image(round((new_imgH-new_imgShort)/2)+(1:new_imgShort),:,:);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_left.jpg',curPanoid)));

    small = imresize(warped_image, [227 227], 'bicubic');
    imwrite(small,fullfile(outfolder_s,sprintf('%s_left.jpg',curPanoid)));

    % right
    x = (headings_2 - headings)*pi/180+pi/2; y = 0;    
    % x = pi/2; y = 0;
    % generate the crop
    %warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    warped_image = imgLookAt_v2(panorama, x, y, new_imgH, new_imgShort, fov );
    warped_image = uint8(warped_image);
    %warped_image = warped_image(round((new_imgH-new_imgShort)/2)+(1:new_imgShort),:,:);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_right.jpg',curPanoid)));

    small = imresize(warped_image, [227 227], 'bicubic');
    imwrite(small,fullfile(outfolder_s,sprintf('%s_right.jpg',curPanoid)));

    parfor_progress('snapshots');
end

end