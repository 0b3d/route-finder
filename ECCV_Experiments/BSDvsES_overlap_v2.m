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
legend_text = {'Hudson River ES', 'Union Square ES', 'Wall Street ES','Hudson River BSD', 'Union Square BSD', 'Wall Street BSD'};

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
legend(ax, legend_text, 'location', 'southeast','FontName', 'Times', 'FontSize', 7)
fig = gcf;
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts_16d', ['ESvsBSD_turns_',params.turns,'_',params.top]);
saveas(ax, filename,'epsc')



