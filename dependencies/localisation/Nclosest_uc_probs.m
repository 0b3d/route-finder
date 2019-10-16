function [R_, probs_] = Nclosest_uc_probs(y,R,routes,probs,N,t,m)
sz1 = size(R, 1);
sz2 = size(R, 2);

for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    if ~isempty(routes(k).x)
        x = routes(k).x;  % slowest: since too many calls!!!
        yx_dist = eu_dist(y,x);
        yx_probs = normpdf(yx_dist, 0, 1.0);
        probs(i,1) = probs(i,1) * yx_probs; % fatser
        %probs(i,1) = probs(i,1) + yx_dist; % fatser
        
        if m > 1
            y_1 = routes(t(m-1)).y;
            k_1 = R(i,sz2-1);
            x_1 = routes(k_1).x;
            yy_dist = eu_dist(y,y_1);
            xx_dist = eu_dist(x,x_1); 
            xx_probs = normpdf(abs(xx_dist - yy_dist), 0, 0.4511);
            probs(i,1) = probs(i,1) * xx_probs;
            %probs(i,1) = probs(i,1) + (yy_dist - xx_dist);
        end       
        
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
probs_ = probs(I,1) ./ max(probs(:));
end