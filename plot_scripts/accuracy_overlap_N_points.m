clear all
close all

params.features_type = 'ES';
params.datasets = {'unionsquare5k', 'wallstreet5k'};

params.zoom = 'z18';
params.model = 'v1';
turns = {'false'};
params.probs = 'false';
params.threshold_ = 60;
ks = [1,5];
N = 5;

for t=1:length(turns)
    params.turns = turns{t};
    for d=1:length(params.datasets)
        params.dataset = params.datasets{d};
        fileName = fullfile('Localisation/test_routes/',[params.dataset,'_routes_500_',num2str(params.threshold_),'.mat']);
        load(fileName);

        for j=1:size(ks,2)
            %% Load the routes file
            k = ks(1,j);

            %% Load best estimated routes
            option = [params.features_type, params.turns, params.probs];

            if strcmp(params.features_type, 'ES')
                fileName = fullfile('results/ES', params.model, params.zoom, params.dataset,[params.features_type,params.turns,params.probs,'.mat']);
            else
                option = [params.features_type, params.turns ,params.probs]; 
                accuracy = 0.75;
                fileName = fullfile(['results/BSD/',params.dataset,'/',option,'.mat']); 
            end
            load(fileName, 'best_estimated_top5_routes');

            %% Compute accuracy checking if last N points match gt
            res = zeros(500, 40);
            for r=1:500
                for m=N:40
                    best_estimated_routes = best_estimated_top5_routes{1,r}{1,m}; %size is (5,m)
                    k = min(size(best_estimated_routes,1), k);
                    %best_estimated_route = best_estimated_routes(1:k,:); 
                    lidx = m - N + 1;
                    uidx = m;
                    gt_route = test_route(r,lidx:uidx); % [1,N]
                    estimated = best_estimated_routes(1:k,lidx:uidx); %[k,N]
                    res(r,m) = any(ismember(estimated,gt_route,'rows'));
                end
            end

            acc = sum(res, 1)/500;
            plot(100*acc)
            hold on
        end
    end
end
grid on
ax = gca;
fig = gcf;
xlabel(ax, 'Route length', 'FontName', 'Times', 'FontSize', 10)
ylabel(ax, 'Correct localisations (%)', 'FontName', 'Times', 'FontSize', 10)
basic_plot_configuration;
legend_text = {'Union Square Top 1', 'Union Square Top 5', 'Wallstreet Top 1', 'Wallstreet Top 5'};

legend(legend_text, 'Location', 'southeast')
filename = fullfile('results_for_eccv/charts/ESvsBSD_top1_top5_overlap', ['top1_top5_overlap_N',num2str(N),params.features_type,params.turns]);
saveas(ax, filename, 'png')
legend(ax, legend_text,'FontName', 'Times', 'Location', 'southeast','FontSize', 6)
fig.PaperPosition = [0 0 8 6];
saveas(ax, filename,'epsc')