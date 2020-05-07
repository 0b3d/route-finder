% calculate categories accuracy for each route
clear all
parameters;
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_v3','.mat'],'routes'); 
% load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , '60' ,'.mat']); 

total_num = size(test_route,1)*size(test_route,2);
jc = 0;
njc = 0;
bd = 0;
nbd = 0;
total_jc = 0;
total_njc = 0;
total_bd = 0;
total_nbd = 0;

for i=1:size(test_route,1)
    for j=1:size(test_route,2)
        idx = test_route(i,j);
        BSD = routes(idx).BSDs;
        CNN = routes(idx).CNNs;
        for k=1:2:3 
            if BSD(k) == 1
                total_jc = total_jc+1;
                if CNN(k) == 1
                    jc = jc+1;
                end
            end
            if BSD(k) == 0
                total_njc = total_njc+1;
                if CNN(k) == 0
                    njc = njc+1;
                end
            end 
        end

        for k=2:2:4 
            if BSD(k) == 1
                total_bd = total_bd+1;
                if CNN(k) == 1
                    bd = bd+1;
                end
            end 
            if BSD(k) == 0
                total_nbd = total_nbd+1;
                if CNN(k) == 0
                    nbd = nbd+1;
                end
            end 
        end    
    end
end
disp(jc/total_jc*100)
disp(njc/total_njc*100)
disp(bd/total_bd*100)
disp(nbd/total_nbd*100)



