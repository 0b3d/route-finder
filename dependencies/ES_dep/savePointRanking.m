clear all;
ESparams;
load(params.ESFeaturesPath);
pairwise_dist = pairwise_distances(routes); %[Y,X] matrix
[sorted_dist, index] = sort(pairwise_dist, 2); %sort rows
pointRanking = index;

if strcmp(params.dataset,"cmu5k")
    filepath = fullfile('results/ES', params.model, params.tile_test_zoom, [params.dataset,'_',params.subset],'pointRanking.mat')
else
    filepath = fullfile('results/ES', params.model, params.tile_test_zoom, params.dataset,'pointRanking.mat')
end
save(filepath, 'pointRanking')
