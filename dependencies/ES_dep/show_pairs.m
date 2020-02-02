clc
clear all;
close all;
parameters;
dataset = 'london_10_19';
n = 10;

%Read the features
load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);

for i=1:n
    idx = randi(size(routes,2), 1);
    pano_id = routes(idx).id;
    xpath19 = ['images/',dataset,'/tiles/z19/',num2str(idx),'.png'];
    xpath20 = ['images/',dataset,'/tiles/z20/',num2str(idx),'.png'];
    ypath = ['images/',dataset,'/panos/',pano_id,'.jpg'];
    tile19 = imread(xpath19);
    tile20 = imread(xpath20);
    [front, left, right, back] = crop_pano(256, 90,pano_id, dataset);
    image = [tile19, tile20, front, left, right, back];
    imshow(image)
    prompt = 'Save image? Y/N [Y]: ';
    str = input(prompt,'s');
    if isempty(str)
        str = 'N';
    end
    if str == 'Y'
        name = ['ES_Results/',dataset,'_',num2str(idx),'.jpg'];
        imwrite(image, name)
    end
end