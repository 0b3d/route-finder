clear all
% choose features type
params = struct 
params.features_type = 'ES'
params.dataset = 'unionsquare5k'
params.subset = 'combined'
params.model = 'v1'
params.tile_test_zoom = 'z18'
params.turns = 'false'
params.probs = 'false'

params.option = [params.features_type, params.turns ,params.probs];
params.ESResultsPath = fullfile('results/ES', params.model, params.tile_test_zoom, params.dataset,[params.option,'.mat'])
params.ESFeaturesPath =  fullfile('features/ES',params.model, params.tile_test_zoom, ['ES_',params.dataset, '.mat'])

route_index = 33;
step_index = 10;

load(params.ESResultsPath, 'dist', 'ranking');
distances = dist{1,route_index}{1, step_index};
h = histogram(distances, 50)
hold on
% Plot a line over the histogram corresponding to the gt distance
gt_rank = ranking(route_index, step_index);
gt_dist = distances(gt_rank);
%line()
binIndex = ceil((gt_dist - h.BinLimits(1,1)) / (h.BinWidth))
coords = [gt_dist, 0; gt_dist, h.Values(binIndex)]
l = plot(coords(:,1), coords(:,2), 'LineWidth', 8)

max_dist = max(distances); 
mu = mean(distances);
sigma = std(distances);
th = (max_dist - mu)/2 + mu;
I = find( distances <= th);
% R = R_(I, :)