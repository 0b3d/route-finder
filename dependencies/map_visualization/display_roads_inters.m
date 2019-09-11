function [] = display_roads_inters(ways, boundary)
% roads and inters
for i=1:size(ways, 1)
    curway = ways(i).dense_coords;
    plot(curway(:,2),curway(:,1),'-k',curway(:,2),curway(:,1),'*b');
    hold on;
    for j=1:size(curway, 1)
        curinter = ways(i).dense_coords(j,:);
        ifinter = ways(i).inters(j);  
        if ifinter == true
            plot(curinter(2),curinter(1),'*r','LineWidth',2);
            hold on;
        end
    end
end     
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

end
