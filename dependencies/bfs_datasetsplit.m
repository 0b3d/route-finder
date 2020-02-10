clear all
close all

% Load data
% city = 'manhattan';
% % In order to limit searching
% % For Wall Street 
% name = 'wallstreet';
% nnodes = 7224;
% start = "6rIMyvAZUW4sT3ffqYOg0w";
% lowerlat = 40.701149;
% upperlat = 40.729400;
% lowerlon = -74.028;
% upperlon = -73.940;

% % For Union Square 
% name = 'unionsquare';
% nnodes = 15525;
% start = "dFbip4uo7CNu86y52Axc5g";
% lowerlat = 40.7171;
% upperlat = 40.7535;
% lowerlon = -74.028;
% upperlon = -73.940;

% % For Hudson River
% name = 'hudsonriver';
% nnodes = 18085;
% start = "PreXwwylmG23hnheZ__zGw";
% lowerlat = 40.7435;
% upperlat = 40.788;
% lowerlon = -74.028;
% upperlon = -73.940;

city = 'pittsburgh';
% % In order to limit searching
% % For CMU 
% name = 'cmu';
% nnodes = 15947;
% start = "r5DqC1wcUi2Lw6T4GvUxwQ";
% lowerlat = 40.425;
% upperlat = 40.460;
% lowerlon = -79.9853;
% upperlon = -79.930;

% % For Allegheny 
% name = 'allegheny';
% nnodes = 14073;
% start = "ohwj1wXoJ3KOPwnSPaAMCw";
% lowerlat = 40.4347;
% upperlat = 40.46;
% lowerlon = -80.035;
% upperlon = -79.9817;
% 
% For South Shore
name = 'southshore';
nnodes = 14967;
start = "ljBFHUcoonDeE2omJ7PrOQ";
lowerlat = 40.425;
upperlat = 40.4506;
lowerlon = -80.035;
upperlon = -79.9746;


load(['Data/',city,'.mat']); 


% Work only in a small area
n = length(s);
lat = zeros(n,1);
lon = zeros(n,1);
for i=1:n
    lat(i,1) = s(i).gsv_coords(1,1);
    lon(i,1) = s(i).gsv_coords(1,2);
end
subset_indices = find(lat >= lowerlat & lat <= upperlat & lon >= lowerlon & lon <= upperlon);

n = size(subset_indices,1);
subset = struct();
for i=1:n
    idx = subset_indices(i,1);
    subset(i).id = s(idx).id;
    subset(i).gsv_coords = s(idx).gsv_coords;
    subset(i).gsv_yaw = s(idx).gsv_yaw;
    subset(i).neighbor = s(idx).neighbor;
    subset(i).bearing = s(idx).bearing;
    subset(i).oindex = idx;
end
clear s;

% Create adjacency matrix 
A = zeros(length(subset), length(subset));
l = length(subset);
for i=1:length(subset)
    neighbours = subset(i).neighbor; % original index
    for j=1:size(neighbours, 1)
        neighbor = neighbours(j); 
        new_index = find(subset_indices == neighbor);
        A(i,new_index) = 1;
    end
end

% Get subset_ids
for i=1:l
   subset_ids(i, :) = subset(i).id;
end

% Create graph
G = digraph(A);

% start 
idx = find(strcmp(subset_ids, start));
bfs = bfsearch(G, idx);
bfs_indices = bfs(1:nnodes); % These are new indices
% indices = subset_indices(nds); % those are all original indices from the largest dataset

% create new structure
n = size(bfs_indices,1);
routes = struct();
for i=1:n
    idx = bfs_indices(i,1); % subset index
    routes(i).id = subset(idx).id;
    routes(i).gsv_coords = subset(idx).gsv_coords;
    routes(i).gsv_yaw = subset(idx).gsv_yaw;
    % get new indices of neighbors
    neighbours = subset(idx).neighbor; % original index
    bearings = subset(idx).bearing; 
    new_neighbors = [];
    new_bearings = [];

    for j=1:size(neighbours, 1)
        neighbor = neighbours(j);
        bearing = bearings(1,j);
        if i == 7172
            m=i;
        end
        
        try
        tmp_index = find(subset_indices == neighbor); % if returns empty means this neighbor not in the subset, check lat/lot values
        new_index = find(bfs_indices == tmp_index); 
        if ~isempty(new_index)
            new_neighbors = [new_neighbors; new_index];
            new_bearings = [new_bearings; bearing];
        end
        
        catch
            fprintf('Neighbor with original index %d not found, check lat/lon limits \n', neighbor);
        end
    end    
    
    routes(i).neighbor = new_neighbors;
    routes(i).bearing = new_bearings; %(subset(idx).bearing)'; % row to coloum
end
clear subset;

save(['Data/', city ,'_', name,'.mat'],'routes');
