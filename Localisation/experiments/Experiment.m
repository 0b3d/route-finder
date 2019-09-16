% experiment
% % 1. BSDs distribution
clear all
load('london_BSD_small.mat','routes');
T = struct2table(routes);
I = T.id;
P = [];
Q = [];
for i=1:length(I)
    if isempty(I{i,1})
        continue;
    else
        P = [P; I(i)];
        Q = [Q; i];
    end    
end
U = unique(P,'stable');
R = struct();
for i=1:length(U)
    curpano = U(i);
    idx = find(ismember(P, curpano));
    t_idx = Q(idx);
    R(i).BSDs = routes(t_idx).BSDs;
    %R(i).CNNs = routes(t_idx).CNNs;
    R(i).CNNs = bit_flipped(R(i).BSDs, 0.9); 
end

counts = zeros(2, 16);
for i=1:length(R)
    if isempty(R(i).BSDs)
        continue;
    else
        idx1 = (bi2de(R(i).BSDs))+1;
        idx2 = (bi2de(R(i).CNNs))+1;
        counts(1,idx1) = counts(1,idx1)+1;
        counts(2,idx2) = counts(2,idx2)+1;
    end
end 
bar(counts')