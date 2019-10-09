function [label, record] = getLabelBD_v3(search_areas, buildings_in_circle, locaCoords, id, flag)  
distBD = [];
cutList = [];
record.id = [];
record.flag = [];
record.dist = [];
inters = [];

% check buildings in circle
for i=1:size(buildings_in_circle,1) 
    curbuild = buildings_in_circle(i).coords;
    plot(curbuild(:,2),curbuild(:,1),'-m');
    text(curbuild(1,2),curbuild(1,1),num2str(i));
    hold on;
end


for i=1:size(search_areas, 1)
    candidates = [];
    csize = 1;
    curline_x = search_areas(i,1);
    curline_y = search_areas(i,2);
    for j=1:size(buildings_in_circle,1)     
        curbuilding = buildings_in_circle(j).coords;
        [inter_x, inter_y] = polyxpoly([curline_x, locaCoords(1)], [curline_y, locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
        dist = [];
        if size(inter_x) > 0
            for k=1:size(inter_x, 1)
                dist_arc = distance(inter_x(k), inter_y(k),locaCoords(1),locaCoords(2));
                dist(k) = dist_arc / 360 * (2*earthRadius*pi); % meter
            end
            [dist_new, index] = sort(dist);
            candidates(1,csize) = inter_x(index(1)); % x
            candidates(2,csize) = inter_y(index(1)); % y
            candidates(3,csize) = dist_new(1); % minimum distance
            candidates(4,csize) = j; % which building?
            csize = csize + 1;
        end        
    end  
    if size(candidates, 2) > 0
        eachmin = candidates(3,:);
        [~,index] = sort(eachmin);
        minInter = candidates(1:2,index(1));
        minInter = minInter';
        minBD = candidates(4,index(1));
    else
        % minInter = [-99 -99];
        minInter = [curline_x curline_y];
        minBD = -99;   
    end
    
%     % check inters
    inters = [inters; minInter];
    plot([locaCoords(2) inters(i,2)],[locaCoords(1) inters(i,1)],'-m');
    plot(inters(i,2), inters(i,1),'*r');

    if minBD ~= -99
        dist_arc = distance(minInter(1), minInter(2),locaCoords(1),locaCoords(2));
        dist = dist_arc / 360 * (2*earthRadius*pi);
        distBD = [distBD dist];
        cutList = [cutList minBD];
    else
        distBD = [distBD 35]; % radius
        cutList = [cutList 0];
    end        
end

% Label
tmp = [diff(find(cutList == 0)) 2];
zerL = diff([0 find(tmp~=1)]);
findGap = 0;

if ~isempty(find(zerL >= 3)) % 5 degree
    findGap = 1;
else
    cutList(cutList == 0) = [];
    for i=1:size(cutList, 2)-1
        cutbd1 = cutList(i);
        cutbd2 = cutList(i+1);
        if cutbd1 ~= cutbd2
            bd1 = buildings_in_circle(cutbd1).coords;
            bd2 = buildings_in_circle(cutbd2).coords;
            xv1 = bd1(:,1)';
            yv1 = bd1(:,2)';
            xv2 = bd2(:,1)';
            yv2 = bd2(:,2)';
            [d_min,lat_closest,lon_closest] = poly_poly_dist(xv1, yv1, xv2, yv2);
            if d_min > 0 % no intersections
                dist_arc = distance(lat_closest(1,1),lon_closest(1,1),lat_closest(1,2),lon_closest(1,2));
                dist = dist_arc / 360 * (2*earthRadius*pi);
                dist_diff = abs(distBD(i) - distBD(i+1));
                if dist_diff >= 5 % 5m
                    findGap = 1;                 
                    record.id = id;
                    record.flag = flag;
                    record.dist = dist_diff;
                    record.inters = inters;
                end
            end
        end
    end
end       

if findGap == 1
    label = 1;
else
    label = 2;
end

if zerL == size(cutList, 2) % no building
    label = 3;
end
       
end