function [] = display_map_v4(ways, buildings, naturals, leisures, boundary)

range = [boundary(1), boundary(4); boundary(3), boundary(4); boundary(3), boundary(2);boundary(1), boundary(2)];

% roads
for i=1:length(ways)
    curway = ways(i).coords;
    in = inpolygon(curway(:,1),curway(:,2),range(:,1), range(:,2));    
    if(sum(in)) >= 1
       plot(curway(:,2),curway(:,1),'Color',[0.5, 0.5, 0.5], 'LineWidth', 2);
    end
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

% buildings
for i=1:length(buildings)
    curbuild = buildings(i).coords;
    in = inpolygon(curbuild(:,1),curbuild(:,2),range(:,1), range(:,2));    
    if(sum(in)) >= 1 && size(curbuild, 1) > 2
       plot(curbuild(:,2),curbuild(:,1),'-m');
    end
    
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

% leisures
for i=1:length(leisures)
    curlei = leisures(i).coords;
    in = inpolygon(curlei(:,1),curlei(:,2),range(:,1), range(:,2));    
    if(sum(in)) >= 1 && size(curlei, 1) > 2
       fill(curlei(:,2),curlei(:,1),'g');
    end
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

% naturals
for i=1:length(naturals)
    curnat = naturals(i).coords;
    type = naturals(i).natural_type;
    in = inpolygon(curnat(:,1),curnat(:,2),range(:,1), range(:,2));    
    if(sum(in)) >= 1 && size(curnat, 1) > 2
        if strcmp(type, 'water')
            fill(curnat(:,2),curnat(:,1),'b');
            plot(curnat(:,2),curnat(:,1),'MarkerFaceColor','b');
        else
            fill(curnat(:,2),curnat(:,1),'g');
            plot(curnat(:,2),curnat(:,1),'MarkerFaceColor','g');
        end
    end
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])


end
