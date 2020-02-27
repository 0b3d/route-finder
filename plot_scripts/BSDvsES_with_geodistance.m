clc
clear all
close all

model = 'v1';
zoom = 'z18'

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

dataset = 'wallstreet5k'
range = 1:1:40;
R = 30; % Threshold in meters for the comparison, a point is given for localised if the threshold is withing this radius
bsd_accuracies = {'70','75','80','90','100'};
k = 5;

% Load geodistances matrix (with shape (500,40,5)) and then compute the accuracy given a threshold
if strcmp(params.features_type, 'ES')
    fileName = fullfile('results/ES', model, zoom, dataset,[params.features_type,params.turns,params.probs,'_distance_threshold.mat']);
else
    option = [params.features_type, params.turns ,params.probs]; 
    accuracy = 0.75;
    fileName = fullfile(['results/BSD/',dataset,'/',option,'_distance_threshold_5.mat']); 
end
load(fileName);


% Plot accuracy of ES
temp = (geo_distances <= R); 
temp = temp(:,:,1:k); %Take into account only the top-k points
% reduce one dimension checking if we got a one in some point
temp = any(temp,3); %Reduce top-k dimension
ES_acc = sum(temp(:,:,1), 1)/500;
plot(100*ES_acc,  'LineStyle','-', 'LineWidth',2.0)
hold on 


% Plot accuracy of BSD for any classifier accuracy
accs = {0.60,0.75,0.80,0.90,1};
params.features_type = 'BSD'; % 'BSD' 'ES' or 'none'
for i = 1:length(accs) 
    accuracy = accs{i};
    option = [params.features_type, params.turns ,params.probs]; 
    fileName = fullfile(['sub_results/BSD/',dataset,'/',option,'_',num2str(accuracy*100),'_distance_threshold_5.mat']); 
    load(fileName)
    
    temp = (geo_distances <= R); 
    temp = temp(:,:,1:k); %Take into account only the top-k points
    % reduce one dimension checking if we got a one in some point
    temp = any(temp,3); %Reduce top-k dimension
    BSD_acc = sum(temp(:,:,1), 1)/500;
    plot(100*BSD_acc,  'LineStyle','--', 'LineWidth',2.0)
    hold on 
end


ax = gca

grid on
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Correct localisations (%)', 'FontName', 'Times', 'FontSize', 10)
legend_text = {'ES','BSD 60 %','BSD 75 %','BSD 80 %','BSD 90 %','BSD 100 %'}
set(ax,'Ytick',0:20:100)

fig = gcf
basic_plot_configuration;
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 7)
fig.PaperPosition = [0 0 8 6];
%filename = fullfile('results_for_eccv', 'charts', ['ESvsBSD_turns_',params.turns,'_',dataset,'_top_',num2str(k)]);
filename = fullfile('results_for_eccv/charts/ESvsBSD_threshold/', ['ESvsBSD_turns_false_',dataset,'_top_',num2str(k),'_R_',num2str(R),'m']);
saveas(ax, filename,'epsc')

