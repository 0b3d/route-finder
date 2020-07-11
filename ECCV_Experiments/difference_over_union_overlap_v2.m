% statistic results v3
clear all
close all

model = 'v2_12';
zoom = 'z18';
route_length = 40;
datasets = {'unionsquare5k'}; 
test_num = 500;
score = zeros(length(datasets),route_length);
union_accuracy = zeros(length(datasets),route_length);

params.turns = 'false';
params.probs = 'false';
params.top = 'top1';
networks = {'resnet18'};

for dataset_index=1:length(datasets)
    for a = 1:length(networks)
        network = networks{a};
        dataset = datasets{dataset_index};
        % load BSD results
        bsd_results_file = fullfile('sub_results/BSD',dataset,params.top,params.turns,['ranking_', network, '.mat']);
        load(bsd_results_file, 'res');
        ranking_bsd = res;
        bsd_results_file = fullfile('sub_results/BSD',dataset,params.top,params.turns,['best_estimated_routes_', network, '.mat']);
        load(bsd_results_file, 'best_estimated_routes');
        best_estimated_routes_bsd = best_estimated_routes;

        % load ES results
        params.features_type = 'ES';
        es_results_file = fullfile('sub_results_v2_12/ES',dataset,params.top,params.turns,'ranking.mat');
        load(es_results_file, 'res');
        es_results_file = fullfile('sub_results_v2_12/ES',dataset,params.top,params.turns,'best_estimated_routes.mat');
        %es_results_file =  fullfile('sub_results_v2_12/ES', model, zoom, dataset,['ES',params.turns,params.probs,'.mat']);
        load(es_results_file, 'best_estimated_routes');
    
        ranking_es = res;
        best_estimated_routes_es = best_estimated_routes;

        for m = 1:route_length
            correct_estimated_routes_bsd = sum(ranking_bsd(:,m) == 1);
            correct_estimated_routes_es = sum(ranking_es(:,m) == 1);

            BSD = zeros(correct_estimated_routes_bsd,m);
            ES = zeros(correct_estimated_routes_es,m);

            BSD_indices = find(ranking_bsd(:,m) == 1);
            ES_indices = find(ranking_es(:,m) == 1);

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
            union_set = union(ES, BSD, 'rows');
            %intersect_set = intersect(ES, BSD, 'rows');
            difference_set = setdiff(ES, BSD, 'rows'); 
            % union_accuracy(dataset_index, m) = size(union_set, 1)/test_num;
            score1(dataset_index,m) = size(difference_set,1) / size(ES,1);%size(union_set,1); 
            difference_set = setdiff(BSD, ES, 'rows');
            score2(dataset_index,m) = size(difference_set,1) / size(BSD,1);%size(union_set,1);
        end
        plot(score1', 'LineStyle','-', 'LineWidth',1)
        hold on
        plot(score2', 'LineStyle','-', 'LineWidth',1)
        
    end
end

ax = gca;
% plot(union_accuracy')
xlabel(ax,'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax,'S_d', 'FontName', 'Times', 'FontSize', 10)
ylim([0, 1]);
set(ax,'Ytick',0:0.2:1)
grid on
%title('Union Square');

%legend_text= {'$|S_{ES}\S_{BSD}|/|SES|$','|SBSD\SE|\|SBSD|'}; 

h=legend('$S_d(ES,BSD)$','$S_d(BSD,ES)$');
set(h,'Interpreter','latex')

fig = gcf;
basic_plot_configuration;
fig.PaperPosition = [0 0 8 6];
%legend(legend_text,'FontName', 'Times', 'FontSize', 7, 'location', 'northeast')
filename = fullfile('results_for_eccv', 'charts_16d', ['difference_over_union_',params.turns,'_',params.top,'_',dataset]);
saveas(ax, filename,'epsc')
