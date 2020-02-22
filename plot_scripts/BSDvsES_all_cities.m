clc
clear all
close all

model = 'v1';
zoom = 'z18'

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
params.BSDacc = '75'
%option = {features_type,turns, probs};

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'}
legend_text = {'Hudson River ES', 'Union Square ES', 'Wallstreet ES','Hudson River BSD', 'Union Square BSD', 'Wallstreet BSD'}
ndatasets = length(datasets);
features = {'ES', 'BSD'};
%% ES top 1 accuracy
ax = gca;
for f=1:2
    ax.ColorOrderIndex = 1;
    feat = features{f};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};

        % load features
        if strcmp(feat, 'ES')
            ESresults_filename =  fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'.mat']);
            load(ESresults_filename, 'ranking')
            linestyle = '-';
        else
            BSDresults_filename = fullfile('sub_results/BSD',dataset,params.turns,['ranking_',params.BSDacc, '.mat'])
            load(BSDresults_filename, 'ranking')
            linestyle = '--';
        end
        
        x = 1:1:40;
        acc = sum(ranking == 1, 1)/size(ranking,1);
        plot(x, acc(x), 'LineStyle', linestyle, 'LineWidth',2.0)
        grid on
        hold on

    end
end
xlabel('Route lenght', 'FontName', 'Times')
ylabel('Correct localisations %', 'FontName', 'Times')
ylim([0,1]);
legend(legend_text, 'FontName', 'Times', 'Location', 'southeast')
grid on

