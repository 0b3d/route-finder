function [Tjc, Tbd] = genTabel(filepath, descriptors)
imageSet_jc = {};
labelSet_jc = {};
coordSet_jc = {};
yawSet_jc = {};
color_jc = {};

imageSet_bd = {};
labelSet_bd = {};
coordSet_bd = {};
yawSet_bd = {};
color_bd = {};
counter = 1;

for i=1:size(descriptors, 2)
    %disp(i);
    id = descriptors(i).id;
    desc = descriptors(i).BSDs;
    coords = descriptors(i).coords;
    yaw = descriptors(i).yaw;
    
    filename_front = strcat(filepath,id,'_front.jpg');
    filename_back = strcat(filepath,id,'_back.jpg');
    imageSet_jc{2*counter-1,1} = filename_front;
    color_jc{2*counter-1,1} = 'black';
    imageSet_jc{2*counter,1} = filename_back;
    color_jc{2*counter,1} = 'magenta';
    
    if desc(1) == 0
        label = 'cate2';
        %label = 'cate1';
    else
        label = 'cate1';
        %label = 'cate2';
    end
    labelSet_jc{2*counter-1,1} = label;
    
    if desc(3) == 0
        label = 'cate2';
        %label = 'cate1';
    else
        label = 'cate1';
        %label = 'cate2';
    end
    labelSet_jc{2*counter,1} = label;

    filename_left = strcat(filepath,id,'_left.jpg');
    filename_right = strcat(filepath,id,'_right.jpg');
    imageSet_bd{2*counter-1,1} = filename_left;
    color_bd{2*counter-1,1} = 'blue';
    imageSet_bd{2*counter,1} = filename_right;
    color_bd{2*counter,1} = 'green';
    
    if desc(4) == 0
        label = 'cate2';
        %label = 'cate1';
    else
        label = 'cate1';
        %label = 'cate2';
    end
    labelSet_bd{2*counter-1,1} = label;
    
    if desc(2) == 0
        label = 'cate2';
        %label = 'cate1';
    else
        label = 'cate1';
        %label = 'cate2';
    end
    labelSet_bd{2*counter,1} = label;
    
    % save coordinates and yaw for visualization check
    coordSet_jc{2*counter-1,1} = coords;
    coordSet_jc{2*counter,1} = coords;
    yawSet_jc{2*counter-1,1} = yaw;
    yawSet_jc{2*counter,1} = yaw;
    
    coordSet_bd{2*counter-1,1} = coords;
    coordSet_bd{2*counter,1} = coords;
    yawSet_bd{2*counter-1,1} = yaw;
    yawSet_bd{2*counter,1} = yaw;
    
    counter = counter+1; 
end

% Tjc = table(imageSet_jc,labelSet_jc);
% Tbd = table(imageSet_bd,labelSet_bd);
Tjc = table(imageSet_jc,labelSet_jc, coordSet_jc, yawSet_jc, color_jc);
Tbd = table(imageSet_bd,labelSet_bd, coordSet_bd, yawSet_bd, color_bd);

end