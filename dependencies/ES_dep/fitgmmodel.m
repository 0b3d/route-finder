function [gm, pairwise_probs] = fitgmmodel(pairwise_distances)
% n = size(routes,2);
% matched_pairs = zeros(1,n);
% unmatched_pairs = zeros(1,n);
% 
% % Extract matched and unmatched distances
% for i=1:n
%     x = routes(i).x;
%     y = routes(i).y;
%     d = sqrt(sum((x-y).^2));
%     matched_pairs(1,i) = d;
%     % unmatched example
%     j = randi(n,1);
%     while i==j
%         j = randi(n,1);
%     end
%     xu = routes(j).x;
%     d = sqrt(sum((xu-y).^2));
%     unmatched_pairs(1,i) = d;
% end
% 
% data = [matched_pairs; unmatched_pairs];
% gm = fitgmdist(data,2);
    load('gm.mat', 'gm');

    [R, C] = size(pairwise_distances);
    Zc = reshape(pairwise_distances, [R*C,1]);
    dd = cdf(gm, Zc);
    pairwise_probs = reshape(dd, [R, C]);

end

