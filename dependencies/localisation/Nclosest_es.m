function [R_, dist_] = Nclosest_es(y_index, R, dist, N, pairwise_distances)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    x_index = R(i,sz2); % the final one
    dist(i,1) = dist(i,1) + pairwise_distances(y_index, x_index);
end

%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
% Check!! if only one route candidate is left, then it will produce an
% empty dist_, and rank will be declared 5001
sI = size(I,1);

p = max(floor(size(I,1)/100*N), 100); % let 100 survive as minimum  % not slow
% if sI > 1000
%     max_dist = max(dist); 
%     mu = mean(dist);
%     %sigma = std(distances);
%     th = (max_dist - mu)/2 + mu;
%     p = size(find( dist <= th),1);
% else
%     p = 1000;
% end


p = min(p,sI);
I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);

end
