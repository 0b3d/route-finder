% simulate CNN classifier
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load(['features/',features_type,'/',features_type,'_', dataset,'.mat']);
count = 0;
for i=1:length(routes)    
    good = routes(i).BSDs;
    if isempty(good)
        count = count+1;
        continue;
    end
    bad = bit_flipped(good, accuracy); 
    routes(i).CNNs = bad; 
end
save(['features/',features_type,'/',features_type,'_', dataset,'.mat'],'routes');
% check the cnn accuracy
p_bit1 = 0;
p_bit2 = 0;
p_bit3 = 0;
p_bit4 = 0;
for i=1:length(routes)
    D = routes(i).BSDs;
    if isempty(D)
        continue;
    end
    C = routes(i).CNNs;
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
disp(p1);
disp(p2);
disp(p3);
disp(p4);