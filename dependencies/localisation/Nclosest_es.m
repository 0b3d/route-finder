function [R_, dist_] = Nclosest_es(y_index, R, dist, N, pairwise_distances)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      
    x_index = R(i,sz2);
    dist(i,1) = dist(i,1) + pairwise_distances(y_index, x_index);
end

[~, I] = sort(dist);

ncandidates = size(I,1); % This is in fact number of candidate routes

if ncandidates > min_num_candidates
    p = floor(ncandidates/100*N);
else
    p = ncandidates;
end

I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);

end
