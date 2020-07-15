clc
clear all
close all

model = 'v2_12';
% choose features type
params.features_type = {'ES','BSD'}; % 'BSD' 'ES' or 'none'
params.turns = 'true';
params.probs = 'false'; % for 'BSD', set this to 'false'
params.zoom = 'z18';
params.top = 'top1';

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'};
legend_text = {'HR ES+T (93.0 %)', 'US ES+T (96.6 %)', 'WS ES+T (98.2 %)','HR BSD+T (59.0 %)', 'US BSD+T (52.2 %)', 'WS BSD+T (82.0 %)'};
%legend_text = {'HR ES (91.8 %)', 'US ES (95.8 %)', 'WS ES (93.0 %)','HR BSD (32.4 %)', 'US BSD (26.2 %)', 'WS BSD (37.4 %)'};

ndatasets = length(datasets);

%% ES top 1 accuracy
ax = gca;
for t = 1:2
    ax.ColorOrderIndex = 1;
    feature = params.features_type{t};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        if strcmp(feature, 'ES')
            linestyle = '-';
            results_filename = fullfile('sub_results_v2_12/',feature,'/',dataset, params.top,params.turns,'ranking.mat');
        else
            linestyle = '--';
            results_filename = fullfile('sub_results/',feature,'/',dataset, params.top,params.turns,'ranking_resnet18.mat');
        end        
        % regenerate to be sure to use latest features
        load(results_filename, 'res')
        ranking = sum(res == 1, 1)/size(res,1);

        x = 5:5:40;
        plot(ax, x, 100*ranking(x), 'LineStyle', linestyle, 'LineWidth',1.5)
        dataset
        100*ranking(x)
        grid on
        hold on
    end
end

xlabel(ax, 'Route length')
ylabel(ax, 'Top-1 Localisations (%)')
set(ax,'Ytick',0:20:100)
ylim([0,100]);

grid on
basic_plot_configuration;
legend(ax, legend_text, 'location', 'southeast','FontName', 'Times', 'FontSize', 6)
fig = gcf;
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts_16d', ['ESvsBSD_turns_',params.turns,'_',params.top]);
saveas(ax, filename,'epsc')



