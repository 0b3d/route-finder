% test building gap extraction
location(1).coords = [51.461158, -2.604578]; % location struct
location(1).yaw = 251.84999;
locaCoords = cell2mat({location.coords}');
radius = 30; 
arclen = radius / (2*earthRadius*pi) * 360;
circle = zeros(72, 2);  % search area, every 5 degree
[circle(:,1), circle(:,2)] = scircle1(locaCoords(1),locaCoords(2),arclen,[],[],[],72);

% Searching buildings in this area
load('buildings.mat');
buildings_in_circle = [];
% use parfor for panos
for i=1:size(buildings,1)
    curcoord = buildings(i).coords;
        in = inpolygon(curcoord(:,1),curcoord(:,2),circle(:,1), circle(:,2));
        if(sum(in)) >= 1
            buildings_in_circle = [buildings_in_circle; buildings(i)];
        end
end

% Seperate to left and right parts for building gap
% circle_in_left
% circle_in_right
% Use az to determine if forward or backward
search_areas.forward = [];
search_areas.backward = [];
search_areas.left = [];
search_areas.right = [];
for i=1:size(circle, 1)
    [~,az] = distance(locaCoords(1), locaCoords(2), circle(i,1), circle(i,2));
    adjustedAZ = mod(location.yaw - az, 360);
    if(adjustedAZ > 45 && adjustedAZ < 135)
        search_areas.left = [search_areas.left; circle(i,:)];
    elseif(adjustedAZ > 135 && adjustedAZ < 225)
        search_areas.backward = [search_areas.backward; circle(i,:)];   
    elseif(adjustedAZ > 225 && adjustedAZ < 315)
        search_areas.right = [search_areas.right; circle(i,:)];  
    else
        search_areas.forward = [search_areas.forward; circle(i,:)];  
    end
end

% display test
%display_test(locaCoords, radius, buildings_in_circle, search_areas);

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


% display test
%display_test(locaCoords, radius, buildings_in_circle, search_areas, left_buildings_inter, right_buildings_inter);




    

















