% This script compares localisation

model = 's2v700k_v1'
dataset = 'london_10_19';
params.turns = 'true'
params.probs = 'false'

% Load ranking 
bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
load(bsd_results_file, 'ranking');
bsd_ranking = ranking;

params.features_type = 'ES'
results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'ranking');
es_ranking = ranking;

bsd_res = zeros(500,1);
es_res = zeros(500,1);
difference = zeros(500,1);

for i=1:500
   bsd_res(i,1) = find(bsd_ranking(i,:) == 1, 1, 'first');
   es_res(i,1) = find(es_ranking(i,:) == 1, 1, 'first');  
   difference(i,1) = bsd_res(i,1) -  es_res(i,1);
end

posible_routes_indices = find(difference >=15);
save('Results_CVPR/posible_routes_video.mat', 'posible_routes_indices', 'difference')