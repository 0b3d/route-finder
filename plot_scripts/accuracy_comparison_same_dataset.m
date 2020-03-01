% Plots accuracy for a given dataset based in, top 1, top 5,  and distance threshold 10m 20m

clear all
params.features_type = 'ES';
params.datasets = {'unionsquare5k', 'wallstreet5k'};

params.zoom = 'z18';
params.model = 'v1';
params.turns = 'true';
params.probs = 'false';

%colors = {'r','b', 'g', 'm'};
colors = {	[0, 0.4470, 0.7410], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250],[0.4940, 0.1840, 0.5560]};
c = 0;
for d=1:length(params.datasets)
    params.dataset = params.datasets{d};
    thresholds = [0, 20];
    linestyles = {':','-'}
    params.k=1;
    c = c + 1 ;
    %% Load geodistances matrix (with shape (500,40,5)) and then compute the accuracy given a threshold
    if strcmp(params.features_type, 'ES')
        fileName = fullfile('results/ES', params.model, params.zoom, params.dataset,[params.features_type,params.turns,params.probs,'_distance_threshold_5.mat']);
    else
        option = [params.features_type, params.turns ,params.probs]; 
        accuracy = 0.75;
        fileName = fullfile(['results/BSD/',params.dataset,'/',option,'_distance_threshold_5.mat']); 
    end
    load(fileName);

    %% Compute accuracy for each threshold and considering top params.k points
    acc = zeros(size(thresholds,2),40);
    for th=1:size(thresholds,2)
        temp = (geo_distances <= thresholds(1,th));
        temp = temp(:,:,1:params.k); %Taparams.ke into account only the top-params.k points
        % reduce one dimension checparams.king if we got a one in some point
        temp = any(temp,3); %Reduce top-params.k dimension
        acc(th,:) = sum(temp(:,:,1), 1)/500;
        plot(100*acc(th,:)','LineWidth',1.0, 'LineStyle', linestyles{th}, 'Color', colors{c})
        hold on
    end
    hold on 

    %% Compute accuracy for each threshold and considering top 5 points
    params.k=5;
    c = c + 1;
    acc = zeros(size(thresholds,2),40);
    for th=1:size(thresholds,2)
        temp = (geo_distances <= thresholds(1,th));
        temp = temp(:,:,1:params.k); %Taparams.ke into account only the top-params.k points
        % reduce one dimension checparams.king if we got a one in some point
        temp = any(temp,3); %Reduce top-params.k dimension
        acc(th,:) = sum(temp(:,:,1), 1)/500;
        plot(100*acc(th,:)','LineWidth',1.0, 'LineStyle', linestyles{th}, 'Color', colors{c})
        hold on
    end

end

grid on

%%% Save plot
ax = gca;
fig = gcf;
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Correct localisations (%)', 'FontName', 'Times', 'FontSize', 10)
basic_plot_configuration;
legend_text = {'US Top1+0m','US Top1+20m','US Top5+0m','US Top5+20m', ...
               'WS Top1+0m','WS Top1+20m','WS Top5+0m','WS Top5+20m'};
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 6)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts/top5_vs_threshold/', ['top1_top5_and_distance_threshold_accuracy_comparison_',params.features_type,params.turns]);
saveas(ax, filename,'epsc')