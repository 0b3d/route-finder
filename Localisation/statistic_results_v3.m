% statistic results v3
clear all
close all

route_length = 5;
dataset = 'luton_v4'; 
test_num = 500;

% load BSD results
load(['Data/',dataset,'/','results/','BSDtruefalse_100.mat']);
ranking_bsd = ranking;
best_estimated_routes_bsd = best_estimated_routes;
correct_estimated_routes_bsd = {sum(ranking_bsd(:,route_length) == 1)};

% load ES results
load(['Data/',dataset,'/','results/','EStruetrue.mat']);
ranking_es = ranking;
best_estimated_routes_es = best_estimated_routes;
correct_estimated_routes_es = {sum(ranking_es(:,route_length) == 1)};
num_bsd = 1;
num_es = 1;
for i=1:test_num
    if ranking_bsd(i, route_length) == 1
        current_route = best_estimated_routes_bsd{1,i}{1,route_length};
        correct_estimated_routes_bsd(num_bsd) = current_route; 
        num_bsd = num_bsd + 1;
    end
    
    if ranking_es(i, route_length) == 1
        current_route = best_estimated_routes_es{1,i}{1,route_length};
        correct_estimated_routes_es(num_es) = current_route; 
        num_es = num_es + 1;
    end    
end

equal_route_num = 1;
for i=1:length(correct_estimated_routes_bsd)
    current_route_bsd = correct_estimated_routes_bsd{1,i}{1,route_length};
    for j=1:length(correct_estimated_routes_es)
        current_route_es = correct_estimated_routes_es{1,i}{1,route_length};
        if isequal(current_route_bsd, current_route_es)
            equal_route_num = equal_route_num + 1;
        end
    end
end

