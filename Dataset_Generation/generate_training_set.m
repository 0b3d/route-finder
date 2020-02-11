% Combine datasets for training 
clear all
clc

city = 'pittsburgh';
name = 'train';
%areas = {'hudsonriver','unionsquare', 'wallstreet'};
areas = {'cmu'};

load(['Data/',city,'.mat']); 


% for each area extract indices
for a=1:length(areas)
    area = areas{a};
    testareas{a} = load(['Data/',city,'_', area,'5k.mat'], 'routes');
end

testindices = [];
for a=1:length(areas)
    for i=1:5000
        idx = testareas{a}.routes(i).oidx;
        testindices = [testindices; idx];
    end
end

allindices = [1:1:length(s)]'; 
% check if current id is in testid and generate train struct
trainSet = setdiff(allindices, testindices, 'rows');



% create a new struct from s and indices
routes = struct;

for i=1:size(trainSet)
    idx = trainSet(i);
    routes(i).id = s(idx).id;
    routes(i).gsv_coords = s(idx).gsv_coords;
    routes(i).gsv_yaw = s(idx).gsv_yaw;
    routes(i).neighbor = s(idx).neighbor;
    routes(i).bearing = s(idx).bearing;
    routes(i).oidx = idx;
end

save(['Data/', city ,'_', name,'.mat'],'routes');


