%% Load parameters
clc
clear all
close all

params.test_num = 500;
params.max_route_length_init = 40; % the lenght of the routes
params.threshold = 60; % turn threshold
params.road_dense_distance = 10;
% drop threshold for routes
params.N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
    100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
% consistency metric
params.overlap = 0.8; % 80%
params.s_number = 5; % 5 successive locations

% parameters for BSD freatures
params.radius = 35; % search radius is 35m
params.thresh = 10; % filter inters if their angles is below 10 degree
params.accuracy = 1;
params.range = 2; % generate rays every _degree
params.thresh_jc = 30; % 30m
params.thresh_bd = 3;  % 4 degree

% choose features type
params.features_type = 'ES'; % 'BSD' 'ES' or 'none'
params.turns = 'only'; % 'true', 'false', 'only'
params.probs = 'false'; % for 'BSD', set this to 'false'
%option = {features_type,turns, probs};

models = {'s2v700k_v1'}
datasets = {'newyork_10_19'}
%datasets = {'edinburgh_10_19', 'london_10_19', 'luton_v4', 'newyork_10_19', 'toronto_v1'}

for model_index = 1:length(models)
    model = models{model_index};
    for dataset_index=1:length(datasets)
        dataset = datasets{dataset_index};
        localisation_ES(model, dataset, params);
    end
end