% calculate categories accuracy
clear all
close all
parameters;
% load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');

jc = 0;
njc = 0;
bd = 0;
nbd = 0;
total_jc = 0;
total_njc = 0;
total_bd = 0;
total_nbd = 0;


for i=1:length(routes)
    BSD = routes(i).BSDs;
    CNN = routes(i).CNNs;
    
    for j=1:2:3 
        if BSD(j) == 1
            total_jc = total_jc+1;
            if CNN(j) == 1
                jc = jc+1;
            end
        end
        if BSD(j) == 0
            total_njc = total_njc+1;
            if CNN(j) == 0
                njc = njc+1;
            end
        end 
    end
    
    for j=2:2:4 
        if BSD(j) == 1
            total_bd = total_bd+1;
            if CNN(j) == 1
                bd = bd+1;
            end
        end 
        if BSD(j) == 0
            total_nbd = total_nbd+1;
            if CNN(j) == 0
                nbd = nbd+1;
            end
        end 
    end    
end
disp(jc/total_jc*100)
disp(njc/total_njc*100)
disp(bd/total_bd*100)
disp(nbd/total_nbd*100)



