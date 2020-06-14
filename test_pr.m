% test place recognition
clear all
close all
parameters;

if strcmp(features_type, 'ES') 
    load(['features/',features_type,'/',model,'/', tile_test_zoom, '/',features_type,'_', dataset,'.mat'],'routes');
    for i=1:length(routes)    
        routes(i).x = routes(i).y;    
    end
    save(['features/',features_type,'/',model,'/', tile_test_zoom, '/',features_type,'_', dataset,'_pr','.mat']);
else
    load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',network,'.mat'],'routes');
    for i=1:length(routes)    
        routes(i).BSDs = routes(i).CNNs;    
    end
    save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_pr','.mat'],'routes');
end


