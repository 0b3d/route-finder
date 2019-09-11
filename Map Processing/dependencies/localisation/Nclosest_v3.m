function [R_, t_, dist_] = Nclosest_v3(desc_new,R,routes,dist,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    desc_ = routes(k).BSDs;  % slowest: since too many calls!!!, tackled!!!
    dist(i,1) = dist(i,1) + size(find(desc_~=desc_new), 2); % fatser
end
% criteria: find neighbors whose hamming distance is below a certain threshold
max_hamming = sz2*4;
k = dist<(max_hamming*N); % core
R_ = R(k,:);
dist_ = dist(k,1);
[~, I] = min(dist_);
t_ = R_(I,:);

end