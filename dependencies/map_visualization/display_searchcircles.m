function [] = display_searchcircles(location, yaw, radius, BSD)
% show single position
plot(location(2),location(1),'*r');

% show search circle
arclen = radius / (2*earthRadius*pi) * 360;
circle = zeros(180, 2);
[circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],180);
plot(circle(:,2), circle(:,1),'-r'); % plotm, plot a map

% search directions
search_areas.forward = [];
search_areas.backward = [];
search_areas.left = [];
search_areas.right = [];
for i=1:size(circle, 1)
    [~,az] = distance(location(1), location(2), circle(i,1), circle(i,2));
    adjustedAZ = mod(yaw - az, 360);
    if(adjustedAZ > 45 && adjustedAZ < 135)
        search_areas.left = [search_areas.left; circle(i,:)];
    elseif(adjustedAZ > 135 && adjustedAZ < 225)
        search_areas.backward = [search_areas.backward; circle(i,:)];   
    elseif(adjustedAZ > 225 && adjustedAZ < 315)
        search_areas.right = [search_areas.right; circle(i,:)];  
    else
        search_areas.forward = [search_areas.forward; circle(i,:)];  
    end
end

% show search areas in four directions
for i=1:size(search_areas.forward, 1)
    plot([location(2) search_areas.forward(i, 2)],[location(1) search_areas.forward(i, 1)],'-k');
    text(search_areas.forward(22, 2),search_areas.forward(22, 1),num2str(BSD(1)));
    text(search_areas.forward(15, 2),search_areas.forward(15, 1),'front');
    hold on;
end

for i=1:size(search_areas.backward, 1)
    plot([location(2) search_areas.backward(i, 2)],[location(1) search_areas.backward(i, 1)],'-m');
    text(search_areas.backward(22, 2),search_areas.backward(22, 1),num2str(BSD(3)));
    text(search_areas.backward(15, 2),search_areas.backward(15, 1),'back');
    hold on;
end

for i=1:size(search_areas.left, 1)
    plot([location(2) search_areas.left(i, 2)],[location(1) search_areas.left(i, 1)],'-b');
    text(search_areas.left(22, 2),search_areas.left(22, 1),num2str(BSD(4)));
    text(search_areas.left(15, 2),search_areas.left(15, 1),'left');
    hold on;
end

for i=1:size(search_areas.right, 1)
    plot([location(2) search_areas.right(i, 2)],[location(1) search_areas.right(i, 1)],'-g');
    text(search_areas.right(22, 2),search_areas.right(22, 1),num2str(BSD(2)));
    text(search_areas.right(15, 2),search_areas.right(15, 1),'right');
    hold on;
end
    
end
