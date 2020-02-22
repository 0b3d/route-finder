function rdhist(distances, gt_dist)
    h = histogram(distances)
    hold on
    % Plot a line over the histogram corresponding to the gt distance
    %line()
    binIndex = ceil((gt_dist - h.BinLimits(1,1)) / (h.BinWidth))
    coords = [gt_dist, 0; gt_dist, h.Values(binIndex)];
    l = plot(coords(:,1), coords(:,2), 'LineWidth', 8);
end

