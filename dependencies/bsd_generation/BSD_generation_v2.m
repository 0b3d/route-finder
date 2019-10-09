function [panos, RRecord] = BSD_generation_v2(panos, inters, buildings, radius, range)

arclen = radius / (2*earthRadius*pi) * 360;  
RRecord = struct();
init = 1;

parfor_progress('BSD extraction', size(panos,2));
for p=1:size(panos, 2)
    locaCoords = cell2mat({panos(p).gsv_coords}');
    yaw = panos(p).gsv_yaw;
    id = panos(p).id;
   
    if isempty(locaCoords) || isempty(yaw)
        continue;
    end    
    
    %% Find buildings in search area
    circle = zeros(360/range, 2);  % search area, every 5 degree
    [circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [],[],[],360/range);
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
    [search_areas.forward(:,1), search_areas.forward(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw-45, yaw+45],[],[],90/range);
    [search_areas.right(:,1), search_areas.right(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw+45, yaw+135],[],[],90/range);
    [search_areas.backward(:,1), search_areas.backward(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw+135, yaw+225],[],[],90/range);
    [search_areas.left(:,1), search_areas.left(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen, [yaw+225, yaw+315],[],[],90/range);

%     [x, y] = scircle1(locaCoords(1),locaCoords(2),arclen, yaw,[],[],1);
%     plot([y, locaCoords(2)],[x,locaCoords(1)],'-r');
%     hold on
%     plot([search_areas.forward(:,2);locaCoords(2)], [search_areas.forward(:,1) ;locaCoords(1)],'-k');
%     plot([search_areas.right(:,2) ;locaCoords(2)], [search_areas.right(:,1) ;locaCoords(1)],'-m');
%     plot([search_areas.backward(:,2) ;locaCoords(2)], [search_areas.backward(:,1) ;locaCoords(1)],'-g');
%     plot([search_areas.left(:,2); locaCoords(2)], [search_areas.left(:,1) ;locaCoords(1)],'-b');
% %     
%     
    
%     for i=1:size(circle, 1)
%         az = azimuth(locaCoords(1), locaCoords(2), circle(i,1), circle(i,2));
%         adjustedAZ = mod(yaw - az, 360);
%         % each part occupies 90 degree
%         if(adjustedAZ >= 45 && adjustedAZ < 135)
%             search_areas.left = [search_areas.left; circle(i,:)];
%         elseif(adjustedAZ >= 135 && adjustedAZ < 225)
%             search_areas.backward = [search_areas.backward; circle(i,:)];   
%         elseif(adjustedAZ >= 225 && adjustedAZ < 315)
%             search_areas.right = [search_areas.right; circle(i,:)];  
%         else
%             search_areas.forward = [search_areas.forward; circle(i,:)];  
%         end        
%     end
    
    
    
    %% Get Labels for junctions
    descList = zeros(1, 4);
    flabel = getLabelJC_v2(search_areas.forward, junctions_in_circle, locaCoords);
    descList(1) = flabel;
    
    blabel = getLabelJC_v2(search_areas.backward, junctions_in_circle, locaCoords);  
    descList(3) = blabel;
    
    %% Get Labels for gaps
    % [llabel, record] = getLabelBD(search_areas.left, buildings_in_circle, locaCoords, id, 1);
    % [llabel, record] = getLabelBD_v2(search_areas.left, buildings_in_circle, locaCoords, id, 1);
    [llabel, record] = getLabelBD_v3(search_areas.left, buildings_in_circle, locaCoords, id, 1);

    descList(4) = llabel;
    if ~isempty(record.id)
        RRecord(init).idx = p;
        RRecord(init).id = record.id;
        RRecord(init).flag = record.flag;
        RRecord(init).dist = record.dist; 
        RRecord(init).inters = record.inters;
        init = init + 1;
    end
        
    [rlabel, record] = getLabelBD_v3(search_areas.right, buildings_in_circle, locaCoords, id, 2);
    descList(2) = rlabel;
    if ~isempty(record.id)
        RRecord(init).id = record.id;
        RRecord(init).idx = p;
        RRecord(init).flag = record.flag;
        RRecord(init).dist = record.dist;
        RRecord(init).inters = record.inters;
        init = init + 1;
    end
    
    descList(descList == 2) = 0;
    descList(descList == 3) = 0;
    panos(p).BSDs = descList;
    
    parfor_progress('BSD extraction');
end
end