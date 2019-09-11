function [R_, t_, dist_] = Nclosest_v5(desc_new,R,routes,dist,H,P)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    desc_ = routes(k).BSDs;  % slowest: since too many calls!!!, tackled!!!
    dist(i,1) = dist(i,1) + size(find(desc_~=desc_new), 2); % fatser
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*P);  % not slow
I = I(1:p,1);
R_ = R(I,:);
dist_ = dist(I,1);
% criteria: find neighbors whose hamming distance is below a threshold
max_hamming = sz2*4;
k = dist_<(max_hamming*H); % core
R_ = R_(k,:);
dist_ = dist_(k,1);
[~, I] = min(dist_);
t_ = R_(I,:);

end