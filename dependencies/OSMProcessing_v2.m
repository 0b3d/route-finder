function [inters, buildings, roads] = OSMProcessing_v2()
%% Parse intersection, roads and building info from OSM map     
% system('python /Users/zhoumengjie/Desktop/route-finder/dependencies/map_parsing/parse_script.py');
addpath(genpath('map_parsing'));
system('python map_parsing/parse_script.py');

% Read intersection and node coordinates previously extracted from map.osm
intersections = csvread('intersections.txt'); % intersection coordinates
boundary = csvread('boundary.txt');
save('boundary.mat', 'boundary');
allNodesFile = 'ways.txt'; % all street coordinates and metadata

% Read building node coordinates
allBuildingsFile = 'buildings.txt';

% Transfer intersection coordinates to an inters struct
unfold = @(v) v{:}; % handle to unfold function
inters(size(intersections,1),1).coords = [];
[inters.coords] = unfold(num2cell(intersections,2));
clear intersections;

% Extract information about each way and intersection (origin of the ways struct)
[ways, inters] = parse_txt_nodes_for_roads(allNodesFile, inters);
inters = compute_inter_type(inters);

% Exract information about each building
[buildings] = parse_txt_nodes_for_buildings(allBuildingsFile);
buildings = buildings_filter(buildings);

save('inters.mat', 'inters');
save('ways.mat', 'ways');
save('buildings.mat', 'buildings');

% Exract information about each natural
allNaturalsFile = 'nature.txt';
[naturals] = parse_txt_nodes_for_naturals(allNaturalsFile);

% Exract information about each leisure
allLeisuresFile = 'leisure.txt';
[leisures] = parse_txt_nodes_for_leisures(allLeisuresFile);
save('naturals.mat', 'naturals');
save('leisures.mat', 'leisures');

%% Extract dense road nodes
road_dense = 10; % interval between locations, 10 meters
[roads] = extract_dense_roads(ways, inters, road_dense);
save('roads.mat','roads');

end