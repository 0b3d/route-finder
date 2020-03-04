% This file computes an histogram of the distance difference between the gt
% and the estimated routes

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
%bins = 50;
n = 100;

% Get gt rank
load(params.ESResultsPath, 'dist', 'ranking');
gt_rank = ranking(route_index, step_index);

% Get distances
distances = dist{1,route_index}{1, step_index};

% get gt_distance
gt_dist = distances(gt_rank,1);

% Get the distances to the nearest neighbours
dist_difference = distances(1:n, 1) - gt_dist; 


%% plot histogram
h = histogram(dist_difference)
grid on

% save histograme
ax = gca
xlabel(ax, 'Distance difference', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Number of routes', 'FontName', 'Times', 'FontSize', 10)

fig = gcf
basic_plot_configuration;
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts','route_distance_histograms', ['difference_hist_route',num2str(route_index),'_length_',params.dataset,'_',params.option]);
saveas(ax, filename,'epsc')
saveas(ax, filename, 'png')

