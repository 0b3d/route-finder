city = 'pittsburgh'
area = 'southshore'

load(['Data/', city,'_', area,'.mat']);

% Extract coordinates 
coords = zeros(length(routes),2);
for i=1:length(routes)
    coords(i,:) = routes(i).gsv_coords; 
end

csvwrite(['Data/', city,'_', area,'.csv'], coords);