% Plots accuracy based in a distance threshold and a taking into account
% the top-k best estimated points

clear all
dataset = 'wallstreet5k';
zoom = 'z18';
model = 'v1';
params.features_type = 'ES';
params.turns = 'false';
params.probs = 'false';
thresholds = [0,10,20,30];
k=5;

% Load geodistances matrix (with shape (500,40,5)) and then compute the accuracy given a threshold
if strcmp(params.features_type, 'ES')
    fileName = fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'_distance_threshold.mat']);
else
    option = [params.features_type, params.turns ,params.probs]; 
    accuracy = 0.75;
    fileName = fullfile(['results/BSD/',dataset,'/',option,'_distance_threshold_5.mat']); 
end
load(fileName);

% Compute accuracy for each threshold and considering top k points
acc = zeros(size(thresholds,2),40);
for th=1:size(thresholds,2)
    temp = (geo_distances <= thresholds(1,th));
    temp = temp(:,:,1:k); %Take into account only the top-k points
    % reduce one dimension checking if we got a one in some point
    temp = any(temp,3); %Reduce top-k dimension
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
filename = fullfile('results_for_eccv', 'charts/top5_vs_threshold/', ['accuracy_',params.features_type,params.turns,'_',dataset,'_distance_thresholds']);
saveas(ax, filename,'epsc')