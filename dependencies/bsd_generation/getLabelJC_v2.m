function label = getLabelJC_v2(search_areas, junctions_in_circle, locaCoords)
Area = [locaCoords; search_areas; locaCoords];
plot(Area(:,2),Area(:,1),'-m');
JC = [];
distJC = [];
for i=1:size(junctions_in_circle, 1)
    curjuction = junctions_in_circle(i).coords;
    [in, on] = inpolygon(curjuction(1), curjuction(2),Area(:,1), Area(:,2));
    if in == 1 || on == 1
        JC = [JC; curjuction];
        dist_arc = distance(curjuction(1), curjuction(2),locaCoords(1),locaCoords(2));
        dist = dist_arc / 360 * (2*earthRadius*pi);
        distJC = [distJC; dist];
    end    
end

nearestJC = round(min(distJC));

if ~isempty(nearestJC)
    if nearestJC <= 30 && nearestJC >=1
        label = 1;
    elseif nearestJC > 30   % too far
        label = 2;
    else                    % too close
        label = 3;
    end
else
    label = 2;
end

end