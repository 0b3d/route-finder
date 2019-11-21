function [et, min_dist] = Bootstrapping_v2(t_, min_dist, routes, route_length)
% remove the first descriptor and append the latest one
idx = t_(route_length);
neighbor = routes(idx).neighbor;
R = zeros(10,route_length);
dist = zeros(10,1);
index = 1;
loc_flag = 1; % have neighbors

if isempty(neighbor) % if no neighbors, delete this route
    disp('localisation end');
    loc_flag = 0; % no neighbors
    exit;
end

if  loc_flag
    for j=1:size(neighbor, 1)      
        k = find (t_ == neighbor(j));
        if size(k, 2) == 0
            R(index,:) = [t_(2:route_length), neighbor(j)];
            dist(index,1) = min_dist;
            index = index+1;
            loc_flag = 2; % can find neighbors without loops
        else
            continue;
        end          
    end 
end

if loc_flag ~= 2
    disp('localisation end');
    exit;
end
et = R(1,:);
min_dist = dist(1);

end