% This script compares localisation

model = 's2v700k_v1'
dataset = 'luton_v4';
params.turns = 'false'
params.probs = 'false'

% Load ranking 
bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
load(bsd_results_file, 'ranking');
bsd_ranking = ranking;

params.features_type = 'ES'
results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'ranking');
es_ranking = ranking;


% lets search for those examples where es_ranking is greater than bsd by a
% margin m=5 at least 5 nodes without turns
es_better_than_bsd_without = (bsd_ranking > es_ranking + 3); 

% now find the points where 
% Load ranking 
params.turns = 'true'
params.probs = 'false'
bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
load(bsd_results_file, 'ranking');
bsd_ranking_wt = ranking;

params.features_type = 'ES'
results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'ranking');
es_ranking_wt = ranking;

% lets search for those examples where es_ranking is greater than bsd by a
% margin m=5 at least 5 nodes with turns
es_better_than_bsd_with = (bsd_ranking > es_ranking + 2); 

%% combine masks
mask_where_bsd_greater_that_es = es_better_than_bsd_with .* es_better_than_bsd_without;

%% route inside top 5
es_top = (es_ranking<=1); 
bsd_top = (bsd_ranking<=1); 
es_top_wt = (es_ranking_wt<=1); 
bsd_top_wt = (bsd_ranking_wt<=1); 

topmask = es_top .* bsd_top;
topmask_wt = es_top_wt .* bsd_top_wt;
topmask_general = topmask .* topmask_wt;

final_mask = topmask_general .* mask_where_bsd_greater_that_es;

bsd_res = zeros(500,1);
es_res = zeros(500,1);
difference = zeros(500,1);

for i=1:500
   bsd_res(i,1) = find(bsd_ranking(i,:) == 1, 1, 'first');
   es_res(i,1) = find(es_ranking(i,:) == 1, 1, 'first');  
   difference(i,1) = bsd_res(i,1) -  es_res(i,1);
end

posible_routes_indices = find(difference >=5);
save('Results_CVPR/posible_routes_video.mat', 'posible_routes_indices', 'difference')