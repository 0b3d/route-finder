% check sparse map
load('london_BSD_2degree_small_75.mat');
load('test_route_small_500.mat');
load('ways.mat');load('naturals.mat');load('leisures.mat');
load('buildings.mat');load('boundary.mat');
display_map_v3(ways, buildings, naturals, leisures, boundary);
% 
% for i=8%size(test_route,1)
%     for j=1:size(test_route,2)
%         curpoint = routes(test_route(i,j)).coords;
%         plot(curpoint(2), curpoint(1),'*r');
%         hold on;
%     end    
% end

for i=1:length(routes)
    curpoint = routes(i).coords;
    plot(curpoint(2), curpoint(1),'*r'); 
end