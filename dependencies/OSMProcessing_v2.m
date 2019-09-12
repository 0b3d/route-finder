function [inters, buildings, roads] = OSMProcessing_v2()
%% Parse intersection, roads and building info from OSM map     
%system('python /home/os17592/dev/route-finder/dependencies/map_parsing/parse_script.py');

%dev_path = getenv('dev')
filepath = fullfile(pwd, 'dependencies', 'map_parsing', 'parse_script.py');
command = ['python', ' ', filepath];
system(command);

% Read intersection and node coordinates previously extracted from map.osm
intersections = csvread('Data/intersections.txt'); % intersection coordinates
boundary = csvread('Data/boundary.txt');
save('Data/boundary.mat', 'boundary');
allNodesFile = 'Data/ways.txt'; % all street coordinates and metadata

% Read building node coordinates
allBuildingsFile = fullfile(pwd,'Data','buildings.txt');

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

save('Data/inters.mat', 'inters');
save('Data/ways.mat', 'ways');
save('Data/buildings.mat', 'buildings');

% Exract information about each natural
allNaturalsFile = 'Data/nature.txt';
[naturals] = parse_txt_nodes_for_naturals(allNaturalsFile);

% Exract information about each leisure
allLeisuresFile = 'Data/leisure.txt';
[leisures] = parse_txt_nodes_for_leisures(allLeisuresFile);
save('Data/naturals.mat', 'naturals');
save('Data/leisures.mat', 'leisures');

%% Extract dense road nodes
road_dense = 10; % interval between locations, 10 meters
[roads] = extract_dense_roads(ways, inters, road_dense);
save('Data/roads.mat','roads');

end