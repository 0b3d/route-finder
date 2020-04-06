function [R_] = Nclosest_nT(bad_route,R,routes,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1     
    good_route = zeros(1,40*4);
    for j=1:sz2
        good = routes(R(i,j)).BSDs;
        good_route(1,(j-1)*4+1:j*4) = good;
    end
    dist(i,1) = size(find(bad_route~=good_route), 2); % fatser        
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
end