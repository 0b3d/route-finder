function [R_, dist_] = Nclosest_es_boots(y,R,routes,dist,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    k = R(i,sz2); 
    x = routes(k).x;  
    dist(i,1) = dist(i,1) + pdist2(y,x); % fatser
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);
end
