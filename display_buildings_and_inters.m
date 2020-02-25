function [] = display_buildings_and_inters(buildings, inters)
% buildings
for i=1:length(buildings)
    curbuild = buildings(i).coords;
    plot(curbuild(:,2),curbuild(:,1),'-m');    
    hold on;
end

% inters
intersections = cell2mat({inters.coords}');
for i=1:length(intersections)
    curinter = intersections(i,:);
    plot(curinter(2),curinter(1),'*r','LineWidth',2);
    hold on;
end
end  



