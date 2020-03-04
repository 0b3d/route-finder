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

route_index = 320;
step_index = 10;
bins = 50;

load(params.ESResultsPath, 'dist', 'ranking');
distances = dist{1,route_index}{1, step_index};
h = histogram(distances, bins)
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

grid on 

ax = gca
xlabel(ax, 'distance', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Number of routes', 'FontName', 'Times', 'FontSize', 10)
%legend_text = {'ES','BSD 70 %','BSD 75 %','BSD 80 %','BSD 90 %','BSD 100 %'}
%set(ax,'Ytick',0:20:100)

fig = gcf
basic_plot_configuration;
%legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts','route_distance_histograms', ['route',num2str(route_index),'_length_',params.dataset,'_',params.option]);
saveas(ax, filename,'epsc')
saveas(ax, filename, 'png')