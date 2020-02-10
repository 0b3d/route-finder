mapfile = 'pittsburgh.osm';
dataset = 'unionsquare5k'; %The name of the dataset, creates a folder in /Data
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

% parameters for BSD freatures
radius = 35; % search radius is 35m
thresh = 10; % filter inters if their angles is below 10 degree
accuracy = 0.75;
accuracy_jcf = 1;
accuracy_bdr = 0.8;
accuracy_jcb = 1;
accuracy_bdl = 0.8;

range = 2; % generate rays every _degree
thresh_jc = 50; % 30m
thresh_bd = 3;  % 4 degree
thresh_dist = 5; % 5m


% choose features type
features_type = 'ES'; % 'BSD' 'ES' or 'none'
model = 'v4_25e'
tile_test_zoom = 'z18' 
turns = 'true'; % 'true', 'false', 'only'
probs = 'false'; % for 'BSD', set this to 'false'


params = struct 
params.model = 'v4_25e'
params.tile_test_zoom = 'z18'
params.turns = 'true'
params.probs = 'false'

params.option = [features_type, turns ,probs];
params.resultsPath = ['results/', model, '/', params.tile_test_zoom, '/' , dataset, '/',params.option,'.mat']
%params.resultsPath = ['results/', model, '/', params.tile_test_zoom, '/' , dataset, '/results/',params.option,'.mat']
