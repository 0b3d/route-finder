function panos = getBuildingGap_v2(panos, buildings, arclen)

parfor_progress('building gaps', size(panos,1));
for p=1:size(panos, 1)
    locaCoords = cell2mat({panos(p).coords}');
    yaw = panos(p).yaw;
    
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
    rlabel = getLabelBD(search_areas.right, buildings_in_circle, locaCoords);
    panos(p).rightlabel = rlabel;
    
%     %% Right
%     rBD = [];
%     rdistBD = [];
%     rcutList = [];
%     for i=1:size(search_areas.right, 1)
%         candidates = [];
%         csize = 1;
%         for j=1:size(buildings_in_circle,1)     
%             curline_x = search_areas.right(i,1);
%             curline_y = search_areas.right(i,2);
%             curbuilding = buildings_in_circle(j).coords;
%             [inter_x, inter_y] = polyxpoly([curline_x, locaCoords(1)], [curline_y, locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
%             dist = [];
%             if size(inter_x) > 0
%                 for k=1:size(inter_x, 1)
%                     dist_arc = distance(inter_x(k), inter_y(k),locaCoords(1),locaCoords(2));
%                     % arclen = radius / (2*earthRadius*pi) * 360;
%                     dist(k) = dist_arc / 360 * (2*earthRadius*pi); % meter
%                 end
%                 [dist_new, index] = sort(dist);
%                 candidates(1,csize) = inter_x(index(1)); % x
%                 candidates(2,csize) = inter_y(index(1)); % y
%                 candidates(3,csize) = dist_new(1); % minimum distance
%                 candidates(4,csize) = j; % which building?
%                 csize = csize + 1;
%             end        
%         end  
%         if size(candidates, 2) > 0
%             eachmin = candidates(3,:);
%             [~,index] = sort(eachmin);
%             minInter = candidates(1:2,index(1));
%             minInter = minInter';
%             minBD = candidates(4,index(1));
%         else
%             minInter = [-99 -99];
%             minBD = -99;   
%         end   
%         
%         if minBD ~= -99
%             rBD = [rBD; minBD];
%             dist_arc = distance(minInter(1), minInter(2),locaCoords(1),locaCoords(2));
%             % arclen = radius / (2*earthRadius*pi) * 360;
%             dist = dist_arc / 360 * (2*earthRadius*pi);
%             rdistBD = [rdistBD; dist];
%             rcutList = [rcutList minBD];
%         else
%             rcutList = [rcutList 0];
%         end        
%     end
%     
%     % Label
%     rtmp = [diff(find(rcutList == 0)) 2];
%     rzerL = diff([0 find(rtmp~=1)]);
%     rzerLL = size(find(rcutList == 0), 2);
%     rfindGap = 0;
%            
%     if isempty(find(rzerL >=3 )) == 0
%         rfindGap = 1;
%     else
%         rcutList(rcutList == 0) = [];
%         for i=1:size(rcutList, 2)-1
%             cutbd1 = rcutList(i);
%             cutbd2 = rcutList(i+1);
%             if cutbd1 ~= cutbd2
%                 bd1 = buildings_in_circle(cutbd1).coords;
%                 bd2 = buildings_in_circle(cutbd2).coords;
%                 findInter = intersect(bd1, bd2, 'rows');
%                 if size(findInter, 1) == 0 % no intersections
%                     Poly1.x = bd1(:,1);
%                     Poly1.y = bd1(:,2);
%                     Poly2.x = bd2(:,1);
%                     Poly2.y = bd2(:,2);
%                     min_d = min_dist_between_two_polygons(Poly1,Poly2);
%                     if min_d >= 10*-5 && min_d~=0
%                         rfindGap = 1;
%                     end
%                 end
%             end
%         end       
%     end
%     
%     if rfindGap == 1
%         panos(p).rightlabel = 1;
%     else
%         panos(p).rightlabel = 2;
%     end
%     
%     if rzerLL == size(rcutList, 2)
%         panos(p).rightlabel = 3;
%     end
%     
%     %% Left
%     lBD = [];
%     ldistBD = [];
%     lcutList = [];
%     for i=1:size(search_areas.left, 1)
%         candidates = [];
%         csize = 1;
%         for j=1:size(buildings_in_circle,1)     
%             curline_x = search_areas.left(i,1);
%             curline_y = search_areas.left(i,2);
%             curbuilding = buildings_in_circle(j).coords;
%             [inter_x, inter_y] = polyxpoly([curline_x, locaCoords(1)], [curline_y, locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
%             dist = [];
%             if size(inter_x) > 0
%                 for k=1:size(inter_x, 1)
%                     dist_arc = distance(inter_x(k), inter_y(k),locaCoords(1),locaCoords(2));
%                     % arclen = radius / (2*earthRadius*pi) * 360;
%                     dist(k) = dist_arc / 360 * (2*earthRadius*pi); % meter
%                 end
%                 [dist_new, index] = sort(dist);
%                 candidates(1,csize) = inter_x(index(1)); % x
%                 candidates(2,csize) = inter_y(index(1)); % y
%                 candidates(3,csize) = dist_new(1); % minimum distance
%                 candidates(4,csize) = j; % which building?
%                 csize = csize + 1;
%             end        
%         end  
%         if size(candidates, 2) > 0
%             eachmin = candidates(3,:);
%             [~,index] = sort(eachmin);
%             minInter = candidates(1:2,index(1));
%             minInter = minInter';
%             minBD = candidates(4,index(1));
%         else
%             minInter = [-99 -99];
%             minBD = -99;   
%         end   
%         
%         if minBD ~= -99
%             lBD = [lBD; minBD];
%             dist_arc = distance(minInter(1), minInter(2),locaCoords(1),locaCoords(2));
%             % arclen = radius / (2*earthRadius*pi) * 360;
%             dist = dist_arc / 360 * (2*earthRadius*pi);
%             ldistBD = [ldistBD; dist];
%             lcutList = [lcutList minBD];
%         else
%             lcutList = [lcutList 0];
%         end        
%     end
%     
%     % Label
%     ltmp = [diff(find(lcutList == 0)) 2];
%     lzerL = diff([0 find(ltmp~=1)]);
%     lzerLL = size(find(lcutList == 0), 2);
%     lfindGap = 0;
%      
%     if isempty(find(lzerL >=3 )) == 0
%         lfindGap = 1;
%     else
%         lcutList(lcutList == 0) = [];
%         for i=1:size(lcutList, 2)-1
%             cutbd1 = lcutList(i);
%             cutbd2 = lcutList(i+1);
%             if cutbd1 ~= cutbd2
%                 bd1 = buildings_in_circle(cutbd1).coords;
%                 bd2 = buildings_in_circle(cutbd2).coords;
%                 findInter = intersect(bd1, bd2, 'rows');
%                 if size(findInter, 1) == 0 % no intersections
%                     Poly1.x = bd1(:,1);
%                     Poly1.y = bd1(:,2);
%                     Poly2.x = bd2(:,1);
%                     Poly2.y = bd2(:,2);
%                     min_d = min_dist_between_two_polygons(Poly1,Poly2);
%                     if min_d >= 10*-5 && min_d~=0
%                         lfindGap = 1;
%                     end
%                 end
%             end
%         end       
%     end
%     
%     if lfindGap == 1
%         panos(p).leftlabel = 1;
%     else
%         panos(p).leftlabel = 2;
%     end
%     
%     if lzerLL == size(lcutList, 2)
%         panos(p).leftlabel = 3;
%     end
           
    % ????
%     if (zerL > 5 && zerL ~= size(cutList,2)) || zerL == size(cutList, 2) % ALL ZERO
%        label = 3; %ERROR 
%     end

     
%     % no idea about this part's function?
%     [unqBD,~] = unique(BD,'rows');
%     minBD = zeros(1,size(unqBD,1));
%     meanBD = zeros(1,size(unqBD,1));
%     medBD = zeros(1,size(unqBD,1));
%     interNum = zeros(1,size(unqBD,1));
%     for k = 1:size(unqBD,1)
%         bdIndex = unqBD(k);
%         indx = find(BD == bdIndex);
%         minBD(k) = min(distBD(indx));
%         meanBD(k) = mean(distBD(indx));
%         medBD(k) = median(distBD(indx));
%         interNum(k) = size(find(BD == bdIndex),1);
%     end
   
    
    parfor_progress('building gaps');
end

end