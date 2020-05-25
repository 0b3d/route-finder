% simulate CNN classifier
clear all
close all
parameters;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path));

load(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'.mat'],'routes');
count = 0;
for i=1:length(routes)    
    good = routes(i).BSDs;
    if isempty(good)
        count = count+1;
        continue;
    end
    bad = bit_flipped(good, accuracy);
    % bad = bit_flipped_v2(good, accuracy_jcf, accuracy_bdr, accuracy_jcb, accuracy_bdl);
    % bad = bit_flipped_v3(good, accuracy_jc, accuracy_njc, accuracy_bd, accuracy_nbd);
    routes(i).CNNs = bad; 
end
% save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_',num2str(accuracy*100),'.mat'],'routes');
save(['features/',features_type,'/',dataset,'/',features_type,'_', city,'_',dataset,'_v2','.mat'],'routes');

% check the bit accuracy
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
disp(p1*100);
disp(p2*100);
disp(p3*100);
disp(p4*100);


% check the category accuracy
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
