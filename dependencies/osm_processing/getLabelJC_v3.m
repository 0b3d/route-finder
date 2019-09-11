function [label, nearest_junction] = getLabelJC_v3(search_areas, junctions_in_circle, locaCoords)

Area = [search_areas; locaCoords];
JC = [];
distJC = [];
idx = [];

for i=1:size(junctions_in_circle)
    curjuction = junctions_in_circle(i).coords;
    [in, on] = inpolygon(curjuction(1), curjuction(2),Area(:,1), Area(:,2));
    if in == 1 || on == 1
        JC = [JC; curjuction];
        idx = [idx; i];
        dist_arc = distance(curjuction(1), curjuction(2),locaCoords(1),locaCoords(2));
        % arclen = radius / (2*earthRadius*pi) * 360;
        dist = dist_arc / 360 * (2*earthRadius*pi);
        distJC = [distJC; dist];
    end    
end

% nearestJC = round(min(distJC));
[a, i] = min(distJC);
nearestJC = round(a);
nearest_junction = junctions_in_circle(idx(i));

if ~isempty(nearestJC)
    if nearestJC <= 30 && nearestJC >=1
        label = 1;
    elseif nearestJC > 30
        label = 2;
    else
        label = 3;
    end
else
    label = 2;
end

end