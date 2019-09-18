% gsv download and cropped to snapshots
clear all
close all

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load('Data/routes_small.mat');
outfolder = 'Data/london_panos';
outfolder_s = 'Data/london_snaps';

if ~exist(outfolder,'dir')
    mkdir(outfolder)
end

if ~exist(outfolder_s,'dir')
    mkdir(outfolder_s)
end

% download panoramas
zoom = 1;
parfor_progress('panoramas',length(routes));
for i=1:length(routes)
    panoid = routes(i).id;
    panorama_download(panoid, zoom, outfolder);
    parfor_progress('panoramas');
end

% crop panoramas to snapshots in 4 directions
panoDir = 'Data/london_panos/';
files = dir('Data/london_panos/*.jpg');
files = {files.name}'; 
cropped_size = 227;
fov = 100;
fov = pi * fov / 180;
T = struct2table(routes);
ID = T.id;
crop_panorama(cropped_size, fov, panoDir, files, ID, routes, outfolder_s);


