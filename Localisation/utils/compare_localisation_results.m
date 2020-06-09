% compare localisation results
clear all
load('result_150_75.mat');
result_75 = result;
load('result_150_80.mat');
result_80 = result;
idx = [];
result_75_sub = [];
result_80_sub = [];
for i=1:150
    if result_75(i,3) == 1 && result_80(i,3)~=1
        idx = [idx;i];
        result_75_sub = [result_75_sub; result_75(i,:)];
        result_80_sub = [result_80_sub; result_80(i,:)];
    end
end
