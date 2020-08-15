function new_buildings = buildings_filter(buildings)
% multiple tags would cause empty buildings
count = 1;
for i=1:length(buildings)
    if ~isempty(buildings(i).coords)
        new_buildings(count).coords = buildings(i).coords;
        new_buildings(count).building_type = buildings(i).building_type;
        count = count+1;
    end
end
end