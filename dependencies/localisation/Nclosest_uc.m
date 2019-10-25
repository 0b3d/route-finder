function [R_, dist_] = Nclosest_uc(y_index, R, dist, N, pairwise_distances)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    x_index = R(i,sz2); % the final one
    dist(i,1) = dist(i,1) + pairwise_distances(y_index, x_index);
end

%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);

end