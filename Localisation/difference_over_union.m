% statistic results v3
clear all
close all

model = 's2v700k_v1';
top_k = 1;
route_length = 40;
datasets = {'luton_v4'}; 
test_num = 500;
score = zeros(length(datasets),route_length);
union_accuracy = zeros(length(datasets),route_length);

params.turns = 'false';
params.probs = 'false';
accuracies = {'75','80','90','100'};

for dataset_index=1:length(datasets)
    for a = 1:length(accuracies)
        acc = accuracies{a};
        dataset = datasets{dataset_index};
        % load BSD results
        bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/BSD', params.turns, params.probs, '_', acc,'.mat'];
        load(bsd_results_file, 'ranking');
        ranking_bsd = ranking;
        bsd_results_file = ['ES_results/BSD/results/',dataset,'/results/best_estimated_route_', acc,'.mat'];
        load(bsd_results_file, 'best_estimated_routes');
        best_estimated_routes_bsd = best_estimated_routes;

        % load ES results
        params.features_type = 'ES'
        results_filename = ['ES_results/',model,'/',dataset,'_',params.features_type,params.turns,params.probs,'.mat'];
        load(results_filename, 'accuracy_with_different_length', 'ranking','best_estimated_routes');
        ranking_es = ranking;
        best_estimated_routes_es = best_estimated_routes;

        for m = 1:route_length
            correct_estimated_routes_bsd = sum(ranking_bsd(:,m) <= top_k);
            correct_estimated_routes_es = sum(ranking_es(:,m) <= top_k);

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
        end
        plot(score', 'LineStyle','-', 'LineWidth',1.5)
        hold on
    end
end

%plot(union_accuracy')
xlabel('Route length', 'FontName', 'Times', 'FontSize', 12)
ylabel('S_{diff}', 'FontName', 'Times', 'FontSize', 12)
grid on

legend_text= {'BSD 75%','BSD 80%','BSD 90%','BSD 100%'}; 
legend(legend_text,'FontName', 'Times', 'FontSize', 10)