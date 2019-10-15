function [R_, dist_] = Nclosest_uc(desc_new,R,routes,dist,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    if ~isempty(routes(k).x)
        desc_ = routes(k).x;  % slowest: since too many calls!!!
        %dist(i,1) = dist(i,1) + eu_dist(desc_new, desc_); % Euclidean
        %dist(i,1) = dist(i,1) + sum(abs(desc_new-desc_)); % Manhattan
        dist(i,1) = dist(i,1) + sum( abs(desc_new - desc_).^0.01 ).^(1/0.5); %fractional
    else
        dist(i,1) = 1000; % max - similar to delete this route
    end
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);

end