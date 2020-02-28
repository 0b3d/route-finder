% correct neighbors and bearings
clear all
close all

city = 'manhattan'; % manhattan,pittsburgh
dataset = 'wallstreet5k';
load(['Data/',city,'_new','.mat'],'s');
load(['Data/streetlearn/',dataset,'.mat'],'routes');

T = struct2table(routes);
OIDX = T.oidx;

for i=1:length(routes)
    oidx = routes(i).oidx;
    neighbors = s(oidx).neighbor;
    bearings = s(oidx).bearing;
    new_neighbors  = [];
    new_bearings = [];
    
    for j=1:size(neighbors,1)
        nidx = find(ismember(OIDX,neighbors(j)));
        if isempty(nidx)
            continue;
        else
            new_neighbors = [new_neighbors; nidx];
            new_bearings = [new_bearings; bearings(j)];
        end
    end
    routes(i).neighbor = new_neighbors;
    routes(i).bearing = new_bearings;
    yaw_n = routes(i).gsv_yaw;
    yaw_o = s(oidx).gsv_yaw;
    if yaw_n ~= yaw_o
        disp('errors');
    end   
end

save(['Data/streetlearn/',dataset,'_new','.mat'],'routes');

