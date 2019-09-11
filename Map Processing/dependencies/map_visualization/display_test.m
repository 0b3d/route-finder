function [] = display_test(location, radius, buildings_in_circle, search_areas, left_buildings_inter, right_buildings_inter)
% test 1 
% Yam's Code
% pos = [51.461158, -2.604578];
% load('osm.mat');
% displayOSMinit_spec(osmelem,pos)

% test ways and intersections
load('ways.mat')
load('inters.mat')
% minlat="51.4563000" minlon="-2.6138000" maxlat="51.4641000" maxlon="-2.5939000"
for i=1:size(ways,1)
    curway = ways(i).coords;
    figure(1)
    %plot(curway(:,2),curway(:,1),'-k',curway(:,2),curway(:,1),'*b');
    plot(curway(:,2),curway(:,1),'-k');
    hold on;
end
axis([-2.6138000 -2.5939000 51.4563000 51.4641000])
% 
% intersections = cell2mat({inters.coords}');
% for i=1:size(intersections,1)
%     curinter = intersections(i,:);
%     plot(curinter(2),curinter(1),'*r','LineWidth',2);
%     hold on;
% end
% axis([-2.6138000 -2.5939000 51.4563000 51.4641000])
% 
% load('panos.mat');
% pano = cell2mat({panos.coords}');
% for i=1:20
%     curpano = pano(i,:);
%     text(curpano(2)+0.00003,curpano(1)+0.00001,num2str(i));
%     plot(curpano(2),curpano(1),'*k','LineWidth',2);
%     hold on;
% end
% axis([-2.6138000 -2.5939000 51.4563000 51.4641000])

% test buildings and gaps
load('buildings.mat')
load('ngaps.mat')
for i=1:size(buildings, 1)
    curbuild = buildings(i).coords;
    figure(1)
    %plot(curbuild(:,2),curbuild(:,1),'-k',curbuild(:,2),curbuild(:,1),'xb');
    plot(curbuild(:,2),curbuild(:,1),'-b');
    hold on;
end
axis([-2.6138000 -2.5939000 51.4563000 51.4641000])

% nongaps = cell2mat({ngaps.coords}');
% for i=1:size(nongaps,1)
%     curngap= nongaps(i,:);
%     plot(curngap(2),curngap(1),'*r','LineWidth',2);
%     hold on;
% end
% axis([-2.6138000 -2.5939000 51.4563000 51.4641000])

% show single position
figure(1)
plot(location(2),location(1),'*r');

% show search circle
arclen = radius / (2*earthRadius*pi) * 360;
circle = zeros(360, 2);
[circle(:,1), circle(:,2)] = scircle1(location(1),location(2),arclen,[],[],[],360);
plot(circle(:,2), circle(:,1),'-r'); % plotm, plot a map

% show buildings in search circle
for i=1:size(buildings_in_circle, 1) % 2 or 1
    curbuild = buildings_in_circle(i).coords;
    figure(1)
    %plot(curbuild(:,2),curbuild(:,1),'-k',curbuild(:,2),curbuild(:,1),'xb');
    plot(curbuild(:,2),curbuild(:,1),'-m');
    hold on;
end
axis([-2.6138000 -2.5939000 51.4563000 51.4641000])

% show search areas in four directions
for i=1:size(search_areas.forward, 1)
    figure(1)
    plot([location(2) search_areas.forward(i, 2)],[location(1) search_areas.forward(i, 1)],'-k');
    hold on;
end

for i=1:size(search_areas.backward, 1)
    figure(1)
    plot([location(2) search_areas.backward(i, 2)],[location(1) search_areas.backward(i, 1)],'-m');
    hold on;
end

for i=1:size(search_areas.left, 1)
    figure(1)
    plot([location(2) search_areas.left(i, 2)],[location(1) search_areas.left(i, 1)],'-b');
    hold on;
end

for i=1:size(search_areas.right, 1)
    figure(1)
    plot([location(2) search_areas.right(i, 2)],[location(1) search_areas.right(i, 1)],'-g');
    hold on;
end

% building intersections test
for i=1:size(left_buildings_inter,1)
    for j=1:size(left_buildings_inter,2)
        left_inters = left_buildings_inter{i,j};
        if size(left_inters, 1) > 0
            left_inters_mat = cell2mat(left_inters);
            figure(1)
            plot(left_inters_mat(:,2),left_inters_mat(:,1),'*r');
            hold on
        end
    end 
end

for i=1:size(right_buildings_inter,1)
    for j=1:size(right_buildings_inter,2)
        right_inters = right_buildings_inter{i,j};
        if size(right_inters, 1) > 0
            right_inters_mat = cell2mat(right_inters);
            figure(1)
            plot(right_inters_mat(:,2),right_inters_mat(:,1),'*b');
            hold on
        end
    end 
end

end