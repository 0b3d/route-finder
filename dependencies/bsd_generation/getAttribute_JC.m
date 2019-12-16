function nearestJC = getAttribute_JC(search_areas, junctions_in_circle, locaCoords)
Area = [locaCoords; search_areas; locaCoords];
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

nearestJC = min(distJC); %round(min(distJC))

end