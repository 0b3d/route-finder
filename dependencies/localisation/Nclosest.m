function [R_, t_] = Nclosest(desc_new,R,routes,N)
sz1 = size(R, 1);
sz2 = size(R, 2);
dist = zeros(sz1,1);
desc_ = desc_new;
for i=1:sz1      % slow
    for j=1:sz2
        %col = 4*(j-1)+1;
        %desc_(1, col:col+3) = routes(R(i,j)).BSDs; % faster
        desc_(j,:) = routes(R(i,j)).BSDs;
        %desc_ = [desc_, routes(R(i,j)).BSDs];   % slow!!!
    end
    %dist(i,1) = pdist2(desc_,desc_new); % slow
    dist(i,1) = hamming_dist(desc_, desc_new);    % slow
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(dist); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);
R_ = R(I,:);
t_ = R_(1,:); % the minimum

end