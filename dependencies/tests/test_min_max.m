% test the minimum and maximum coordinates    
load('routes_small_withBSD.mat'); % descriptors
location = routes(10).gsv_coords;
arclen = 60 / (2*earthRadius*pi) * 360;
[circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],4);
bounary(1) = min(circle(:,1));
boundary(3) = max(circle(:,1));
bounary(2) = min(circle(:,2));
boundary(4) = max(circle(:,2));

