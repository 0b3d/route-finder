function panos = BSD_generation(panos, inters, buildings, radius)

arclen = radius / (2*earthRadius*pi) * 360;  % 0.001

%arclen = 0.00025*4;

parfor_progress('BSD extraction', size(panos,1));
for p=1:size(panos, 1)
    locaCoords = cell2mat({panos(p).coords}');
    yaw = panos(p).yaw;
    %forwardInter = panos(p).forward_inter;
    %backwardInter = panos(p).backward_inter;
    %distInter = panos(p).dists;
    
    %% Find buildings in search area
    circle = zeros(72, 2);  % search area, every 5 degree
    [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen,[],[],[],72);
    buildings_in_circle = [];
    junctions_in_circle = [];
    
    
    for i=1:size(buildings,1)
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
%         if(adjustedAZ > 45 && adjustedAZ < 135)
%             search_areas.left = [search_areas.left; circle(i,:)];
%         elseif(adjustedAZ > 135 && adjustedAZ < 225)
%             search_areas.backward = [search_areas.backward; circle(i,:)];   
%         elseif(adjustedAZ > 225 && adjustedAZ < 315)
%             search_areas.right = [search_areas.right; circle(i,:)];  
%         else
%             search_areas.forward = [search_areas.forward; circle(i,:)];  
%         end
          if (adjustedAZ > 45 && adjustedAZ < 135)
              search_areas.left = [search_areas.left; circle(i,:)];
          end
          if (adjustedAZ > 225 && adjustedAZ < 315)
              search_areas.right = [search_areas.right; circle(i,:)];
          end
          if (adjustedAZ > 0 && adjustedAZ < 90) || (adjustedAZ > 270 && adjustedAZ < 360)
              search_areas.forward = [search_areas.forward; circle(i,:)];
          end
          if (adjustedAZ > 90 && adjustedAZ < 270)
              search_areas.backward = [search_areas.backward; circle(i,:)];
          end          
    end
    
    %% Get Labels for junctions
    flabel = getLabelJC_v2(search_areas.forward, junctions_in_circle, locaCoords);
%     ang1 = -45;
%     ang2 = 45;
%     startDeg = GGang2Deg(yaw);
%     %startDeg = yaw;
%     triG = genNewJCarea_zmj(locaCoords',startDeg,arclen/2,ang1,ang2);
%     plot(triG(1,:),triG(2,:),'--r');hold on;
%     Area = [triG'; locaCoords];
%     flabel = getLabelJC_v3(Area, junctions_in_circle, locaCoords);
    panos(p).forwardlabel = flabel;
    descList(1) = flabel;
    
    blabel = getLabelJC_v2(search_areas.backward, junctions_in_circle, locaCoords);
%     ang1 = 135;
%     ang2 = 225;
%     startDeg = GGang2Deg(yaw);
%     %startDeg = yaw;
%     triG = genNewJCarea_zmj(locaCoords',startDeg,arclen/2,ang1,ang2);
%     plot(triG(1,:),triG(2,:),'--r');hold on;
%     Area = [triG'; locaCoords];
%     blabel = getLabelJC_v3(Area, junctions_in_circle, locaCoords);
    panos(p).backwardlabel = blabel;   
    descList(3) = blabel;
    
    
    %% Get Labels for gaps
    llabel = getLabelBD(search_areas.left, buildings_in_circle, locaCoords);
    panos(p).leftlabel = llabel;
    descList(4) = llabel;
    rlabel = getLabelBD(search_areas.right, buildings_in_circle, locaCoords);
    panos(p).rightlabel = rlabel;
    descList(2) = rlabel;
    panos(p).descLists = descList;
    parfor_progress('BSD extraction');
end

end