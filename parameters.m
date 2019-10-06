mapfile = 'oxford_new.osm';
dataset = 'oxford_10_19'; %The name of the dataset, creates a folder in /Data
test_num = 500; % The number of test routes
max_route_length_init = 20; % the lenght of the routes
threshold = 60; % turn threshold
road_dense_distance = 10;
% drop threshold for routes
accuracy = 0.75;
overlap = 0.8; % 80%
s_number = 5; % 5 successive locations
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];

features_type = 'ES'; % 'BSD' 'ES' or 'none'
turns = 'true';
probs = 'true';
