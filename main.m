clear all
close all 
clc
addpath(genpath(pwd));
parameters; %load the parameters 

%% Map parsing and gsv download
% To parse all map information, and generate route dataset just call the
% next script, otherwise comment line
map_processing;

% To create a csv file with all the nodes information (needed for gsv download)
% The file will be in Data/<dataset>/routes.csv
% save_csv;

% Download all pano_ids saved in routes.csv and save them in panos
% Data/<dataset>/panos directory
% parameters;
% filepath = fullfile(pwd, 'dependencies', 'gsv_python', 'download_panos.py');
% command = ['python', ' ', filepath, ' ', dataset];
% system(command);

%% Localization 
% For the next steps we assume the predictions file is present in Data/features directory. 
% This file must be named after the dataset (for example
% london_center_09_19)

% Prepare the struct file with all required information. This creates
% final_routes.mat with all information for localization process.
% data_generation;

feature_generating;
assign_lables;
simulate_cnn;    % simulated CNN
% load_features; % true CNN



% Generate test routes and save then in Localization/test_routes/<dataset>.mat
generate_random_routes;

% Localization
localisation;

% Results
statistic_results_v2;

