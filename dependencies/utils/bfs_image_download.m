%% Parse intersection, roads and building info from OSM map     
system('python dependencies/map_parsing/parse_script.py');
% Read intersection and node coordinates previously extracted from map.osm
intersections = csvread('intersections.txt'); % intersection coordinates
boundary = csvread('boundary.txt');
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
thresh = 10;
inters = inters_filter(inters, ways, thresh);

% Exract information about each building and non_gap
[buildings] = parse_txt_nodes_for_buildings(allBuildingsFile);

%% Scrape Google Street View panoramas and associated metadata
% % breadth-first search from initial seed location (see bfs_download.m for options)
bfs_download();
files = dir('bfs_panos/*.xml');
files = {files.name}'; 
mapFile = 'small_london.osm'; % OSM extract
panoDir = 'bfs_panos/'; 

% assign attributes to GSV panoramas based on OSM and store in "panos" struct
panos = get_pano_locations(mapFile, panoDir, files);

% crop the panos into four directions
files_jpg = dir('bfs_panos/*.jpg');
files_jpg = {files_jpg.name}'; 
snp_download_v2(panos, panoDir, files_jpg);

%% generate decriptor for each location
radius = 30;
panos = BSD_generation(panos, inters, buildings, radius);

% Only save the key information
parfor_progress('generate descriptors', size(panos,1));
parfor i=1:size(panos, 1)
    descriptors(i).id = panos(i).id;
    descriptors(i).coords = panos(i).coords;
    descriptors(i).yaw = panos(i).yaw;
    BSD = panos(i).descLists;
    BSD(BSD == 2) = 0;
    BSD(BSD == 3) = 0;
    descriptors(i).BSDs = BSD;
    descriptors(i).BSDs_de = bi2de(BSD);
       
    parfor_progress('generate descriptors');
end
save('panos.mat', 'descriptors');
