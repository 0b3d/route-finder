% statistic accuracy
load('london_BSD_2degree_75.mat');
load('test_route_4.mat');
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