clc
clear all
close all

model = 'v1';
% choose features type
params.features_type = 'BSD'; % 'BSD' 'ES' or 'none'
turns = {'true','false'};
params.probs = 'false'; % for 'BSD', set this to 'false'
params.zoom = 'z18';
params.top = 'top1';

%option = {features_type,turns, probs};

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'};
legend_text = {'Hudson River BSD+T', 'Union Square BSD+T', 'Wall Street BSD+T','Hudson River BSD', 'Union Square BSD', 'Wall Street BSD'};

ndatasets = length(datasets);

%% ES top 1 accuracy
ax = gca;
for t = 1:2
    ax.ColorOrderIndex = 1;
    turn_flag = turns{t};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        results_filename = fullfile('sub_results/BSD/',dataset, params.top,turn_flag,'ranking_75.mat');
        % regenerate to be sure to use latest features
        load(results_filename, 'res')
        ranking = sum(res == 1, 1)/size(res,1);

        if strcmp(turn_flag, 'true')
            linestyle = '-';
        else
            linestyle = '--';
        end
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
% filename = fullfile('results_for_eccv', 'charts_overlap', ['ES_turns_vs_noturns_', params.top]);
filename = fullfile('results_for_bsd', ['BSD_turns_vs_noturns_', params.top]);
saveas(ax, filename,'epsc')



