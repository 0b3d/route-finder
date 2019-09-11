function [Tjc, Tbd] = genTabel_testing(filepath, descriptors)
imageSet_jc = {};
imageSet_bd = {};
counter = 1;

for i=1:length(descriptors)
    %disp(i);
    id = descriptors(i).id;
    
    filename_front = strcat(filepath,id,'_front.jpg');
    filename_back = strcat(filepath,id,'_back.jpg');
    imageSet_jc{2*counter-1,1} = filename_front;
    imageSet_jc{2*counter,1} = filename_back;    

    filename_left = strcat(filepath,id,'_left.jpg');
    filename_right = strcat(filepath,id,'_right.jpg');
    imageSet_bd{2*counter-1,1} = filename_left;
    imageSet_bd{2*counter,1} = filename_right;
   
    counter = counter+1; 
end

Tjc = table(imageSet_jc);
Tbd = table(imageSet_bd);

end