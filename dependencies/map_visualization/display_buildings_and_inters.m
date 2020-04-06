function [] = display_buildings_and_inters(buildings, inters)
% buildings
if ~isempty(buildings)
    for i=1:size(buildings, 1)
        curbuild = buildings(i).coords;
        plot(curbuild(:,2),curbuild(:,1),'-m');    
        hold on;
    end
end

% inters
if ~isempty(inters)
    intersections = cell2mat({inters.coords}');
    for i=1:size(intersections,1)
        curinter = intersections(i,:);
        plot(curinter(2),curinter(1),'*r','LineWidth',2);
        hold on;
    end
end
end  



