mapfile = 'tonbridge.osm';
dataset = 'tonbridge'; %The name of the dataset, creates a folder in /Data
test_num = 500; % The number of test routes
max_route_length_init = 20; % the lenght of the routes
threshold = 60; % turn threshold
% drop threshold for routes
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];

features_type = 'ES';
turns = 'true';
probs = 'true';