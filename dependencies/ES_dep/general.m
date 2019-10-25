clc
close all;
clear all;
addpath(genpath(pwd));

datasets = {'edinburgh_10_19','london_10_19','newyork_10_19','oxford_10_19','paris_10_19','rome_v1','toronto_v1','washington_10_19', 'tonbridge_v2', 'luton_v4'};
%datasets = {'tonbridge_v2','luton_v4'};
cases = {{'true','false'}}; %'true', 'false'}, {'false', 'false'}}; %turns, probs
results = zeros(length(datasets) * length(cases), 8);

features_type = 'ES'; % 'BSD' 'ES' or 'none'
max_route_length_init = 40; % the lenght of the routes
threshold = 60; % turn threshold
road_dense_distance = 10;
% consistency metric
overlap = 0.8; % 80%
s_number = 5; % 5 successive locations
N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];

% choose features type
rng(441) %For reproducibility
        
for dset =1:length(datasets)
   dataset = datasets{dset};
   
   if strcmp(dataset, 'oxford_10_19')
       test_num = 100;
   else
       test_num = 500;
   end
   
    for c=1:length(cases)
        cs = cases{c};
        turns = cs{1};
        probs = cs{2};
        sprintf('%s', dataset, ' turns ', turns, ' probs ', probs)
        disp('generating data ...')
        data_generation_ES; % generate data struct
        localisation_ES;
        idx = c + (dset-1)*c;
        results(idx, : ) = accuracy_with_different_length(1,:) ;
    end
end

save(['features/','general','_',option,'.mat'],  '-v7.3')