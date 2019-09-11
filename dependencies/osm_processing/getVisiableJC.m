function junctions_in_circle = getVisiableJC(junctions, buildings_in_circle, locaCoords)
junctions_in_circle = [];
flag = 0;
for i=1:size(junctions, 1)
    curjunction = junctions(i).coords;
    for j=1:size(buildings_in_circle, 1)
        curbuilding = buildings_in_circle(j).coords;
        [inter_x, inter_y] = polyxpoly([curjunction(1), locaCoords(1)], [curjunction(2), locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
        if size(inter_x, 1) > 0
            flag = 1; % current junction is blocked by a building
            break;
        end
    end    
    if flag == 0
        junctions_in_circle = [junctions_in_circle; junctions(i)];
    end
end

end