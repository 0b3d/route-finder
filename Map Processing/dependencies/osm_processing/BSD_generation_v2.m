function panos = BSD_generation_v2(panos, inters, buildings, radius)

arclen = radius / (2*earthRadius*pi) * 360;  

parfor_progress('BSD extraction', size(panos,2));
for p=1:size(panos, 2)
    locaCoords = cell2mat({panos(p).coords}');
    yaw = panos(p).yaw;
    if isempty(locaCoords) || isempty(yaw)
        continue;
    end    
    
    %% Find buildings in search area
%     circle = zeros(72, 2);  % search area, every 5 degree
%     [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen,[],[],[],72);
    circle = zeros(180, 2);  % search area, every 2 degree
    [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen,[],[],[],180);
    buildings_in_circle = [];
    junctions_in_circle = [];
    
    
    for i=1:size(buildings,2)  % i=1:size(buildings,1)
        curcoord = buildings(i).coords;
        in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
        if(sum(in)) >= 1
            buildings_in_circle = [buildings_in_circle; buildings(i)];
        end
    end

    %% Find junctions in search area
    for i=1:size(inters,2)
        curcoord = inters(i).coords;
        in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
        if in == 1
            junctions_in_circle = [junctions_in_circle; inters(i)];
        end
    end
    
    % Find junctions which are not blocked (invisiable)
    junctions_in_circle = getVisiableJC(junctions_in_circle, buildings_in_circle, locaCoords);    
    
    
    %% Seperate to forward, backward parts for junctions and left, right parts for gaps
    search_areas.forward = [];
    search_areas.backward = [];
    search_areas.left = [];
    search_areas.right = [];
    for i=1:size(circle, 1)
        az = azimuth(locaCoords(1), locaCoords(2), circle(i,1), circle(i,2));
        adjustedAZ = mod(yaw - az, 360);
        % each part occupies 90 degree
        if(adjustedAZ > 45 && adjustedAZ < 135)
            search_areas.left = [search_areas.left; circle(i,:)];
        elseif(adjustedAZ > 135 && adjustedAZ < 225)
            search_areas.backward = [search_areas.backward; circle(i,:)];   
        elseif(adjustedAZ > 225 && adjustedAZ < 315)
            search_areas.right = [search_areas.right; circle(i,:)];  
        else
            search_areas.forward = [search_areas.forward; circle(i,:)];  
        end
%         % Yam use 180 degree region for junctions detection, and 90 degree region
%         % for building gaps detection
%         if (adjustedAZ > 45 && adjustedAZ < 135)
%           search_areas.left = [search_areas.left; circle(i,:)];
%         end
%         if (adjustedAZ > 225 && adjustedAZ < 315)
%           search_areas.right = [search_areas.right; circle(i,:)];
%         end
%         if (adjustedAZ > 0 && adjustedAZ < 90) || (adjustedAZ > 270 && adjustedAZ < 360)
%           search_areas.forward = [search_areas.forward; circle(i,:)];
%         end
%         if (adjustedAZ > 90 && adjustedAZ < 270)
%           search_areas.backward = [search_areas.backward; circle(i,:)];
%         end          
    end
    
    %% Get Labels for junctions
    descList = zeros(1, 4);
    flabel = getLabelJC_v2(search_areas.forward, junctions_in_circle, locaCoords);
    %panos(p).forwardlabel = flabel;
    descList(1) = flabel;
    
    blabel = getLabelJC_v2(search_areas.backward, junctions_in_circle, locaCoords);
    %panos(p).backwardlabel = blabel;   
    descList(3) = blabel;
    
    %% Get Labels for gaps
    llabel = getLabelBD(search_areas.left, buildings_in_circle, locaCoords);
    %panos(p).leftlabel = llabel;
    descList(4) = llabel;
    rlabel = getLabelBD(search_areas.right, buildings_in_circle, locaCoords);
    %panos(p).rightlabel = rlabel;
    descList(2) = rlabel;
    descList(descList == 2) = 0;
    descList(descList == 3) = 0;
    panos(p).BSDs_t = descList;
    
%     % inverse direction
%     descList(1) = blabel;
%     descList(2) = llabel;
%     descList(3) = flabel;
%     descList(4) = rlabel;
%     descList(descList == 2) = 0;
%     descList(descList == 3) = 0;
%     panos(p).invBSDs = descList;
    
    parfor_progress('BSD extraction');
end

end