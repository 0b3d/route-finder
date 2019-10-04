function [front, left, right, back] = crop_panorama(new_imgH, fov, pano_id,dataset)
    path = ['Data/',dataset,'/panos/',pano_id,'.jpg'];
    panorama = imread(path);
    panorama = double(panorama);

    % where is your center of the camera
    % x horizontal angle: range [-pi,   pi]
    % y vertical angle: range [-pi/2, pi/2]
    
    % front
    % idx = find(ismember(I, curPanoid));
    % headings = routes(idx(1)).gsv_yaw;
    % headings_2 = routes(idx(1)).yaw;
    % x = (headings_2 - headings)*pi/180; y = 0; 
    x = 0; y = 0;
    % generate the crop
    warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    front = uint8(warped_image);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_front.jpg',curPanoid)));
        
    % back
    % x = (headings_2 - headings)*pi/180-pi; y = 0;  
    x = -pi; y = 0;
    % generate the crop
    warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    back = uint8(warped_image);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_back.jpg',curPanoid)));

    % left
    % x = (headings_2 - headings)*pi/180-pi/2; y = 0;   
    x = -pi/2; y = 0;
    % generate the crop
    warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    left = uint8(warped_image);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_left.jpg',curPanoid)));

    % right
    % x = (headings_2 - headings)*pi/180+pi/2; y = 0;    
    x = pi/2; y = 0;
    % generate the crop
    warped_image = imgLookAt(panorama, x, y, new_imgH, fov );
    right = uint8(warped_image);
    %imwrite(warped_image,fullfile(outfolder,sprintf('%s_right.jpg',curPanoid)));

end
