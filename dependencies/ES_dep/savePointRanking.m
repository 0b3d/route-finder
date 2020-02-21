clear all;
ESparams;
load(params.ESFeaturesPath);
pairwise_dist = pairwise_distances(routes); %[Y,X] matrix
[sorted_dist, index] = sort(pairwise_dist, 2); %sort rows
pointRanking = index;

filepath = fullfile('results/ES', params.model, params.tile_test_zoom, params.dataset,'pointRanking.mat')
save(filepath, 'pointRanking')
