function label = getLabelJC(Inter, buildings_in_circle, locaCoords)

tmp = isnan(Inter);
label = 1;
if tmp(1) == 0 && tmp(2) == 0
    for i=1:size(buildings_in_circle, 1)
        curbuilding = buildings_in_circle(i).coords;
        [inter_x, inter_y] = polyxpoly([Inter(1), locaCoords(1)], [Inter(2), locaCoords(2)], curbuilding(:,1),curbuilding(:,2));
        if size(inter_x) > 0
            label = 2;
            continue;
        end
    end
else 
    label = 2;
end

end