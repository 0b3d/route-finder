mapfile = 'london_new.osm';
dataset = 'oxford_10_19'; %The name of the dataset, creates a folder in /Data
test_num = 100; % The number of test routes
max_route_length_init = 40; % the lenght of the routes
threshold = 60; % turn threshold
road_dense_distance = 10;
% drop threshold for routes
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
% consistency metric
overlap = 0.8; % 80%
s_number = 5; % 5 successive locations

% parameters for BSD freatures
radius = 35; % search radius is 35m
thresh = 10; % filter inters if their angles is below 10 degree
accuracy = 0.75;


% choose features type
features_type = 'ES'; % 'BSD' 'ES' or 'none'
turns = 'true';
probs = 'true';
