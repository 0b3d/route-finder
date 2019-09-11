function [R_, dist_] = Nclosest_v4(desc_new,R,routes,dist,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    try
    if ~isempty(routes(k).BSDs)
        desc_ = routes(k).BSDs;  % slowest: since too many calls!!!
        dist(i,1) = dist(i,1) + size(find(desc_~=desc_new), 2); % fatser
    else
        dist(i,1) = 1000; % max - similar to delete this route
    end
    catch
        disp('error');
    end
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);
end