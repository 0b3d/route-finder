% compare test routes
clear all
load('result_yam_LR_100.mat');
result_LR = result;
load('result_yam_binary_100.mat');
result_binary = result;
error = [];
for i=1:200
    if result_binary(i,1)~=result_LR(i,1)
        error = [error;i]; % reasonable, because the route length is different!
    end
end