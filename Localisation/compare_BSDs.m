% compare BSDs
clear all
close all
load('london_BSD_new75_small.mat');
routes2 = routes;
load('routes_small_withBSD_75.mat');
diff_count = 0;
for i=1:length(routes)
    if routes(i).BSDs ~= routes2(i).BSDs
        diff_count = diff_count+1;
    end    
end