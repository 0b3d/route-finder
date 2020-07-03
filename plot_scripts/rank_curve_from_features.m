clc
clear all
close all

models = {'v1'};
zoom = 'z18'
datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'}
legend_text = {'Hudson River (32.3 %)','Union Square (31.84 %)', 'Wall Street (27.26 %)'};
%colormap = {'r','b','o'};

top1p = zeros(1, length(dataset));
ax = gca;

for mdl=1:length(models)
    model = models{mdl};
    ax.ColorOrderIndex = 1;
    for dset_index=1:length(datasets)
        dataset = datasets{dset_index};
        features_filename = ['features/ES/',model,'/', zoom, '/', dataset,'.mat'];
        % regenerate to be sure to use latest features
        load(features_filename)
        %[pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);

        % get pairwise distances
        distances = pdist2(Y,X); %y-x distances
        [sorted_distances, sorted_indices] = sort(distances, 2, 'ascend'); 
        labels = [1:1:size(Y,1)];

        ranking = zeros(1,size(labels,2));
        for i=1:size(labels,2)
           ranking(1,i) = find(labels(1,i) == sorted_indices(i,:));
        end

        accuracy = zeros(1,size(labels,2));
        for k = 1:size(labels,2)
            accuracy(1,k) = sum(ranking <= k) / size(ranking, 2);
            if k == floor(0.01 * size(labels,2))
                top1p(dset_index,1) = accuracy(1,k);
            end
        end

        x = labels / size(labels,2);

        if strcmp(model, 'v1')
            linestyle = '-';
        else
            linestyle = '--';
        end

        plot(ax, x,accuracy,  'LineStyle', linestyle, 'LineWidth',1.5, 'Marker', '.', 'MarkerSize',3)
        dataset
        accuracy(1,50)
        hold on

    end
end

xlim(ax,[0,0.8]);
set(ax,'Ytick',0:0.2:1)

xlabel(ax,'k (as a fraction of the dataset size)')
ylabel(ax,'Top k recall')
basic_plot_configuration;
legend(ax,legend_text, 'Location','southeast','FontName', 'Times', 'FontSize', 8)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts', 'ESTopK');
saveas(ax, filename,'epsc')
