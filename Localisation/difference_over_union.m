% statistic results v3
clear all
close all

top_k = 1;
route_length = 40;
datasets = {'luton_v4', 'london_10_19'}; 
test_num = 500;
score = zeros(length(datasets),route_length);
union_accuracy = zeros(length(datasets),route_length);

for dataset_index=1:length(datasets)
    dataset = datasets{dataset_index};
    % load BSD results
    load(['Data/',dataset,'/','results/','BSDtruefalse_80.mat']);
    ranking_bsd = ranking;
    best_estimated_routes_bsd = best_estimated_routes;
    
    % load ES results
    load(['Data/',dataset,'/','results/','EStruefalse.mat']);
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
        difference_set = setdiff(ES,BSD,'rows'); 
        %union_accuracy(dataset_index, m) = size(union_set, 1)/test_num;
        score(dataset_index,m) = size(difference_set,1) / size(ES,1);%size(union_set, 1);    
        a=score;
    end
end
plot(score')
hold on
%plot(union_accuracy')
grid on
legend(datasets)