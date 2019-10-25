% statistic results v4
clear all
close all

route_length = 5;
datasets = {'luton_v4', 'london_10_19'}; 
test_num = 500;
score = zeros(length(datasets), route_length);


for dset_idx = 1:length(datasets) %For all dataset to test
    dataset = datasets{dset_idx};
    
    % load BSD results
    load(['Data/',dataset,'/','results/','BSDtruefalse_100.mat']);
    ranking_bsd = ranking;
    best_estimated_routes_bsd = best_estimated_routes;
    correct_estimated_routes_bsd = {sum(ranking_bsd(:,route_length) == 1)};

    % load ES results
    load(['Data/',dataset,'/','results/','EStruefalse.mat']);
    ranking_es = ranking;
    best_estimated_routes_es = best_estimated_routes;
    correct_estimated_routes_es = {sum(ranking_es(:,route_length) == 1)};

    for m=1:route_length % To test for all route length and plot result
        % find the index of the routes correctly identified by bsd and es
        % respectively
        bsd_route_indices_set = find( ranking_bsd(:,m) == 1);
        es_route_indices_set = find( ranking_es(:,m) == 1);

        % compute score = {BSD intersect ES} / {BSD union ES}
        union_set = union(bsd_route_indices_set, es_route_indices_set);
        intersect_set = intersect(bsd_route_indices_set, es_route_indices_set);
        score(dset_idx,m) = length(intersect_set) / length(union_set);
    end
end
plot(score')
grid on
legend(datasets)
