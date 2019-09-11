% Histogram
clear all
load('london_center_z20_model2.mat');
load('test_route_london_center.mat');
load('test_turn_london_center.mat');

% t = test_route(8,:);
% T = test_turn(8,:);
% 
% % parameters
% threshold = 60; % Turn
% max_route_length = 20;
% N = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,...
%     100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];    
% overlap = 0.8;
% s_number = 5;
% 
% R_init = zeros(size(routes,2),1);
% for i = 1:size(routes,2)
%     R_init(i) = i;   
% end
% 
% [~, ~, ~, ~, dist_withoutT] = RouteSearching_withoutT(routes, N, max_route_length, R_init, t, overlap, s_number);
% [~, ~, ~, ~, dist_withT] = RouteSearching_withT(routes, N, max_route_length, R_init, t, T, overlap, s_number, threshold);
load('dist_withT_20.mat');
load('dist_withoutT_20.mat');

% figure(1)
% plot(dist_withT,'b');
% % axis([1 100 dist_withT(1) dist_withT(100)]);
% hold on
% 
% plot(dist_withoutT,'r');
% axis([1 50 dist_withT(1) dist_withoutT(50)]);

% save csv for display
filename = '20length_withT_all.csv';
fid = fopen(filename, 'w');  
for i=1:length(dist_withT)
    a1 = dist_withT(i);
    fprintf(fid, ['%.15f','\n'], a1);    
end
fclose(fid);

