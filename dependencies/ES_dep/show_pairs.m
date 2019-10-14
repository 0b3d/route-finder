clc
clear all;
close all;
parameters;
dataset = 'toronto_v1';
n = 10;

%Read the features
load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);

for i=1:n
    idx = randi(size(routes,2), 1);
    pano_id = routes(idx).id;
    xpath = ['images/',dataset,'/tiles/z19/',num2str(idx),'.png'];
    ypath = ['images/',dataset,'/panos/',pano_id,'.jpg'];
    tile = imread(xpath);
    [front, left, right, back] = crop_pano(256, 90,pano_id, dataset);
    image = [tile, front, left, right, back];
    imshow(image)
    pause
end