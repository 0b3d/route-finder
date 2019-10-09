% compare Records
clear all 
close all
parameters;
load(['Data/',dataset,'/Records_2.mat'],'RRecord');
RRecord2 = RRecord;
load(['Data/',dataset,'/Records_5.mat'],'RRecord');
R1 = struct2table(RRecord);
R2 = struct2table(RRecord2);
I1 = R1.idx;
I2 = R2.idx;

lia = ismember(I1, I2);
count = size(I1,1) - sum(lia);
