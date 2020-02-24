clc
clear all
close all

model = 'v1';
% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
turns = {'true','false'};
params.probs = 'false'; % for 'BSD', set this to 'false'
params.zoom = 'z18'

%option = {features_type,turns, probs};

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'}
legend_text = {'Hudson River ES+T', 'Union Square ES+T', 'Wallstreet ES+T','Hudson River ES', 'Union Square ES', 'Wallstreet ES'}

ndatasets = length(datasets);

%% ES top 1 accuracy
ax = gca;
for t = 1:2
    ax.ColorOrderIndex = 1;
    turn_flag = turns{t};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        results_filename = ['results/ES/',model,'/', params.zoom, '/', dataset,'/',params.features_type,turn_flag,params.probs,'.mat'];
        % regenerate to be sure to use latest features
        load(results_filename, 'accuracy_with_different_length')

        if strcmp(turn_flag, 'true')
            linestyle = '-';
        else
            linestyle = '--';
        end
        x = 5:5:40;
        plot(ax, x, 100*accuracy_with_different_length(1,:), 'LineStyle', linestyle, 'LineWidth',1.5)
        grid on
        hold on
    end
end

xlabel(ax, 'Route length')
ylabel(ax, 'Correct localisations (%)')
%set(ax,'Ytick',0:20:100)

%ylim([0.2,1]);

grid on
basic_plot_configuration;
legend(ax, legend_text, 'location', 'southeast','FontName', 'Times', 'FontSize', 7)
fig = gcf
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts', 'ES_turns_vs_noturns');
saveas(ax, filename,'epsc')



