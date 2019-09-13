function panos = getBuildingGap(panos, buildings, arclen)

parfor_progress('building gaps', size(panos,1));
for p=1:size(panos, 1)
    locaCoords = cell2mat({panos(p).coords}');
    yaw = panos(p).yaw;
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
    
    % Seperate to left and right parts for building gap
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
    
    % check intersections with buildings
    right_buildings_inter = cell(size(buildings_in_circle,1), size(search_areas.right, 1));
    for i=1:size(search_areas.right, 1)
        for j=1:size(buildings_in_circle,1)
            curline_x = search_areas.right(i,1);
            curline_y = search_areas.right(i,2);
            curbuilding = buildings_in_circle(j).coords;
            [inter_x, inter_y] = polyxpoly([curline_x, locaCoords(1)], [curline_y, locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
            if size(inter_x, 1) > 0
                for k=1:size(inter_x, 1)
                    inter(k,1) = inter_x(k);
                    inter(k,2) = inter_y(k);
                end 
                right_buildings_inter{j,i} = num2cell(inter,2);
            end    
        end    
    end

    left_buildings_inter = cell(size(buildings_in_circle,1), size(search_areas.right, 1));
    for i=1:size(search_areas.left, 1)
        for j=1:size(buildings_in_circle,1)
            curline_x = search_areas.left(i,1);
            curline_y = search_areas.left(i,2);
            curbuilding = buildings_in_circle(j).coords;
            [inter_x, inter_y] = polyxpoly([curline_x, locaCoords(1)], [curline_y, locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
            if size(inter_x, 1) > 0
                for k=1:size(inter_x, 1)
                    inter(k,1) = inter_x(k);
                    inter(k,2) = inter_y(k);
                end
                left_buildings_inter{j,i} = num2cell(inter,2);
            end
        end            
    end    
    panos(p).leftbuildings = left_buildings_inter;
    panos(p).rightbuildings = right_buildings_inter;
    
    parfor_progress('building gaps');
end

end