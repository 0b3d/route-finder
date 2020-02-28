% Load geodistances file and then check the accuracy given a threshold
clear all
dataset = 'unionsquare5k';
zoom = 'z18';
model = 'v1';
params.features_type = 'ES';
params.turns = 'true';
params.probs = 'false';
thresholds = [0,10,20,30];

if strcmp(params.features_type, 'ES')
    fileName = fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'_distance_threshold.mat']);
else
    option = [params.features_type, params.turns ,params.probs]; 
    accuracy = 0.75;
    fileName = fullfile(['results/BSD/',dataset,'/',option,'_distance_threshold.mat']); 
end
load(fileName);

acc = zeros(size(thresholds,2),40);
for th=1:size(thresholds,2)
    temp = (geo_distances <= thresholds(1,th));
    acc(th,:) = sum(temp, 1)/500;
end

legend_text = {'0 m','10 m','20 m','30 m'};
plot(acc','LineWidth',1.0)
grid on

%%% Save plot
ax = gca;
fig = gcf;
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts/top1_vs_threshold/', ['accuracy_',params.features_type,params.turns,'_',dataset,'_distance_thresholds']);
saveas(ax, filename,'epsc')