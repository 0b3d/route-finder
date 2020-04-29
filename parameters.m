mapfile = 'manhattan.osm';
city = 'train'; % manhattan, pittsburgh, train
dataset = 'trainstreetlearn'; %The name of the dataset, creates a folder in /Data
subset = 'combined'; %combined
% lowerlat = 40.7171;
% upperlat = 40.7535;
% lowerlon = -74.028;
% upperlon = -73.940;

test_num = 500; % The number of test routes
max_route_length_init = 40; % the lenght of the routes
threshold = 60; % turn threshold
threshold_ = 30;
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

accuracy = 0.75; % CNN accuracy
% accuracy_jcf = 0.8492;
% accuracy_bdr = 0.8632;
% accuracy_jcb = 0.8558;
% accuracy_bdl = 0.8578;

% accuracy_jc = 0.6664;
% accuracy_njc = 0.9383;
% accuracy_bd = 0.8564;
% accuracy_nbd = 0.8636;

thresh_jc = 30; % 30m
thresh_bd = 3;  % 4 degree
thresh_dist = 5; % 5m
max_rays = 43; % 90/2 - 2


% choose features type
features_type = 'BSD'; % 'BSD' 'ES' or 'none'
model = 'v1';
tile_test_zoom = 'z18' ;
turns = 'true'; % 'true', 'false', 'only'
probs = 'false'; % for 'BSD', set this to 'false'
