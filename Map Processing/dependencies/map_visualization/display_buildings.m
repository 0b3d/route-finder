function [] = display_buildings(buildings, boundary)
% buildings
for i=1:size(buildings, 1)
    curbuild = buildings(i).coords;
    %figure(1)
    %plot(curbuild(:,2),curbuild(:,1),'-k',curbuild(:,2),curbuild(:,1),'xb');
    plot(curbuild(:,2),curbuild(:,1),'-b');
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

end