% simulate CNN classifier
clear all
close all
addpath(genpath('/Users/zhoumengjie/Desktop/route-finder/dependencies'));

load('routes_small_withBSDT.mat');
accuracy = 0.75;
count = 0;
for i=1:length(routes)    
    good = routes(i).BSDs_t;
    if isempty(good)
        count = count+1;
        continue;
    end
    bad = bit_flipped(good, accuracy); 
    routes(i).CNNs_t = bad; 
end

save('routes_small_withBSDT_75.mat','routes');
% calculate the cnn accuracy
p_bit1 = 0;
p_bit2 = 0;
p_bit3 = 0;
p_bit4 = 0;
for i=1:length(routes)
    D = routes(i).BSDs_t;
    if isempty(D)
        continue;
    end
    C = routes(i).CNNs_t;
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
p1 = p_bit1/(length(routes)-count);
p2 = p_bit2/(length(routes)-count);
p3 = p_bit3/(length(routes)-count);
p4 = p_bit4/(length(routes)-count);