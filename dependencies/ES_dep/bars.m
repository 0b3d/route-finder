clc
clear all
close all

model = 's2v700k_v1';

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

dataset = 'london_10_19'
load('ES_results/BSD_accuracies.mat')

groups = 8;
range = 5:5:20;
data = zeros(size(range,2),5); 


%% load ranking using only turn information
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'only'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'ranking');
acc = sum(ranking == 1, 1)/size(ranking,1);
col = acc(1,range)';
data(:,1) = col;

%% load ranking using ES w/o turns
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'ranking');
acc = sum(ranking == 1, 1)/size(ranking,1);
col = acc(1,range)';
data(:,4) = col;


%% load ranking ES + turn
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
load(results_filename, 'ranking');
acc = sum(ranking == 1, 1)/size(ranking,1);
col = acc(1,range)';
data(:,5) = col;


%% load ranking using BSD w/o turns
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
load(bsd_results_file, 'ranking')
acc = sum(ranking == 1, 1)/size(ranking,1);
col = acc(1,range)';
data(:,2) = col;


%% load ranking BSD + turn
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_75.mat'];
load(bsd_results_file, 'ranking')
acc = sum(ranking == 1, 1)/size(ranking,1);
col = acc(1,range)';
data(:,3) = col;
data = 100 * data;



%% Make plot
b = bar(range, data, 'FaceColor','flat','EdgeColor',[1 1 1])


b(1).FaceColor = [0.75 0.75 0.75];
b(2).FaceColor  = [0.9290 0.6940 0.1250];
b(3).FaceColor  = [0.8500 0.3250 0.0980];
b(4).FaceColor  = [0 0.4470 0.7410];
b(5).FaceColor  = [0 0 1];


% cmap = colormap(jet);
% for k = 1:5
%     b(k).FaceColor = cmap(10*k,:);
% end
xlabel('Route length', 'FontName', 'Times','FontSize', 12)
ylabel('Correct localisations (%)', 'FontName', 'Times', 'FontSize', 12)
legend({'Turns', 'BSD', 'BSD+Turns', 'ES', 'ES+Turns'}, 'FontName', 'Times', 'Location', 'northwest','FontSize', 10)
grid on 


% accs = {'70','80','90','100'};
% for i = 1:length(accs)
%     acc = accs{i};
%     bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_', acc,'.mat'];
%     load(bsd_results_file, 'ranking')
%     res = sum(ranking <= k, 1)/size(ranking,1);
%     plot(range, res(range),  'LineStyle','--', 'LineWidth',2.0)
%     hold on
% end
% 
% res = sum(ranking_ES <= k, 1)/size(ranking,1);
% plot(range, res(range),  'LineStyle','-', 'LineWidth',2.0)
% grid on
% 
% legend_text = {'BSD 70%','BSD 80%','BSD 90%','BSD 100%', 'ES'}
% legend(legend_text, 'Location', 'southeast')
