
% Combine datasets for training 
clear all
clc


routes_manhattan = load(['Data/manhattan_train.mat']);
routes_pittsburgh = load(['Data/pittsburgh_train.mat']);

routes_manhattan = routes_manhattan(1).routes;
routes_pittsburgh = routes_pittsburgh(1).routes;


for i=1:length(routes_manhattan)
   routes_manhattan(i).city = 'manhattan';
end
routes = routes_manhattan;

for idx=1:length(routes_pittsburgh)
    i = idx + length(routes_manhattan);
    routes(i).id = routes_pittsburgh(idx).id;
    routes(i).gsv_coords = routes_pittsburgh(idx).gsv_coords;
    routes(i).gsv_yaw = routes_pittsburgh(idx).gsv_yaw;
    routes(i).neighbor = routes_pittsburgh(idx).neighbor;
    routes(i).bearing = routes_pittsburgh(idx).bearing;
    routes(i).oidx = routes_pittsburgh(idx).oidx;
    routes(i).city = 'pittsburgh';
end

save('Data/trainstreetlearn.mat','routes');