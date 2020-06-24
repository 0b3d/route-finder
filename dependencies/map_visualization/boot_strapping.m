function [R, dist] = boot_strapping(t_, min_dist, routes, route_length)
% remove the first descriptor and append the latest one
idx = t_(route_length);
neighbor = routes(idx).neighbor;
R = zeros(10,route_length);
dist = zeros(10,1);
index = 1;

for j=1:size(neighbor, 1)      
    k = find (t_ == neighbor(j));
    if size(k, 2) == 0
        R(index,:) = [t_(2:route_length), neighbor(j)];
        dist(index,1) = min_dist;
        index = index+1;
    else
        continue;
    end          
end 

R = R(1:index-1,:);  % shrink
dist = dist(1:index-1,1);

% if strcmp(features_type, 'BSD')
%     bad = routes(gt).CNNs;
%     [R_, dist_] = Nclosest_bsd(bad,R,routes,dist,100); % N = 100
% else
%     y = routes(gt).y;
%     [R_, dist_] = Nclosest_es_boots(y,R, routes, dist, 100);    
% end

% et = R_(1,:);
% min_dist = dist_(1);

end