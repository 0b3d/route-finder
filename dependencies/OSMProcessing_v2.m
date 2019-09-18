function [inters, buildings, roads] = OSMProcessing_v2(dataset, map_file)
%% Parse intersection, roads and building info from OSM map     

filepath = fullfile(pwd, 'dependencies', 'map_parsing', 'parse_script.py');
command = ['python', ' ', filepath, ' ', dataset, ' ', map_file];
system(command);

% Read intersection and node coordinates previously extracted from map.osm
intersections = csvread(['Data/',dataset,'/intersections.txt']); % intersection coordinates
boundary = csvread(['Data/',dataset,'/boundary.txt']);
save(['Data/',dataset,'/boundary.mat'], 'boundary');
allNodesFile = ['Data/',dataset,'/ways.txt']; % all street coordinates and metadata

% Read building node coordinates
allBuildingsFile = fullfile(pwd,['Data/',dataset,'/buildings.txt']);

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

save(['Data/',dataset,'/inters.mat'], 'inters');
save(['Data/',dataset,'/ways.mat'], 'ways');
save(['Data/',dataset,'/buildings.mat'], 'buildings');

% Exract information about each natural
allNaturalsFile = ['Data/',dataset,'/nature.txt'];
[naturals] = parse_txt_nodes_for_naturals(allNaturalsFile);

% Exract information about each leisure
allLeisuresFile = ['Data/',dataset,'/leisure.txt'];
[leisures] = parse_txt_nodes_for_leisures(allLeisuresFile);
save(['Data/',dataset,'/naturals.mat'], 'naturals');
save(['Data/',dataset,'/leisures.mat'], 'leisures');

%% Extract dense road nodes
road_dense = 10; % interval between locations, 10 meters
[roads] = extract_dense_roads(ways, inters, road_dense);
save(['Data/',dataset,'/roads.mat'],'roads');

end