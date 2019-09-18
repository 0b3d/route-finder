% test size of the area
clear all;
parameters;
boundary = csvread(['Data/',dataset,'/boundary.txt']);
location1 = [boundary(1), boundary(2)];
location2 = [boundary(1), boundary(4)];
location3 = [boundary(3), boundary(2)];
location4 = [boundary(3), boundary(4)];

width = distance(location1, location3);  % arclen
height = distance(location1, location2); % arclen

width = width / 360 * (2*earthRadius*pi) / 1000;  % km
height = height / 360 * (2*earthRadius*pi) / 1000; % km


%width2 = haversine(location1(1), location1(2), location3(1), location3(2))/1000;
%height2 = haversine(location1(1), location1(2), location2(1), location2(2))/1000;


