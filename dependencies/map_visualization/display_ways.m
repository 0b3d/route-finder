function [] = display_ways(ways, boundary)
% roads
for i=1:size(ways,1)
    curway = ways(i).coords;
    %figure(1)
    %plot(curway(:,2),curway(:,1),'-k',curway(:,2),curway(:,1),'*b');
    plot(curway(:,2),curway(:,1),'-k');
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

end