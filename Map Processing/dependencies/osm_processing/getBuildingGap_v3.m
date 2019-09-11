function panos = getBuildingGap_v3(panos, buildings, arclen)

parfor_progress('building gaps', size(panos,1));
for p=1:size(panos, 1)
    locaCoords = cell2mat({panos(p).coords}');
    yaw = panos(p).yaw;
    forwardInter = panos(p).forward_inter;
    backwardInter = panos(p).backward_inter;
    %distInter = panos(p).dists;
    
    %% Find buildings in search area
    circle = zeros(72, 2);  % search area, every 5 degree
    [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen,[],[],[],72);
    buildings_in_circle = [];
    
    for i=1:size(buildings,1)
        curcoord = buildings(i).coords;
        in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
        if(sum(in)) >= 1
            buildings_in_circle = [buildings_in_circle; buildings(i)];
        end
    end
    
    %% Find intersections which are not blocked (invisiable)
    flabel = getLabelJC(forwardInter, buildings_in_circle, locaCoords);
    panos(p).forwardlabel = flabel;
    descList(1) = flabel;
    blabel = getLabelJC(backwardInter, buildings_in_circle, locaCoords);
    panos(p).backwardlabel = blabel;   
    descList(3) = blabel;
    
    %% Seperate to left and right parts for building gap
    search_areas.left = [];
    search_areas.right = [];
    for i=1:size(circle, 1)
        az = azimuth(locaCoords(1), locaCoords(2), circle(i,1), circle(i,2));
        adjustedAZ = mod(yaw - az, 360);
        if(adjustedAZ > 45 && adjustedAZ < 135)
            search_areas.left = [search_areas.left; circle(i,:)];   
        elseif(adjustedAZ > 225 && adjustedAZ < 315)
            search_areas.right = [search_areas.right; circle(i,:)];  
        end
    end
    
    %% Get Labels
    llabel = getLabelBD(search_areas.left, buildings_in_circle, locaCoords);
    panos(p).leftlabel = llabel;
    descList(4) = llabel;
    rlabel = getLabelBD(search_areas.right, buildings_in_circle, locaCoords);
    panos(p).rightlabel = rlabel;
    descList(2) = rlabel;
    panos(p).descLists = descList;
    parfor_progress('building gaps');
end

end