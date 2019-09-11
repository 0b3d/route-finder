function [] = display_searchcircles(location, yaw, radius)
% show single position
%figure(1)
plot(location(2),location(1),'*r');

% show search circle
arclen = radius / (2*earthRadius*pi) * 360;
circle = zeros(72, 2);
[circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],72);
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
    %figure(1)
    plot([location(2) search_areas.forward(i, 2)],[location(1) search_areas.forward(i, 1)],'-k');
    hold on;
end

% for i=1:size(search_areas.backward, 1)
%     %figure(1)
%     plot([location(2) search_areas.backward(i, 2)],[location(1) search_areas.backward(i, 1)],'-m');
%     hold on;
% end
% 
% for i=1:size(search_areas.left, 1)
%     %figure(1)
%     plot([location(2) search_areas.left(i, 2)],[location(1) search_areas.left(i, 1)],'-b');
%     hold on;
% end
% 
% for i=1:size(search_areas.right, 1)
%     %figure(1)
%     plot([location(2) search_areas.right(i, 2)],[location(1) search_areas.right(i, 1)],'-g');
%     hold on;
% end
    
end
