clc
clear all
close all

model = 'v2_12';
% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
turns = {'true','false'};
params.probs = 'false'; % for 'BSD', set this to 'false'
params.zoom = 'z18';
params.top = 'top1';

%option = {features_type,turns, probs};

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'};
%legend_text = {'Hudson River ES+T', 'Union Square ES+T', 'Wall Street ES+T','Hudson River ES', 'Union Square ES', 'Wall Street ES'};
% legend top1
legend_text = {'HR ES+T (93.0 %)', 'US ES+T (96.6 %)', 'WS ES+T (98.2 %)','HR ES (91.8 %)', 'US ES (95.8 %)', 'WS ES (93.0 %)'};
% legend top5
%legend_text = {'HR ES+T (97.2 %)', 'US ES+T (99.2 %)', 'WS ES+T (99.6 %)','HR ES (96.8 %)', 'US ES (99.0 %)', 'WS ES (96.8 %)'};

ndatasets = length(datasets);

%% ES top 1 accuracy
ax = gca;
for t = 1:2
    ax.ColorOrderIndex = 1;
    turn_flag = turns{t};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        results_filename = fullfile('sub_results_v2_12/ES/',dataset, params.top,turn_flag,'ranking.mat');
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
        dataset
        100*ranking(x)
        
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
filename = fullfile('results_for_eccv', 'charts_16d', ['ES_turns_vs_noturns_', params.top]);
saveas(ax, filename,'epsc')



