function panos = BSD_generation_v4(panos, inters, buildings, roads, radius)
failed_tops = {};
arclen = radius / (2*earthRadius*pi) * 360;  % 0.001
parfor_progress('BSD extraction', size(panos,2));
for p=1:size(panos, 2)
    locaCoords = cell2mat({panos(p).coords}');
    yaw = panos(p).yaw;
    wayIdx = panos(p).wayidx;
    
    %% Find buildings in search area
    circle = zeros(72, 2);  % search area, every 5 degree
    [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen,[],[],[],72);
    buildings_in_circle = [];
    junctions_in_circle = [];
    
    
    for i=1:length(buildings)
        curcoord = buildings(i).coords;
        in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
        if(sum(in)) >= 1
            buildings_in_circle = [buildings_in_circle; buildings(i)];
        end
    end

    %% Find junctions in search area
    for i=1:length(inters)
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
    descList = zeros(1, 4);
    %flabel = getLabelJC_v2(search_areas.forward, junctions_in_circle, locaCoords);
    [flabel, fnearest_junction] = getLabelJC_v3(search_areas.forward, junctions_in_circle, locaCoords);
    %panos(p).forwardlabel = flabel;
    descList(1) = flabel;
    
    %blabel = getLabelJC_v2(search_areas.backward, junctions_in_circle, locaCoords);
    [blabel, bnearest_junction] = getLabelJC_v3(search_areas.backward, junctions_in_circle, locaCoords);
    %panos(p).backwardlabel = blabel;   
    descList(3) = blabel;
    
    %% Get Labels for junction topology
    % panos = getTopology(panos, dists, az, inters, ways); % add this function to BSD_extraction
    try
        if flabel == 1
            ftops = get_topology(locaCoords, wayIdx, roads, fnearest_junction);
        else
            ftops = 1; % no junction, straight
        end

        if blabel == 1
            btops = get_topology(locaCoords, wayIdx, roads, bnearest_junction);
        else
            btops = 1; % no junction, straight
        end
        topList(1) = ftops;
        topList(2) = btops;
        panos(p).TOPs = topList;
    catch
        disp(p);
        panos(p).TOPs = [];
        failed_tops{end+1, 1} = p;
        save('failed_tops.mat', 'failed_tops');  
    end

    
    %% Get Labels for gaps
    llabel = getLabelBD(search_areas.left, buildings_in_circle, locaCoords);
    %panos(p).leftlabel = llabel;
    descList(4) = llabel;
    rlabel = getLabelBD(search_areas.right, buildings_in_circle, locaCoords);
    %panos(p).rightlabel = rlabel;
    descList(2) = rlabel;
    descList(descList == 2) = 0;
    descList(descList == 3) = 0;
    panos(p).BSDs = descList;
    
    % inverse direction
    descList(1) = blabel;
    descList(2) = llabel;
    descList(3) = flabel;
    descList(4) = rlabel;
    descList(descList == 2) = 0;
    descList(descList == 3) = 0;
    panos(p).invBSDs = descList;
    
    parfor_progress('BSD extraction');
end

end