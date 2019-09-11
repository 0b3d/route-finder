function [leisures] = parse_txt_nodes_for_leisures(allLeisuresFile)
% Parse nodes from leisure.txt

% leisures struct (information about each leisure)
leisures(1).coords = []; % node coordinates
leisures(1).leisure_type = ''; % type of leisure

% scan allLeisuresFile
fid = fopen(allLeisuresFile);
allLeisures = textscan(fid, '%s', 'Delimiter', '\n');
allLeisures = allLeisures{1,1};
allLeisuresCoords = parseCoords(allLeisures);

% iterate through all leisure nodes
leisureNum = 0;
for i = 1:size(allLeisures,1)
    % Skip blank lines
    if(isempty(allLeisures{i}))
        continue;
    end
    % Check start of new leisure
    if(contains(allLeisures{i}, 'leisure id:'))
        leisureNum = leisureNum + 1;
        leisures(leisureNum).coords = [];
        continue
    end
    % Check type of leisure
    if(contains(allLeisures{i}, 'leisure_type:'))
        leisures(leisureNum).leisure_type = allLeisures{i}(15:end);
        continue;
    end
    % If this point reached, add this node's coordinates to leisure
    leisures(leisureNum).coords(end+1,:) = allLeisuresCoords(i,:);

end

% Transpose structs
leisures = leisures';
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

