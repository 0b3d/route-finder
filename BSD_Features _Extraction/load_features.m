% correlate each image with features
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

% load features
load('models/resnet18_v3/ws_junctions_features.mat','features')
jc_features = features';
load('models/resnet18_v3/ws_gaps_features.mat','features')
bd_features = features';
clear features

% load image paths
load('models/resnet18_v3/ws_junctions_ids_labels.mat','panoids')
jc_panoid = panoids;
load('models/resnet18_v3/ws_gaps_ids_labels.mat','panoids')
bd_panoid = panoids;
clear panoids

% load image path for junctions
jc_outfolder = ['images/JUNCTIONS/',dataset,'/','junctions'];
jc_outfolder_n = ['images/JUNCTIONS/',dataset,'/','non_junctions'];
files = dir([jc_outfolder '/*.jpg']);
files = {files.name}';
files_n = dir([jc_outfolder_n '/*.jpg']);
files_n = {files_n.name}';
jc_img = {length(files)+length(files_n)};
for i=1:(length(files)+length(files_n))
    if i <= length(files)
        jc_img{i} = files{i};
    else
        jc_img{i} = files_n{i-length(files)};
    end
    disp(jc_img{i});
    disp(jc_panoid(i,:));
end

% load image path for gaps
bd_outfolder = ['images/GAPS/',dataset,'/','gaps'];
bd_outfolder_n = ['images/GAPS/',dataset,'/','non_gaps'];
files = dir([bd_outfolder '/*.jpg']);
files = {files.name}';
files_n = dir([bd_outfolder_n '/*.jpg']);
files_n = {files_n.name}';
bd_img = {length(files)+length(files_n)};
for i=1:(length(files)+length(files_n))
    if i <= length(files)
        bd_img{i} = files{i};
    else
        bd_img{i} = files_n{i-length(files)};
    end
    disp(bd_img{i});
    disp(bd_panoid(i,:));
end

% correlate features
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
for i=1:length(routes)
    id = routes(i).id;
    id_f = [id,'_front.jpg'];
    id_b = [id,'_back.jpg'];
    id_l = [id,'_left.jpg'];
    id_r = [id,'_right.jpg'];
    idx_f = find(ismember(jc_img, id_f));
    idx_b = find(ismember(jc_img, id_b));
    idx_l = find(ismember(bd_img, id_l));
    idx_r = find(ismember(bd_img, id_r));
    bad(1) = jc_features(idx_f);
    bad(3) = jc_features(idx_b);
    bad(4) = bd_features(idx_l);
    bad(2) = bd_features(idx_r);
    bad_o = bad;
    bad(bad == 1) = 2;
    bad(bad == 0) = 1;
    bad(bad == 2) = 0;
    routes(i).CNNs = bad;    
end
save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',network,'.mat'],'routes');







