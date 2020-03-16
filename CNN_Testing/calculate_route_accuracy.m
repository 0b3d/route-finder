% calculate accuracy for each route
clear all
parameter;
load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_v2','.mat'],'routes'); 
load(['Localisation/test_routes/',dataset,'_routes_', num2str(test_num),'_' , '60' ,'.mat']); 
real = 'simulated';

total_num = 20;
p_bit = zeros(size(test_route, 1), 4);
for i=1:size(test_route,1)
    p_bit1 = 0;
    p_bit2 = 0;
    p_bit3 = 0;
    p_bit4 = 0;
    for j=1:total_num
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
   p_bit(i,1) = p_bit1/total_num;
   p_bit(i,2) = p_bit2/total_num;
   p_bit(i,3) = p_bit3/total_num;
   p_bit(i,4) = p_bit4/total_num;
end
save(['results_for_bsd/',dataset,'_route_accuracy_',real,'.mat'],'p_bit');

