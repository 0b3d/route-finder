function [R_, probs_] = Nclosest_uc_bayes(y,R,routes,probs,N,t,m)
sz1 = size(R, 1);
sz2 = size(R, 2);
prior = probs;

for i=1:sz1      % slow
    k = R(i,sz2); % the final one
    if ~isempty(routes(k).x)
        x = routes(k).x;  % slowest: since too many calls!!!
        yx_dist = eu_dist(y,x);
        %yx_probs = normcdf(yx_dist, 0, 1);
        %probs(i,1) = probs(i,1) * yx_probs; % fatser
        
        % prior
        PA = prior(i,1);
        
        % evidence
        Pba = normcdf([yx_dist 4], 0.6265, 0.1859);
        PBA =Pba(2) - Pba(1);
        Pbna = normcdf([0 yx_dist], 0.8449, 0.2354);
        PBNA =Pbna(2) - Pbna(1);

        PB = PA * PBA + (1 - PA) * PBNA  ;
        % Bayes's rule 1
        PAB = PA * PBA / PB;
        probs(i,1) = PAB;
        
        % Bayes's rule 2
        if m > 1
            PA = probs(i,1);      
            
            y_1 = routes(t(m-1)).y;
            k_1 = R(i,sz2-1);
            x_1 = routes(k_1).x;
            yy_dist = eu_dist(y,y_1);
            xx_dist = eu_dist(x,x_1); 
            %xx_probs = normpdf(xx_dist, yy_dist, 1);
            xx_prob = normcdf([yy_dist xx_dist], yy_dist,1.0)
            PBA = xx_probs;
            PBNA = 1 - xx_probs;
            probs(i,1) = probs(i,1) * xx_probs;
        end       
        

% %% Apprach 2
%         PA = prior(i,1);
%         Pba = normcdf(yx_dist, 0, 1);
%         Pbna = normcdf(yx_dist, 0.8449, 0.2354);
%         PBNA =Pbna(2) - Pbna(1);
% 
%         PB = PA * PBA + (1 - PA) * PBNA  ;
%         PAB = PA * PBA / PB;
%         probs(i,1) = PAB;

%         if m > 1
%             y_1 = routes(t(m-1)).y;
%             k_1 = R(i,sz2-1);
%             x_1 = routes(k_1).x;
%             yy_dist = eu_dist(y,y_1);
%             xx_dist = eu_dist(x,x_1); 
%             xx_probs = normpdf(xx_dist, yy_dist, 1);
%             probs(i,1) = probs(i,1) * xx_probs;
%         end       

    else
        probs(i,1) = 0.0; % max - similar to delete this route
    end
end
%criteria: sort, find the k nearest neighbors
[~, I] = sort(probs,'descend'); % core
p = floor(size(I,1)/100*N);  % not slow
I = I(1:p,1);    
R_ = R(I,:);
%probs_ = probs(I,1) ./ max(probs(:));
probs_ = probs;
end