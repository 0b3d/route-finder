function [label, record] = getLabelBD_v2(search_areas, buildings_in_circle, locaCoords, id, flag)  
distBD = [];
cutList = [];
record.id = [];
record.flag = [];
record.dist = [];
inters = [];

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
        minInter = [-99 -99];
        minBD = -99;   
    end
    inters = [inters; minInter];

    if minBD ~= -99
        dist_arc = distance(minInter(1), minInter(2),locaCoords(1),locaCoords(2));
        dist = dist_arc / 360 * (2*earthRadius*pi);
        distBD = [distBD dist];
        cutList = [cutList minBD];
    else
        distBD = [distBD 100];
        cutList = [cutList 0];
    end        
end

% Label
zerL = size(find(cutList == 0), 2);
findGap = 0;

if ~isempty(find(zerL > 0))
    findGap = 1;
else
    distBD = distBD - ones(1,size(distBD,2))*min(distBD);
    pks = findpeaks(distBD);
    if ~isempty(pks) && max(pks) >= 5
        findGap = 1;
        record.id = id;
        record.flag = flag;
        record.dist = max(pks);
        record.inters = inters;
    end
%     for i=1:size(distBD, 2)-1 
%         dist_diff = abs(distBD(i+1) - distBD(i));
%         if dist_diff >= 5 % 5 meter
%             change = change+1;
%             if change
%             findGap = 1;
%             record.id = id;
%             record.flag = flag;
%             record.dist = dist_diff;
%             record.inters = inters;
%             break;
%         end
%     end

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