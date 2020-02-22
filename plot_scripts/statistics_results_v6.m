% statistic results v3
clear all
close all

top_k = 1;
route_length = 40;
datasets = {'unionsquare5k'}; 
test_num = 500;
score = zeros(length(datasets),route_length);

model = 'v1'
zoom = 'z18'
params.turns = 'true'
params.probs = 'false'
params.BSDacc = '100'

for dataset_index=1:length(datasets)
    dataset = datasets{dataset_index};
    % load BSD results
    BSDresults_filename = fullfile('sub_results/BSD',dataset,params.turns,['ranking_',params.BSDacc, '.mat'])
    load(BSDresults_filename, 'ranking');
    ranking_bsd = ranking;
    BSDresults_filename = fullfile('sub_results/BSD',dataset,params.turns,['best_estimated_routes_',params.BSDacc, '.mat'])
    load(BSDresults_filename, 'best_estimated_routes');
    best_estimated_routes_bsd = best_estimated_routes;
    
    % load ES results
    ESresults_filename =  fullfile('results/ES', model, zoom, dataset,['ES',params.turns,params.probs,'.mat']);
    load(ESresults_filename, 'ranking', 'best_estimated_routes');
    ranking_es = ranking;
    best_estimated_routes_es = best_estimated_routes;
        
    for m = 1:route_length
        correct_estimated_routes_bsd = sum(ranking_bsd(:,m) <= top_k);
        correct_estimated_routes_es = sum(ranking_es(:,m) <= top_k);
        num_bsd = 1;
        num_es = 1;

        BSD = zeros(correct_estimated_routes_bsd,m);
        ES = zeros(correct_estimated_routes_es,m);

        BSD_indices = find(ranking_bsd(:,m) <= top_k);
        ES_indices = find(ranking_es(:,m) <= top_k);

        for i =1:length(BSD_indices)
            idx = BSD_indices(i);
            current_route = best_estimated_routes_bsd{1,idx}{1,m};
            BSD(i,:) = current_route; 
        end
        for i =1:length(ES_indices)
            idx = ES_indices(i);
            current_route = best_estimated_routes_es{1,idx}{1,m};
            ES(i,:) = current_route; 
        end

        union_set = union(BSD, ES, 'rows');
        intersect_set = intersect(BSD, ES, 'rows');
        score(dataset_index,m) = size(intersect_set,1) / size(union_set, 1);
    end
end
plot(score')
grid on
legend(datasets)