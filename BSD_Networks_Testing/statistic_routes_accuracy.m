% statistic accuracy
clear all
close all
parameters;
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_', network,'.mat'],'routes'); 
% load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , num2str(threshold) ,'.mat']); 

total_num = size(test_route,1)*size(test_route,2);
p_bit1 = 0;
p_bit2 = 0;
p_bit3 = 0;
p_bit4 = 0;
for i=1:size(test_route,1)
    for j=1:size(test_route,2)
        idx = test_route(i,j);
        D = routes(idx).BSDs;
        if isempty(D)
            continue;
        end
        C = routes(idx).CNNs;
        if(D(1)==C(1))
            p_bit1 = p_bit1+1;
        end
        if(D(2)==C(2))
            p_bit2 = p_bit2+1;
        end
        if(D(3)==C(3))
            p_bit3 = p_bit3+1;
        end
        if(D(4)==C(4))
            p_bit4 = p_bit4+1;
        end    
   end
end
p1 = p_bit1/total_num;
p2 = p_bit2/total_num;
p3 = p_bit3/total_num;
p4 = p_bit4/total_num;
disp(p1);
disp(p2);
disp(p3);
disp(p4);