function [] = display_searchcircles(location, yaw, radius, BSD, range)
% show single position
plot(location(2),location(1),'*r');

% show search circle
arclen = radius / (2*earthRadius*pi) * 360;
c_num = 360/range;
% circle = zeros(c_num, 2);
% [circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[yaw, yaw+360],[],[],c_num);
% plot(circle(:,2), circle(:,1),'-r'); % plot a map

% search directions
search_areas.forward = [];
search_areas.backward = [];
search_areas.left = [];
search_areas.right = [];
[search_areas.forward(:,1), search_areas.forward(:,2)] = scircle1(location(1),location(2),arclen, [yaw-45, yaw+45],[],[],90/range);
[search_areas.right(:,1), search_areas.right(:,2)] = scircle1(location(1),location(2),arclen, [yaw+45, yaw+135],[],[],90/range);
[search_areas.backward(:,1), search_areas.backward(:,2)] = scircle1(location(1),location(2),arclen, [yaw+135, yaw+225],[],[],90/range);
[search_areas.left(:,1), search_areas.left(:,2)] = scircle1(location(1),location(2),arclen, [yaw+225, yaw+315],[],[],90/range);

% show search areas in four directions
for i=1:size(search_areas.forward, 1)
    plot([location(2) search_areas.forward(i, 2)],[location(1) search_areas.forward(i, 1)],'-k');
    text(search_areas.forward(floor(c_num/4/2), 2),search_areas.forward(floor(c_num/4/2), 1),num2str(BSD(1)));
    text(search_areas.forward(floor(c_num/4/2+3), 2),search_areas.forward(floor(c_num/4/2+3), 1),'front');
    hold on;
end

for i=1:size(search_areas.backward, 1)
    plot([location(2) search_areas.backward(i, 2)],[location(1) search_areas.backward(i, 1)],'-m');
    text(search_areas.backward(floor(c_num/4/2), 2),search_areas.backward(floor(c_num/4/2), 1),num2str(BSD(3)));
    text(search_areas.backward(floor(c_num/4/2+3), 2),search_areas.backward(floor(c_num/4/2+3), 1),'back');
    hold on;
end

for i=1:size(search_areas.left, 1)
    plot([location(2) search_areas.left(i, 2)],[location(1) search_areas.left(i, 1)],'-b');
    text(search_areas.left(floor(c_num/4/2), 2),search_areas.left(floor(c_num/4/2), 1),num2str(BSD(4)));
    text(search_areas.left(floor(c_num/4/2+3), 2),search_areas.left(floor(c_num/4/2+3), 1),'left');
    hold on;
end

for i=1:size(search_areas.right, 1)
    plot([location(2) search_areas.right(i, 2)],[location(1) search_areas.right(i, 1)],'-g');
    text(search_areas.right(floor(c_num/4/2), 2),search_areas.right(floor(c_num/4/2), 1),num2str(BSD(2)));
    text(search_areas.right(floor(c_num/4/2+3), 2),search_areas.right(floor(c_num/4/2+3), 1),'right');
    hold on;
end
    
end
