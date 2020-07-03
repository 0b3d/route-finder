clc;
clear all;

city= 'manhattan';
dataset = 'hudsonriver5k';
features_type = 'ES';
zoom = 'z19';
model = 'v2_2';

filename = fullfile('features', features_type, model,  zoom, ['ES_',dataset,'.mat']);
load(filename)


m = 0;
for i=1:5000
   neighbors = routes(i).neighbor;
   s = size(neighbors,1);
   if s > m
       m = s;
   end
end

neighbors = NaN(5000,m); %#-1 * ones(5000,3);
for i=1:5000
   neighbors_ = routes(i).neighbor;
   s = size(neighbors_,1);
   if neighbors_ ~= 0
    for j=1:s
       neighbors(i,j) = neighbors_(j);       
    end
   end
end

filename = fullfile('features', features_type, model,  zoom, [dataset,'_neighbors.mat']);
save(filename)

