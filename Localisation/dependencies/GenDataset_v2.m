function [routes] = GenDataset_v2(roads)
% generate BSDs dataset
index = 0;
cursz = zeros(size(roads, 1), 1);
for i=1:length(roads)
    cursz(i) = roads(i).sz;
end
sum = cumsum(cursz);

routes = struct([]);
for i = 1:length(roads)       
    curroad = roads(i).dense_coords;
    curyaw = roads(i).dense_azs;
    curinter = roads(i).inters;
    curneighbor = roads(i).road_idx;
    curwayidx = i;
    for j = 1:size(curroad,1)
        index = index + 1;
        routes(index).coords = curroad(j,:);
        routes(index).yaw = curyaw(j,1); 
        routes(index).wayidx = curwayidx;
        ifinter = curinter(j,1);
        
        % find neighbor nodes
        if ifinter == 0 % not an inter
            if j == size(curroad, 1)
                routes(index).neighbor = [];
            else
                routes(index).neighbor = index+1;
            end
        else 
            road_connect = curneighbor(j).IDX;
            if j == size(curroad, 1)
                neigh = [];
            else 
                neigh = index+1;
            end

            for k=1:size(road_connect, 2)
                curconnect = road_connect(k);             
                if curconnect ~= i
                    connect_road = roads(curconnect).dense_coords;
                    [Lia, ~] = ismember(connect_road, curroad(j,:),'rows');
                    idx = find(Lia); % index in seperate roads
                    
                    if curconnect == 1
                        itx = idx; % index in whole routes
                    else
                        itx = sum(curconnect-1) + idx;
                    end
                    
                    if idx == size(connect_road, 1)
                        idx = [];
                    else
                        idx = itx + 1;
                    end
                    try
                        neigh = [neigh; idx];  
                    catch
                        disp('there is an error');
                    end
                end
            end
            routes(index).neighbor = neigh;
        end      
    end
end

% find associated pano_id, gsv_yaw, gsv_coords for each location
zoom = 1;
download_num = length(routes);
panos = gsv_download_v4(routes, download_num, zoom); 
for i=1:length(routes)
    routes(i).id = panos(i).id;
    routes(i).gsv_coords = panos(i).coords_t;
    routes(i).gsv_yaw = panos(i).yaw;   
end

end