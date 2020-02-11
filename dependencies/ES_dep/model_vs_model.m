clc
clear all
close all

models = {'v1', 'v4'};

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

% uk_datasets = { 'scattered_london', 'edinburgh_10_19', 'london_10_19','luton_v4','oxford_10_19', 'tonbridge_v2'}
% legend_text = {'Locations Eval','Edinburgh','London','Luton', 'Oxford', 'Tonbridge'};
nouk_datasets = {'newyork_10_19', 'paris_10_19', 'rome_v1', 'toronto_v1', 'washington_10_19'}
% legend_text = {'New York','Paris', 'Rome', 'Toronto','Washington'};

%all_datasets = {'edinburgh_10_19', 'london_10_19', 'luton_v4', 'newyork_10_19', 'paris_10_19', 'rome_v1', 'toronto_v1'}
%legend_text = {'Edinburgh', 'LondonD', 'Luton', 'New York', 'Paris', 'Rome', 'Toronto'}

cvpr_datasets = {'edinburgh_10_19', 'london_10_19', 'luton_v4', 'newyork_10_19', 'toronto_v1'}
legend_text = {'Edinburgh', 'LondonD', 'Luton', 'New York', 'Toronto','Edinburgh', 'LondonD', 'Luton', 'New York', 'Toronto'}
datasets = cvpr_datasets;
ndatasets = length(datasets);
ax = gca;
%% ES top 1 accuracy
for mdl=1:length(models)
    model = models{mdl};
    ax.ColorOrderIndex = 1;
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
        % regenerate to be sure to use latest features
        load(results_filename, 'accuracy_with_different_length')

        if strcmp(model, 's2v700k_v1')
            linestyle = '-';
        else
            linestyle = '--';
        end
        x = 5:5:40;
        plot(x, accuracy_with_different_length(1,:), 'LineStyle', linestyle, 'LineWidth',2.0)
        grid on
        hold on

    end
end
    xlabel('Route lenght', 'FontName', 'Times')
    ylabel('Correct localisations %', 'FontName', 'Times')
    ylim([0.2,1]);
    legend(legend_text, 'FontName', 'Times', 'Location', 'southeast')
    grid on

    figure_filename = ['ES_results/',model,'/figures/','top1modelvsmodel',params.features_type,params.turns,params.probs,'.png'];
    saveas(gcf, figure_filename, 'png')
