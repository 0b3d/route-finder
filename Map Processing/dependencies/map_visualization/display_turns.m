% visualize turns
load('london_BSD_2degree_small_75.mat');
load('test_route_small_500.mat');
load('test_turn_small_LR_500NewNew.mat')
load('ways.mat');load('naturals.mat');load('leisures.mat');
load('buildings.mat');load('boundary.mat');
display_map_v3(ways, buildings, naturals, leisures, boundary);

i = 8;
for j=1:size(test_route,2)
    location = routes(test_route(i,j)).gsv_coords;
    yaw = routes(test_route(i,j)).gsv_yaw;
    BSD = routes(test_route(i,j)).BSDs;
    radius = 30;
    display_searchcircles(location, yaw, radius); 
    disp(BSD);
    if j>1
        T = test_turn(i,j-1);
        disp(T);
    end
end
