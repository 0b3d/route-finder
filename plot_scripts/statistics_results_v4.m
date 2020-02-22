% statistic results v4
clear all
close all

route_length = 40;
top_k = 1;
datasets = {'luton_v4', 'london_10_19'}; 
test_num = 500;
score = zeros(length(datasets), route_length);


for dset_idx = 1:length(datasets) %For all dataset to test
    dataset = datasets{dset_idx};
    
    % load BSD results
    load(['Data/',dataset,'/','results/','BSDtruefalse_70.mat']);
    ranking_bsd = ranking;

    % load ES results
    load(['Data/',dataset,'/','results/','EStruefalse.mat']);
    ranking_es = ranking;

    for m=1:route_length % To test for all route length and plot result
        % find the index of the routes correctly identified by bsd and es
        % respectively
        bsd_route_indices_set = find( ranking_bsd(:,m) <= top_k);
        es_route_indices_set = find( ranking_es(:,m) <= top_k);

        % compute score = {BSD intersect ES} / {BSD union ES}
        union_set = union(bsd_route_indices_set, es_route_indices_set);
        intersect_set = intersect(bsd_route_indices_set, es_route_indices_set);
        score(dset_idx,m) = length(intersect_set) / length(union_set);
    end
end
plot(score')
grid on
legend(datasets)
