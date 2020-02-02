clc
clear all
close all 

datasets = {'edinburgh_10_19','london_10_19','luton_v4','newyork_10_19', 'paris_10_19', 'rome_v1', ...
            'tonbridge_v2', 'toronto_v1', 'washington_10_19','oxford_10_19'};

for dset_index=1:length(datasets)
    dataset = datasets{dset_index}
    % load routes file 
    routes_file = ['Data/',dataset,'/routes_small.mat'];
    load(routes_file);
    nodes = length(routes)
    
    coords = zeros(nodes,2);
    for i=1:nodes 
        coords(i,:) = routes(i).gsv_coords;
    end
    
    limits = [min(coords(:,1)) min(coords(:,2)) max(coords(:,1)) max(coords(:,2))]
    lat_min = limits(1);
    lon_min = limits(2);
    lat_max = limits(3);
    lon_max = limits(4);
    
    lat_d1 = distance(lat_min, lon_min, lat_max, lon_min);
    lat_d2 = distance(lat_min, lon_max, lat_max, lon_max);
    lon_d1 = distance(lat_min, lon_min, lat_min, lon_max);
    lon_d2 = distance(lat_max, lon_min, lat_max, lon_max);
      
    lat_distance = (deg2km(lat_d1) + deg2km(lat_d2))/2;
    lon_distance = (deg2km(lon_d1) + deg2km(lon_d2))/2;
    area = lat_distance * lon_distance

end