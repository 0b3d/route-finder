% compare BSDs
clear all
close all
load('Data/routes_small_withBSD_50_75.mat');
routes2 = routes;
load('Data/routes_small_withBSD_75.mat');
diff_count = 0;
diff = [];
for i=1:length(routes)
    if bi2de(routes(i).BSDs) ~= bi2de(routes2(i).BSDs)
        diff_count = diff_count+1;
        diff = [diff;i];
    end    
end
save('diff.mat','diff');