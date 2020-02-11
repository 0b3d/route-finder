clc
clear all
close all

ESparams;

datasets = {'cmu5k', 'unionsquare5k', 'wallstreet5k'};
legend_text = {'CMU', 'Union Square', 'Wall Street'};

ndatasets = length(datasets);
ax = gca;

%% ES top 1 accuracy
ax.ColorOrderIndex = 1;
for dset_index=1:ndatasets
    dataset = datasets{dset_index};
    datasetPath = fullfile('results/ES', params.model, params.tile_test_zoom, dataset,[params.option,'.mat'])
    load(datasetPath, 'accuracy_with_different_length')

    x = 5:5:40;
    plot(x, accuracy_with_different_length(1,:), 'LineWidth',2.0)
    grid on
    hold on
end

xlabel('Route lenght', 'FontName', 'Times')
ylabel('Correct localisations %', 'FontName', 'Times')
ylim([0,1]);
legend(legend_text, 'FontName', 'Times', 'Location', 'southeast')
grid on

    %figure_filename = ['ES_results/',model,'/figures/','top1modelvsmodel',params.features_type,params.turns,params.probs,'.png'];
    %saveas(gcf, figure_filename, 'png')
