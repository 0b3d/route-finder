clear all;
clc;

%% create parameters object
params = BSDParams;                   % define parameters for ES

% if need override default parameters here
params.dataset = 'wallstreet5k';
params.name = 'brute_force';         % a name for the experiment
params.save = 1;                     % overwrite default parameters if needed
params.T = 500; 
params.turns = false;

% show parameters and store them in a text file inside experiment directory
params = params.init();

%% Create a localiser object
localiser = BSDLocaliser(params);      % construct a ESLocaliser object with given params
% localiser.data_generation();          % generate routes struct

%% Localise and store results in ranking.
% Ranking is a matrix with size [T,mrl], it contains the rank of the gt route as a function of route length
% only routes where rank <= params.topk are reported, zero means the gt route is outside parmas.topk

[ranking, topk_estimated_routes] = localiser.localise();       % start localisation process


