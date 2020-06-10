clear all
close all 
clc
addpath(genpath(pwd));
parameters; % load the parameters 

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
connectivity_correction;
assign_lables;

simulate_cnn;    % simulated CNN

save_lable_csv;  % true CNN
load_features; 
load_features_v2;


% Generate test routes and save then in Localization/test_routes/<dataset>.mat
generate_random_routes;
generate_turns;

% Localisation
localisation;
% localisation_v2; % bootstrapping (need to be imporved further )
% localisation_ds; % dense map sampling localisation (need to be implemented further)

% Statistic Results
statistic_results;

