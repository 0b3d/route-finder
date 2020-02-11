function panos = BSD_generation_v2(panos, inters, buildings, radius, range)

arclen = radius / (2*earthRadius*pi) * 360;  

parfor_progress('BSD extraction', size(panos,2));
for p=1:size(panos, 2)
    locaCoords = cell2mat({panos(p).gsv_coords}');
    yaw = double(panos(p).gsv_yaw);
   
    if isempty(locaCoords) || isempty(yaw)
        continue;
    end    
    
    %% Find buildings in search area
    circle = zeros(360/range, 2);  % search area, every 2 degree
    [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [],[],[],360/range);
    buildings_in_circle = [];
    junctions_in_circle = [];
    
    
    for i=1:size(buildings,2)  % i=1:size(buildings,1)
        curcoord = buildings(i).coords;
        in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
        if(sum(in)) >= 1 && size(buildings(i).coords, 1) > 2
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

    [search_areas.forward(:,1), search_areas.forward(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw-45, yaw+45],[],[],90/range);
    [search_areas.right(:,1), search_areas.right(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw+45, yaw+135],[],[],90/range);
    [search_areas.backward(:,1), search_areas.backward(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw+135, yaw+225],[],[],90/range);
    [search_areas.left(:,1), search_areas.left(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw+225, yaw+315],[],[],90/range);

    %% Get Attributes for junctions
    dist_f = getAttribute_JC(search_areas.forward, junctions_in_circle, locaCoords);
    dist_b = getAttribute_JC(search_areas.backward, junctions_in_circle, locaCoords);
       
    %% Get Attributes for gaps
    [zerL_l, d_min_l, dist_diff_l] = getAttribute_BD(search_areas.left, buildings_in_circle, locaCoords, radius);
    [zerL_r, d_min_r, dist_diff_r] = getAttribute_BD(search_areas.right, buildings_in_circle, locaCoords, radius);
            
    panos(p).dist_f = dist_f;
    panos(p).dist_b = dist_b;
    panos(p).zerL_l = zerL_l;
    panos(p).d_min_l = d_min_l;
    panos(p).dist_diff_l = dist_diff_l;
    panos(p).zerL_r = zerL_r;
    panos(p).d_min_r = d_min_r;
    panos(p).dist_diff_r = dist_diff_r;
    
    parfor_progress('BSD extraction');
end
end