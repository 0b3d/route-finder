function [] = display_map_v3(ways, buildings, naturals, leisures, boundary)
% roads
for i=1:length(ways)
    curway = ways(i).coords;
    plot(curway(:,2),curway(:,1),'Color',[0.5, 0.5, 0.5], 'LineWidth', 2);
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])



% buildings
for i=1:length(buildings)
    curbuild = buildings(i).coords;
    plot(curbuild(:,2),curbuild(:,1),'-m');
    hold on;
end
axis([boundary(2) boundary(4) boundary(1) boundary(3)])

% % leisures
% for i=1:length(leisures)
%     curlei = leisures(i).coords;
%     % plot(curlei(:,2),curlei(:,1),'g');
%     % plot(curlei(:,2),curlei(:,1),'MarkerFaceColor','g');
%     fill(curlei(:,2),curlei(:,1),'g');
%     hold on;
% end
% axis([boundary(2) boundary(4) boundary(1) boundary(3)])
% 
% % naturals
% for i=1:length(naturals)
%     curnat = naturals(i).coords;
%     type = naturals(i).natural_type;
%     if strcmp(type, 'water')
%         fill(curnat(:,2),curnat(:,1),'b');
%         % plot(curnat(:,2),curnat(:,1),'MarkerFaceColor','b');
%     else
%         fill(curnat(:,2),curnat(:,1),'g');
%         % plot(curnat(:,2),curnat(:,1),'MarkerFaceColor','g');
%     end
%     hold on;
% end
% axis([boundary(2) boundary(4) boundary(1) boundary(3)])


end
