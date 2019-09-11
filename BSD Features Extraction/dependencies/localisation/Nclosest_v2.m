function [R_, t_] = Nclosest_v2(desc_new,R,routes,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
dist = zeros(sz1,1);
desc_ = desc_new;
for i=1:sz1      % slow
    for j=1:sz2
        %col = 4*(j-1)+1;
        %desc_(1, col:col+3) = routes(R(i,j)).BSDs; % faster
        k = R(i,j);
        bsd = routes(k).BSDs;  % slowest: since too many calls!!!
        desc_(j,:) = bsd;
        %desc_ = routes(R(i,j)).BSDs;
        %desc_ = [desc_, routes(R(i,j)).BSDs];   % slowest!!!
    end
    %dist(i,1) = pdist2(desc_,desc_new,'hamming'); % slow, must be linear
    %dist(i,1) = hamming_dist(desc_, desc_new);    % slow
    dist(i,1) = size(find(desc_~=desc_new), 1); % fatser
end
% criteria: find neighbors whose hamming distance is below a certain
% threshold
max_hamming = sz2*4;
k = dist<(max_hamming*N); % core
R_ = R(k,:);
[~, I] = min(dist);
t_ = R(I,:);

end