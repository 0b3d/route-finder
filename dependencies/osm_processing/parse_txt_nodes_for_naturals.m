function [naturals] = parse_txt_nodes_for_naturals(allNaturalsFile)
% Parse nodes from nature.txt

% naturals struct (information about each natural)
naturals(1).coords = []; % node coordinates
naturals(1).natural_type = ''; % type of natural 

% scan allNaturalsFile
fid = fopen(allNaturalsFile);
allNaturals = textscan(fid, '%s', 'Delimiter', '\n');
allNaturals = allNaturals{1,1};
allNaturalsCoords = parseCoords(allNaturals);

% iterate through all building nodes
naturalNum = 0;
for i = 1:size(allNaturals,1)
    % Skip blank lines
    if(isempty(allNaturals{i}))
        continue;
    end
    % Check start of new natural
    if(contains(allNaturals{i}, 'nature id:'))
        naturalNum = naturalNum + 1;
        naturals(naturalNum).coords = [];
        continue
    end
    % Check type of natural
    if(contains(allNaturals{i}, 'nature_type:'))
        naturals(naturalNum).natural_type = allNaturals{i}(14:end);
        continue;
    end
    % If this point reached, add this node's coordinates to natural
    naturals(naturalNum).coords(end+1,:) = allNaturalsCoords(i,:);

end

% Transpose structs
naturals = naturals';
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

