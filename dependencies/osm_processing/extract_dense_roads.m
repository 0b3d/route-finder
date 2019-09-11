function [roads] = extract_dense_roads(ways, inters, road_dense)

roads(length(ways),1).coords = [];
roads(length(ways),1).azs = [];
roads(length(ways),1).dense_coords = [];
roads(length(ways),1).dense_azs = [];
%roads(length(ways),1).BSD = []; 
roads(length(ways),1).inters = [];
roads(length(ways),1).road_idx = [];
roads(length(ways),1).sz = [];

intersections = cell2mat({inters.coords}');

% for dataset
for i=1:size(ways, 1)
    % coords
    roads(i).coords = ways(i).coords;  
    % azs
    for j=1:(size(roads(i).coords,1)-1)
        lat1 = roads(i).coords(j,1);
        lon1 = roads(i).coords(j,2);
        lat2 = roads(i).coords(j+1,1);
        lon2 = roads(i).coords(j+1,2);
        az0 = azimuth(lat1,lon1,lat2,lon2); % az is measured clockwise from north
        az1 = azimuth(lat2,lon2,lat1,lon1);
        curaz = [az0 az1];
        roads(i).azs = [roads(i).azs; curaz];
    end
    roads(i).azs = [roads(i).azs; curaz];
end

% more dense road nodes
parfor_progress('dense roads', size(ways,1));
for p = 1:size(ways, 1)
    curroad = roads(p);
    dist = zeros(size(curroad.coords, 1) - 1, 1);
    for i = 1:(size(curroad.coords, 1) - 1)
        lat1 = curroad.coords(i,1);
        lon1 = curroad.coords(i,2);
        lat2 = curroad.coords(i+1,1);
        lon2 = curroad.coords(i+1,2);
        [arclen,~] = distance(lat1, lon1, lat2, lon2);
        dist(i) = arclen / 360 * (2*earthRadius*pi);
        npts = round((dist(i) / road_dense) - 1); % 2 is [lat1 lon1] and [lat2 lon2]
        if npts < 0
            npts = 2;
        else
            npts = npts + 2;
        end
        [lat, lon] = track2(lat1, lon1, lat2, lon2, [], [], npts);
%         %% test intervals
%         if npts == 0
%             a = distance(lat1, lon1, lat2, lon2);
%             d = a / 360 * (2*earthRadius*pi);
%         else
%             a = distance(lat1, lon1, lat(1), lon(1));
%             b = a / 360 * (2*earthRadius*pi);
%             c = distance(lat2, lon2, lat(npts), lon(npts));
%             d = c / 360 * (2*earthRadius*pi);
%             for k = 1:npts-1
%                 lat1 = lat(k);
%                 lon1 = lon(k);
%                 lat2 = lat(k+1);
%                 lon2 = lon(k+1);
%                 [arclen,~] = distance(lat1, lon1, lat2, lon2);
%                 d_dist(k) = arclen / 360 * (2*earthRadius*pi);
%             end
%         end
               
        %denseroad(i).coords = [lat1 lon1; lat lon; lat2 lon2]; % 1*n  
        if i == 1
            denseroad(i).coords = [lat1 lon1 ; lat(2:npts-1) lon(2:npts-1); lat2 lon2];
        else
            denseroad(i).coords = [lat(2:npts-1) lon(2:npts-1) ; lat2 lon2];
        end
%         % dense az
%         curaz = curroad.azs(i, :);
%         %dim = size(lat, 1);  % i=4
%         if npts == 2
%             denseazs(i).azs = [curroad.azs(i, :); curroad.azs(i+1, :)];
%         else
%             dim = npts - 2; % delete the start and end point
%             az_1 = ones(dim, 1).* curaz(1);
%             az_2 = ones(dim, 1).* curaz(2);
%             denseazs(i).azs = [curroad.azs(i, :);az_1 az_2;curroad.azs(i+1, :)];
%         end
    end 
    
    % dense coords
    for i = 1:(size(curroad.coords, 1) - 1)
        roads(p).dense_coords = [roads(p).dense_coords; denseroad(i).coords];
        % roads(p).dense_azs = [roads(p).dense_azs; denseazs(i).azs];
    end
    
    roads(p).sz = size(roads(p).dense_coords,1);
    % dense azs
    for i=1:(size(roads(p).dense_coords,1)-1)
        lat1 = roads(p).dense_coords(i,1);
        lon1 = roads(p).dense_coords(i,2);
        lat2 = roads(p).dense_coords(i+1,1);
        lon2 = roads(p).dense_coords(i+1,2);
        az0 = azimuth(lat1,lon1,lat2,lon2);
        az1 = azimuth(lat2,lon2,lat1,lon1);
        curaz = [az0 az1];
        roads(p).dense_azs = [roads(p).dense_azs; curaz];
    end
    roads(p).dense_azs = [roads(p).dense_azs; curaz];
    
    % inters and wayIdx
    [Lia, Locb] = ismember(roads(p).dense_coords, intersections,'rows');
    Locb_v2 = zeros(size(Locb,1),1); % since some closet points will all be recognised as intersections
    Lia_v2 = ones(size(Lia,1),1);
    for i = 1:size(Locb,1)
        if i > 1 && Locb(i) == Locb(i-1)
            Locb_v2(i) = 0;
        else 
            Locb_v2(i) = Locb(i);
        end
        
        if Locb_v2(i) == 0
            Lia_v2(i) = 0;
            roads(p).road_idx(i).IDX = [];
        else
            curway_Idx = inters(Locb_v2(i)).ways;
            roads(p).road_idx(i).IDX = curway_Idx;
        end       
    end 
    roads(p).inters = Lia_v2;
    
    parfor_progress('dense roads');
end

end