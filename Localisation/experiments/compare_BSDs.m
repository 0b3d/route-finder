% compare BSDs
clear all
close all
parameters;
load(['features/BSD/','BSD2_',dataset,'.mat']);
routes2 = routes;
load(['features/BSD/','BSD5_',dataset,'.mat']);
diff_count = 0;
diff = [];
for i=1:length(routes)
    if bi2de(routes(i).BSDs) ~= bi2de(routes2(i).BSDs)
        diff_count = diff_count+1;
        diff = [diff;i];
    end    
end
save(['Data/',dataset,'/diff.mat'], 'diff');
