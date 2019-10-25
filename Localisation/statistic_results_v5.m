% statistic results v3
clear all
close all

route_length = 20;
dataset = 'luton_v4'; 
test_num = 500;

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
num_bsd = 1;
num_es = 1;
for i=1:test_num
    if ranking_bsd(i, route_length) == 1
        current_route = best_estimated_routes_bsd{1,i}{1,route_length};
        correct_estimated_routes_bsd{num_bsd} = current_route; 
        num_bsd = num_bsd + 1;
    end
    
    if ranking_es(i, route_length) == 1
        current_route = best_estimated_routes_es{1,i}{1,route_length};
        correct_estimated_routes_es{num_es} = current_route; 
        num_es = num_es + 1;
    end    
end

% equal_route_num = 1;
% for i=1:length(correct_estimated_routes_bsd)
%     current_route_bsd = correct_estimated_routes_bsd{1,i}(1,route_length);
%     for j=1:length(correct_estimated_routes_es)
%         current_route_es = correct_estimated_routes_es{1,i}(1,route_length);
%         if isequal(current_route_bsd, current_route_es)
%             equal_route_num = equal_route_num + 1;
%         end
%     end
% end

equal_route_num = 1;
counter=1;
for i=1:length(correct_estimated_routes_bsd)
    current_route_bsd = correct_estimated_routes_bsd{1,i}(1,route_length);
    bsd_res_set(1,i) = current_route_bsd;
    for j=1:length(correct_estimated_routes_es)
        current_route_es = correct_estimated_routes_es{1,j}(1,route_length);
        es_res_set(1,counter) = current_route_es;
        counter = counter + 1; 
        if isequal(current_route_bsd, current_route_es)
            intersect_set2(1,equal_route_num) = current_route_bsd;
            equal_route_num = equal_route_num + 1;
        end
    end
end

% first approach
es_res_set = unique(es_res_set);
bsd_res_set = unique(bsd_res_set);
union_set = union(es_res_set, bsd_res_set);
intersect_set = intersect(es_res_set, bsd_res_set);
score =  length(intersect_set) / length(union_set)

% second approach
intersect_set2 = unique(intersect_set2);
score2 = length(intersect_set2) / length(union_set)


