% Combine datasets for training 
clear all
clc

city = 'pittsburgh';
name = 'train2';
%areas = {'hudsonriver','unionsquare', 'wallstreet'};
areas = {'southshore'};


cityFilePath = fullfile('Data',city,[city,'.mat']);
load(cityFilePath); 


% for each area extract indices
for a=1:length(areas)
    area = areas{a};
    areaPath = fullfile('Data/streetlearn',[area, '5k.mat']);
    testareas{a} = load(areaPath, 'routes');
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


