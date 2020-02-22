clear all
ESparams;

route_index = 12;
step_index = 20;

load(params.ESResultsPath, 'dist', 'ranking');
distances = dist{1,route_index}{1, step_index};
h = histogram(distances)
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
I = find( distances <= th)
% R = R_(I, :)