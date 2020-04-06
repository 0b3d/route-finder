clc
clear all
close all

model = 'v1';
zoom = 'z18';

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
params.BSDacc = '75';
params.top = 'top1';
%option = {features_type,turns, probs};

dataset = 'unionsquare5k';
groups = 8;
range = 5:5:20;
data = zeros(size(range,2),5); 


%% load ranking using only turn information
params.features_type = 'BSD'; % 'BSD' 'ES' or 'none'
params.turns = 'only'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

ESresults_filename =  fullfile('sub_results/BSD',dataset,params.top,params.turns,'ranking.mat');
load(ESresults_filename, 'res');

acc = sum(res == 1, 1)/size(res,1);
col = acc(1,range)';
data(:,1) = col;

%% load ranking using ES w/o turns
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

ESresults_filename =  fullfile('sub_results/ES',dataset,params.top, params.turns,'ranking.mat');
load(ESresults_filename, 'res');

acc = sum(res == 1, 1)/size(res,1);
col = acc(1,range)';
data(:,4) = col;


%% load ranking ES + turn
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

ESresults_filename =  fullfile('sub_results/ES',dataset,params.top, params.turns,'ranking.mat');
load(ESresults_filename, 'res');

acc = sum(res == 1, 1)/size(res,1);
col = acc(1,range)';
data(:,5) = col;


%% load ranking using BSD w/o turns
params.features_type = 'BSD'; % 'BSD' 'ES' or 'none'
params.turns = 'false'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

BSDresults_filename = fullfile('sub_results/BSD',dataset,params.top,params.turns,['ranking_',num2str(params.BSDacc),'.mat']);
load(BSDresults_filename, 'res');

acc = sum(res == 1, 1)/size(res,1);
col = acc(1,range)';
data(:,2) = col;


%% load ranking BSD + turn
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'true'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'

BSDresults_filename = fullfile('sub_results/BSD',dataset,params.top,params.turns,['ranking','_',num2str(params.BSDacc),'.mat']);
load(BSDresults_filename, 'res');

acc = sum(res == 1, 1)/size(res,1);
col = acc(1,range)';
data(:,3) = col;
data = 100 * data;

%% Make plot
b = bar(range, data, 'FaceColor','flat','EdgeColor',[1 1 1]);


b(1).FaceColor = [0.75 0.75 0.75];
b(2).FaceColor  = [0.9290 0.6940 0.1250];
b(3).FaceColor  = [0.8500 0.3250 0.0980];
b(4).FaceColor  = [0 0.4470 0.7410];
b(5).FaceColor  = [0 0 1];


% cmap = colormap(jet);
% for k = 1:5
%     b(k).FaceColor = cmap(10*k,:);
% end

xlabel('Route length', 'FontName', 'Times','FontSize', 10)
ylabel('Top-1 Localisations (%)', 'FontName', 'Times', 'FontSize', 10)
grid on 
title('Union Square');

ax = gca;
set(ax,'Ytick',0:10:100)
ylim([0,100]);
basic_plot_configuration;
fig.PaperPosition = [0 0 8 6];
legend({'Turns', 'BSD', 'BSD+T', 'ES', 'ES+T'}, 'FontName', 'Times', 'Location', 'northwest','FontSize', 7)
filename = fullfile('results_for_eccv', 'charts_overlap', ['bars_',params.top]);
% filename = fullfile('results_for_bsd', ['bars_',params.top]);
saveas(ax, filename,'epsc')


