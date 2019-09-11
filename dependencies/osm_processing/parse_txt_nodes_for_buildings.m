function [buildings] = parse_txt_nodes_for_buildings(allBuildingsFile)
% Parse nodes from buildings.txt

% buildings struct (information about each building)
buildings(1).coords = []; % node coordinates
buildings(1).building_type = ''; % type of building 

% scan allBuildingsFile
fid = fopen(allBuildingsFile);
allBuildings = textscan(fid, '%s', 'Delimiter', '\n');
allBuildings = allBuildings{1,1};
allBuildingsCoords = parseCoords(allBuildings);

% iterate through all building nodes
buildingNum = 0;
for i = 1:size(allBuildings,1)
    % Skip blank lines
    if(isempty(allBuildings{i}))
        continue;
    end
    % Check start of new building
    if(contains(allBuildings{i}, 'building id:'))
        buildingNum = buildingNum + 1;
        buildings(buildingNum).coords = [];
        continue
    end
    % Check type of building
    if(contains(allBuildings{i}, 'building_type:'))
        buildings(buildingNum).building_type = allBuildings{i}(16:end);
        continue;
    end
    % If this point reached, add this node's coordinates to building
    buildings(buildingNum).coords(end+1,:) = allBuildingsCoords(i,:);
    
end

% Transpose structs
buildings = buildings';
end



%% Local functions
function allNodesCoords = parseCoords(allNodes)
allNodesCoords = NaN(size(allNodes,1),2);
for i = 1:size(allNodes,1)
    try
        allNodesCoords(i,:) = strread(allNodes{i,1}, '%f', 2, 'delimiter', ',');
    catch
        allNodesCoords(i,:) = [NaN, NaN];
    end
end
end

function found = contains(str, pattern)
if(~isempty(strfind(str,pattern)))
    found = true;
else
    found = false;
end
end

