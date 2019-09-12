% Histogram
clear all
load('london_BSD_80.mat');
load('test_route_manually_2.mat');
load('test_turn_manually_2.mat');

t = test_route(13,:);
T = test_turn(13,:);

% parameters
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
% [~, ~, ~, ~, dist_withoutT] = RouteSearching_BSD_withoutT_new(routes, N, max_route_length, R_init, t, overlap, s_number);
% [~, ~, ~, ~, dist_withT] = RouteSearching_BSD_withT_new(routes, N, max_route_length, R_init, t, T, overlap, s_number, threshold);

% figure(1)
% plot(dist_withT,'b');
% % axis([1 100 dist_withT(1) dist_withT(100)]);
% hold on
% 
% plot(dist_withoutT,'r');
% axis([1 50 dist_withT(1) dist_withoutT(50)]);

% save csv for display
% load('BSD_20.mat');
% load('BSD_T_20.mat');
% filename = 'BSD_T_20.csv';
% fid = fopen(filename, 'w');  
% for i=1:length(dist_withT)
%     a1 = dist_withT(i);
%     fprintf(fid, ['%.15f','\n'], a1);    
% end
% fclose(fid);

% display histogram
load('BSD_T_5.mat');
dist_withT_new = [];
for i=1:length(dist_withT)
    if dist_withT(i) >= 1000
        continue;
    else
        dist_withT_new = [dist_withT_new;dist_withT(i)];
    end   
end

max = max(dist_withT_new);
min = min(dist_withT_new);
statistic = zeros(1,max);

for i=1:length(dist_withoutT_new)
    statistic(dist_withoutT_new(i)) = statistic(dist_withoutT_new(i))+1;  
end
bar(statistic');




