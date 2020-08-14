clc
clear all
close all

p = ESParams;
p.name = 'brute_force'; 
p.topk = 5;
p.save = true;

datasets = {'hudsonriver5k','unionsquare5k','wallstreet5k'};
turns = {true,false};


legend_text = {'Hudson River ES+T', 'Union Square ES+T', 'Wall Street ES+T','Hudson River ES', 'Union Square ES', 'Wall Street ES'};
%legend top1
%legend_text = {'HR ES+T (93.0 %)', 'US ES+T (96.6 %)', 'WS ES+T (98.2 %)','HR ES (91.8 %)', 'US ES (95.8 %)', 'WS ES (93.0 %)'};
%legend top5
%legend_text = {'HR ES+T (97.2 %)', 'US ES+T (99.2 %)', 'WS ES+T (99.6 %)','HR ES (96.8 %)', 'US ES (99.0 %)', 'WS ES (96.8 %)'};

ndatasets = length(datasets);

%% ES top 1 accuracy
ax = gca;
for t = 1:length(turns)
    ax.ColorOrderIndex = 1;
    p.turns = turns{t};
    p = p.init();
    for dset_index=1:ndatasets
        p.dataset = datasets{dset_index};
        results_filename = fullfile(p.exp_dir,[p.dataset,'.mat']);
        % regenerate to be sure to use latest features
        load(results_filename, 'ranking')
        %ranking = sum(res == 1, 1)/size(res,1);
        acc = sum( ranking>0 & ranking<= p.topk, 1 ) / size( ranking,1 );
        if p.turns == 1
            linestyle = '-';
        else
            linestyle = '--';
        end
        x = 5:5:40;
        plot(ax, x, 100*acc(x), 'LineStyle', linestyle, 'LineWidth',1.5)
        grid on
        hold on
        p.dataset
        100*acc(x)
        
    end
end

xlabel(ax, 'Route length')
ylabel(ax, 'Top-1 Localisations (%)')
set(ax,'Ytick',0:20:100)
ylim([0,100]);
% 
grid on
basic_plot_configuration;
legend(ax, legend_text, 'location', 'southeast','FontName', 'Times', 'FontSize', 7)
fig = gcf;
fig.PaperPosition = [0 0 8 6];

if p.save == 1
    filename = fullfile(p.charts_dir, ['ES_turns_vs_noturns_', p.topk]);
    saveas(ax, filename,'epsc')
end


