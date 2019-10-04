mapfile = 'test.osm';
dataset = 'test'; %The name of the dataset, creates a folder in /Data
test_num = 10; % The number of test routes
max_route_length_init = 20; % the lenght of the routes
threshold = 60; % turn threshold
road_dense_distance = 10;
% drop threshold for routes
accuracy = 0.75;
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];

features_type = 'none'; % 'BSD' 'ES' or 'none'
turns = 'false';
probs = 'true';