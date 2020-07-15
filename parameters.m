% parameters of BSD Extraction and Lolcaisation
mapfile = 'manhattan.osm';
city = 'manhattan'; % manhattan, pittsburgh, train
dataset = 'hudsonriver5k'; % The name of the dataset, creates a folder in /Data
subset = 'combined'; % combined
network = 'resnet18';
% lowerlat = 40.7171;
% upperlat = 40.7535;
% lowerlon = -74.028;
% upperlon = -73.940;

test_num = 50; % The number of test routes
max_route_length_init = 40; % the lenght of the routes
threshold = 60; % turn threshold
threshold_ = 30;
road_dense_distance = 10;
% drop threshold for routes
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
   100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
% N = [100, 100, 100, 100, 100, 90, 90, 90, 90, 90, 80, 80, 80, 80, 80, 70, 70, 70,...
%    70, 70, 70, 70, 70, 70, 70, 80, 80, 80, 80, 80, 90, 90, 90, 90, 90, 100, 100, 100, 100, 100];
% N = ones(1,40) * 50;
% N = [ones(1,5)*100 ones(1,5)*90 ones(1,5)*80 ones(1,5)*70 ones(1,5)*60 ones(1,15)*50];
min_num_candidates = 100; % Don't drop routes if the number of candidates is less than this number
% consistency metric
overlap = 0.8; % 80%
s_number = 5; % 5 successive locations

%% parameters for BSD freatures
radius = 35; % search radius is 35m
thresh = 10; % filter inters if their angles is below 10 degree
range = 2; % generate rays every _degree

accuracy = 0.75; % CNN accuracy
% accuracy_jcf = 0.815;
% accuracy_bdr = 0.8658;
% accuracy_jcb = 0.8252;
% accuracy_bdl = 0.8608;
% 
% accuracy_jc = 0.7883;
% accuracy_njc = 0.8347;
% accuracy_bd = 0.8769;
% accuracy_nbd = 0.8531;

thresh_jc = 30; % 30m
thresh_bd = 3;  % 4 degree
thresh_dist = 5; % 5m
max_rays = 43; % 90/2 - 2


% choose features type
features_type = 'BSD'; % 'BSD' 'ES' or 'none'
model = 'v2_12i';
tile_test_zoom = 'z18' ;
turns = 'true'; % 'true', 'false', 'only'
probs = 'false'; % not implemented anymore, keep only for naming compatibility
