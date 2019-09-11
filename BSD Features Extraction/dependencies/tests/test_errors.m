load('error_jc_test.mat');
load('buildings.mat');
load('inters.mat');
load('ways.mat');

% mode = 1; % sparse mode
% figure(1)
% display_map(ways, inters, buildings, mode);
% radius = 30;

count = 0;
for i=1:size(error_jc)
error = error_jc.errorLabel_jc(i); 
if error == 'cate1'
    count = count + 1;
end   
end
% forward - black, backward - magenta, left - blue, right - green
%for i=1:size(descriptors, 2)
for i=1:size(error_jc)
    curlocation = cell2mat(error_jc.errorCoord_jc(i));
    curyaw = cell2mat(error_jc.errorYaw_jc(i));
    truth = error_jc.truthLabel_jc(i);
    error = error_jc.errorLabel_jc(i);
    color = error_jc.errorColor_jc(i);
    
    disp('truth: ');
    disp(truth);
    disp('error: ');
    disp(error);
    disp(color);
    display_searchcircles(curlocation, curyaw, radius);
    text(curlocation(2)+0.00003,curlocation(1)+0.00001,num2str(i));
end
