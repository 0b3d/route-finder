clear all
close all

params.feature_type = 'BSD';
params.turns = 'true';
params.probs = 'false';

dataset = 'wallstreet5k';
city = 'manhattan';

% load routes
load(['Localisation/test_routes/',dataset,'_routes_500_60','.mat']);
index = 120;
t = test_route(index,1:20);

% load features
load(['features/',params.feature_type,'/',dataset,'/',params.feature_type,'_', city,'_',dataset,'_v3','.mat'],'routes');

% load results
load(['results/BSD/',dataset,'/',params.feature_type,params.turns,params.probs,'_v3','.mat'],'dist');

dist_t = dist{1,index};
truth_dist = 0;
N = zeros(size(t,2),2);
xtips = [];
ytips1 = [];
for i=1:size(t,2)
    BSD = routes(t(i)).BSDs;
    CNN = routes(t(i)).CNNs;
    truth_dist = truth_dist + size(find(BSD~=CNN), 2);
    estimated_dist = dist_t{1,i};
    k = find(estimated_dist <= truth_dist);
    N(i,1) = size(k,1);
    xtips = [xtips;i];
    ytips1 = [ytips1;N(i,1)];   
end

% load features
load(['features/',params.feature_type,'/',dataset,'/',params.feature_type,'_', city,'_',dataset,'.mat'],'routes');

% load results
load(['results/BSD/',dataset,'/',params.feature_type,params.turns,params.probs,'.mat'],'dist');
dist_t = dist{1,index};
truth_dist = 0;
ytips2 = [];
for i=1:size(t,2)
    BSD = routes(t(i)).BSDs;
    CNN = routes(t(i)).CNNs;
    truth_dist = truth_dist + size(find(BSD~=CNN), 2);
    estimated_dist = dist_t{1,i};
    k = find(estimated_dist <= truth_dist);
    N(i,2) = size(k,1);
    ytips2 = [ytips2;N(i,2)];
    
end

ax = gca;
bar(xtips,N);
labels1 = string(N(:,1));
text(xtips-0.25*ones(20,1),ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
labels2 = string(N(:,2));
text(xtips+0.25*ones(20,1),ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend({'Simulated Classifier', 'Real Classifier'})
xlabel('route length')
ylabel('number of routes')
title('Number of routes smaller than ground truth (route length=20)')
filename = fullfile('results_for_bsd', [num2str(index),'_','smaller_and_equal']);
saveas(ax, filename,'png')






