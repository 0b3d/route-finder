clear all
close all

params.features_type = 'ES';
params.datasets = {'hudsonriver5k','wallstreet5k','unionsquare5k'};

params.zoom = 'z19';
params.model = 'v2_2';
turns = {'true','false'};
params.probs = 'false';
params.threshold_ = 60;
ks = [1,5];
rs = [5, 10, 15, 20, 25, 30, 35, 40]; % different route length
N = 5;

for t=1:length(turns)
    params.turns = turns{t};
    option = [params.features_type, params.turns, params.probs];
    for d=1:length(params.datasets)
        params.dataset = params.datasets{d};
        fileName = fullfile('Localisation/test_routes/',[params.dataset,'_routes_500_',num2str(params.threshold_),'.mat']);
        load(fileName);
        accuracy_new = zeros(1, size(rs,2));

        for j=1:size(ks,2)
            %% Load the routes file
            topk = ks(1,j);

            %% Load best estimated routes
            if strcmp(params.features_type, 'ES')
                fileName = fullfile('results/ES', params.model, params.zoom, params.dataset,[option,'.mat']);
                outName_1 = ['ranking','.mat'];
                outName_2 = ['best_estimated_routes.mat'];
            else
                if strcmp(params.turns,'only')
                    fileName = fullfile(['results/BSD/',params.dataset,'/',option,'.mat']); 
                    outName_1 = ['ranking','.mat'];
                    outName_2 = ['best_estimated_routes','.mat'];
                else
                    network = 'combined3';
                    fileName = fullfile(['results/BSD/',params.dataset,'/',option,'_', network,'.mat']); 
                    outName_1 = ['ranking_',network,'.mat'];
                    outName_2 = ['best_estimated_routes_', network,'.mat'];
                end
            end
            load(fileName, 'best_estimated_top5_routes');
            load (fileName, 'best_estimated_routes');
            
            sub_resultsPath = ['sub_results/', params.features_type,'/',params.dataset,'/','top',num2str(topk),'/',params.turns];
            save([sub_resultsPath,'/',outName_2],  'best_estimated_routes');

            %% Compute accuracy checking if last N points match gt
            res = zeros(500, 40);
            for r=1:500
                for m=N:40
                    best_estimated_routes = best_estimated_top5_routes{1,r}{1,m}; %size is (5,m)
                    k = min(size(best_estimated_routes,1), topk);
                    % best_estimated_route = best_estimated_routes(1:k,:); 
                    lidx = m - N + 1;
                    uidx = m;
                    gt_route = test_route(r,lidx:uidx); % [1,N]
                    estimated = best_estimated_routes(1:k,lidx:uidx); %[k,N]
                    res(r,m) = any(ismember(estimated,gt_route,'rows'));
                end
            end

            if ~exist(sub_resultsPath,'dir')
                mkdir(sub_resultsPath);
            end
            save([sub_resultsPath,'/',outName_1],  'res');
        end
    end
end