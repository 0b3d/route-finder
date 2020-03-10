% pick a test route for visualization
clear all
close all

% choose features type
params.turns = 'true'; % 'true', 'false', 'only'
params.top = 'top1'; % 'true', 'false', 'only'

dataset = 'wallstreet5k';
test_num = 500;
length_diff = 1;

% load ES data
ESresults_filename =  fullfile('sub_results/ES',dataset,params.top,params.turns,'ranking.mat');
load(ESresults_filename, 'res');
ES_ranking = res;
ES_rlength = zeros(test_num,1);
for i = 1:test_num
    [~,col] = find(res(i,:),1,'first');    
    if isempty(col)
        col = 41;
    end
    ES_rlength(i) = col;
end

% load BSD data
accuracy = '75';
BSDresults_filename = fullfile('sub_results/BSD',dataset,params.top,params.turns,['ranking_',accuracy, '.mat']);
load(BSDresults_filename, 'res');
BSD_ranking = res;
BSD_rlength = zeros(test_num,1);
for i = 1:test_num
    [~,col] = find(res(i,:),1,'first'); 
    if isempty(col)
        col = 41;
    end
    BSD_rlength(i) = col;
end

% pick routes
final_routes = [];
for i=1:test_num
    diff = BSD_rlength(i) - ES_rlength(i);
    if diff >= length_diff
        final_routes = [final_routes;i,ES_rlength(i),BSD_rlength(i),diff]; 
    end
end
save(['sub_results/','final_routes','_',dataset,'_',params.turns,'.mat'],'final_routes');
