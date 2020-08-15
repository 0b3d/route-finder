% correct neighbors and bearings before localisation
clear all
close all
parameters;

if strcmp(features_type, 'ES')
    load(['Data/','streetlearn/',dataset,'_new','.mat'],'routes');
    oroutes = routes;
    fileName = fullfile('features/ES', model, tile_test_zoom, ['ES_', dataset, '.mat']);
    load(fileName,'routes');
    for i=1:length(routes)
        routes(i).neighbor = oroutes(i).neighbor;
        routes(i).bearing = oroutes(i).bearing;    
    end
    save(fileName,'routes');
  
else
    load(['Data/','streetlearn/',dataset,'_new','.mat'],'routes');
    oroutes = routes;
    load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
    for i=1:length(routes)
        routes(i).neighbor = oroutes(i).neighbor;
        routes(i).bearing = oroutes(i).bearing;    
    end

    save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
end