function [] = display_inters(inters, boundary)
% inters
intersections = cell2mat({inters.coords}');
for i=1:length(intersections)
    curinter = intersections(i,:);
    plot(curinter(2),curinter(1),'*r','LineWidth',2);
    % text(curinter(2),curinter(1),num2str(inters(i).type));
    hold on;
end      
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

end