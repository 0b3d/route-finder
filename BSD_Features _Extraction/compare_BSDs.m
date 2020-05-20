% compare BSDs
clear all
close all
parameters;
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_better','.mat'],'routes');
routes2 = routes;
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
diff_count = 0;
diff = [];
for i=1:length(routes)
    if bi2de(routes(i).BSDs) ~= bi2de(routes2(i).BSDs)
        diff_count = diff_count+1;
        diff = [diff;i];
    end    
end
disp(size(diff,1));
% save(['Data/',dataset,'/diff.mat'], 'diff');
