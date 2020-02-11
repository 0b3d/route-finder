% correct gsv_yaw and neighbors
clear all
close all
city = 'manhattan';
name = 'wallstreet';
load(['Data/', city ,'_', name,'.mat'],'routes');

for i=1:length(routes)
    yaw = double(routes(i).gsv_yaw);
    neighbors = routes(i).neighbor;
    bearings = double(routes(i).bearing);
    if yaw < 0
        routes(i).gsv_yaw = yaw + 360;
    end
    if size(neighbors, 1) > 1
        init = ones(size(neighbors ,1), 1)*yaw;
        minus = abs(init - bearings);
        [m,index] = max(minus);
        neighbors(index,:)=[];
        bearings(index,:) = [];
    else
        minus = abs(yaw-bearings);
        try
        if minus > 90 && minus < 270
            neighbors = [];
            bearings = [];
        end
        catch
            disp('the size of neighbors is not equal to the size of bearings');
        end
    end
    routes(i).neighbor = neighbors;
    routes(i).bearing = bearings;
end

save(['Data/', city ,'_', name,'.mat'],'routes');
