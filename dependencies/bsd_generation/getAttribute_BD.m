function [zerL, d_min, dist_diff] = getAttribute_BD(search_areas, buildings_in_circle, locaCoords, radius)  
distBD = [];
cutList = [];

% plot buildings
% for i=1:size(buildings_in_circle,1)     
%     curbuilding = buildings_in_circle(i).coords;
%     plot(curbuilding(:,2),curbuilding(:,1),'-m');
%     hold on
% end

for i=1:size(search_areas, 1)
    candidates = [];
    csize = 1;
    curline_x = search_areas(i,1);
    curline_y = search_areas(i,2);
    % plot rays
    % plot(locaCoords(2),locaCoords(1),'*r');
    % plot([curline_y, locaCoords(2)],[curline_x, locaCoords(1)],'-b');
    % hold on
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
        % plot inters
        % plot(minInter(2),minInter(1),'*r');
        % hold on
    else
        minInter = [curline_x curline_y];
        minBD = -99;   
    end
    
    if minBD ~= -99
        dist_arc = distance(minInter(1), minInter(2),locaCoords(1),locaCoords(2));
        dist = dist_arc / 360 * (2*earthRadius*pi);
        distBD = [distBD dist];
        cutList = [cutList minBD];
    else
        distBD = [distBD radius]; % radius
        cutList = [cutList 0];
    end        
end

% Label
tmp = [diff(find(cutList == 0)) 2];
zerL = diff([0 find(tmp~=1)]);

d_min = [];
dist_diff = [];
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
        d_min_tmp = poly_poly_dist(xv1, yv1, xv2, yv2);       
        if d_min_tmp > 0 % no intersections
            d_min = [d_min, d_min_tmp];
            dist_diff_tmp = abs(distBD(i) - distBD(i+1));
            dist_diff = [dist_diff, dist_diff_tmp];
        end
    end
end
              
end