function [R_, probs_] = Nclosest_uc_probs(y,R,routes,probs,N,t,m, matched_pairwise_probs, unmatched_pairwise_probs)
sz1 = size(R, 1);
sz2 = size(R, 2);

for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    if ~isempty(routes(k).x)
        x = routes(k).x;  % slowest: since too many calls!!!
        %yx_dist = eu_dist(y,x);
        %yx_probs = 1.0 - cdf(gm, yx_dist);
        Pxy_given_matched = matched_pairwise_probs(t(m),k);
        Pxy_given_unmatched = unmatched_pairwise_probs(t(m),k);
        Pxy = probs(i,1) * Pxy_given_matched + (1-probs(i,1)) * Pxy_given_unmatched;
        %yx_probs = normpdf(yx_dist, 0, 1.0);
        probs(i,1) = probs(i,1) * Pxy_given_matched / Pxy; % fatser
        %probs(i,1) = probs(i,1) + yx_dist; % fatser
        
%         if m > 1
%             y_1 = routes(t(m-1)).y;
%             k_1 = R(i,sz2-1);
%             x_1 = routes(k_1).x;
%             yy_dist = eu_dist(y,y_1);
%             xx_dist = eu_dist(x,x_1); 
%             PD_given_match = normpdf(yy_dist - xx_dist, 0.3466, 0.600);
%             PD_given_notmatch = normpdf(yy_dist - xx_dist, -1.3369, 0.13285);
%             PD = PD_given_match * probs(i,1) + PD_given_notmatch * (1 - probs(i,1));
%             Pmatch_given_D = probs(i,1) * PD_given_match / PD;
%             probs(i,1) = Pmatch_given_D;
%         end       
        
    else
        probs(i,1) = 0.0; % max - similar to delete this route
        %probs(i,1) = 1000.0;
    end
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(probs,'descend'); % core
%[~, I] = sort(probs);
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
probs_ = probs(I,1)*0.95; %./ max(probs(:));
end