function [] = display_map(ways, inters, buildings, boundary, mode)

% minlat="51.4563000" minlon="-2.6138000" maxlat="51.4641000" maxlon="-2.5939000"
% roads
for i=1:size(ways,1)
    if mode == 1
        curway = ways(i).coords;
    else
        curway = ways(i).dense_coords;
    end
    %figure(1)
    %plot(curway(:,2),curway(:,1),'-k',curway(:,2),curway(:,1),'*b');
    plot(curway(:,2),curway(:,1),'-k');
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

% inters
if mode == 1
    intersections = cell2mat({inters.coords}');
    for i=1:size(intersections,1)
        curinter = intersections(i,:);
        plot(curinter(2),curinter(1),'*r','LineWidth',2);
        hold on;
    end
else
    for i=1:size(ways, 1)
        for j=1:size(ways(i).dense_coords, 1)
            curinter = ways(i).dense_coords(j,:);
            ifinter = ways(i).inters(j);  
            if ifinter == true
                plot(curinter(2),curinter(1),'*r','LineWidth',2);
                hold on;
            end
        end
    end
end       
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

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