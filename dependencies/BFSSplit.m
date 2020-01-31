clear all
clear

% LOad data
city = 'manhattan'
name = 'wallstreet'
nnodes = 7224
start = "6rIMyvAZUW4sT3ffqYOg0w"

% In order to limit searching
% For Wallstreetarea 
lowerlat = 40.701149
upperlat = 40.729400

% For Hudson 
%lowerlat = 40.729400
%upperlat = 40.787206


load(['Data/',city,'.mat']); 


% Work only in a small area
n = length(s);
lat = zeros(n,1);
for i=1:n
    lat(i,1) = s(i).gsv_coords(1,1);
end
subset_indices = find(lat >= lowerlat & lat <= upperlat);

n = size(subset_indices,1);
subset = struct
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

%subset_ids
for i=1:l
   subsetIDs(i, :) = subset(i).id;
end

% Create graph
G = digraph(A);

% start 
idx = find( strcmp(subsetIDs, start) );
bfs = bfsearch(G, idx);
nds = bfs(1:nnodes); %This are new indices
indices = subset_indices(nds);

save(['Data/', city ,'_', name,'.mat'],'indices');
