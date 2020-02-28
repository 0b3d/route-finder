% correct gsv_yaw and neighbors
clear all
close all
city = 'pittsburgh'; % manhattan, pittsburgh
load(['Data/', city ,'/', city, '.mat'],'s');

for i=1:length(s)
    yaw = double(s(i).gsv_yaw);
    neighbors = s(i).neighbor;
    bearings = (double(s(i).bearing))';% bearings should be coloum, check that!
    if yaw < 0
        yaw = yaw + 360;
    end
    if size(neighbors, 1) > 1
        init = ones(size(neighbors ,1), 1)*yaw;
        minus = abs(init - bearings); 
        minus(minus > 180) = 360 - minus(minus > 180);
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
            if size(neighbors, 1) == 0 || size(bearings, 1) == 0
                disp('the size of neighbors and bearings is 0');
            else
                disp('the size of neighbors is not equal to the size of bearings');
            end
        end
    end
    s(i).gsv_yaw = yaw;
    s(i).neighbor = neighbors;
    s(i).bearing = bearings;
end

save(['Data/',city,'_new','.mat'],'s');
