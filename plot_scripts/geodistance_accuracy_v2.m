% Load geodistances file and then check the accuracy given a threshold
clear all
dataset = 'wallstreet5k';
zoom = 'z18';
model = 'v1';
params.features_type = 'BSD';
params.turns = 'false';
params.probs = 'false';
thresholds = [0,10,20,30];

if strcmp(params.features_type, 'ES')
    fileName = fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'_distance_threshold.mat']);
else
    option = [params.features_type, params.turns ,params.probs]; 
    accuracy = 0.75;
    fileName = fullfile(['sub_results/BSD/',dataset,'/',option,'_',num2str(accuracy*100),'_distance_threshold_5.mat']); 
end
load(fileName);

acc = zeros(size(thresholds,2),40);
for th=1:size(thresholds,2)
    temp = (geo_distances <= thresholds(1,th));
    % reduce one dimension checking if we got a one in some point 
    temp = any(temp,3);
    acc(th,:) = sum(temp(:,:,1), 1)/500;
end

legend_text = {'0 m','10 m','20 m','30 m'};
plot(acc','LineWidth',2.0)
grid on

%%% Save plot
ax = gca;
fig = gcf;
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
filename = fullfile('results_for_eccv', 'charts/top5_vs_threshold/', ['accuracy_',params.features_type,params.turns,'_',dataset,'_',num2str(accuracy*100),'_distance_thresholds']);
saveas(ax, filename,'epsc')