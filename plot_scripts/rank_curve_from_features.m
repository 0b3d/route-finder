clc
clear all
close all

models = {'v1'};
zoom = 'z18'
datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'}
legend_text = {'Hudson River','Union Square', 'Wallstreet'};

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
        [pano_ids,X,Y] = remove_duplicated_points(pano_id, X, Y);

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

        plot(x,accuracy, 'LineStyle', linestyle, 'LineWidth',1.5)
        hold on

    end
end

xlabel('k (as a fraction of the dataset size)', 'FontName', 'Times','FontSize', 12)
ylabel('Top k recall', 'FontName', 'Times','FontSize', 12)
ylim([0,1]);
xlim([0,0.8]);
legend(legend_text, 'FontName', 'Times','FontSize', 10)
grid on

