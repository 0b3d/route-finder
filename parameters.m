mapfile = 'manhattan.osm';
city = 'manhattan';
dataset = 'unionsquare5k'; %The name of the dataset, creates a folder in /Data
subset = 'combined';
% lowerlat = 40.7171;
% upperlat = 40.7535;
% lowerlon = -74.028;
% upperlon = -73.940;

test_num = 500; % The number of test routes
max_route_length_init = 40; % the lenght of the routes
threshold = 60; % turn threshold
road_dense_distance = 10;
% drop threshold for routes
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
% consistency metric
overlap = 0.8; % 80%
s_number = 5; % 5 successive locations

%% parameters for BSD freatures
radius = 35; % search radius is 35m
thresh = 10; % filter inters if their angles is below 10 degree
range = 2; % generate rays every _degree

accuracy = 1; % CNN accuracy
% accuracy_jcf = 1;
% accuracy_bdr = 0.8;
% accuracy_jcb = 1;
% accuracy_bdl = 0.8;

thresh_jc = 30; % 30m
thresh_bd = 3;  % 4 degree
thresh_dist = 5; % 5m
max_rays = 43; % 90/2 - 2


% choose features type
features_type = 'ES'; % 'BSD' 'ES' or 'none'
model = 'v1';
tile_test_zoom = 'z18' ;
turns = 'only'; % 'true', 'false', 'only'
probs = 'false'; % for 'BSD', set this to 'false'
