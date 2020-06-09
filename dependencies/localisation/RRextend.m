function [R, dist] = RRextend(R_, dist_, routes)
index = 1;
sz1 = size(R_,1);
sz2 = size(R_,2);
R = zeros(sz1*5,sz2+1);   % preallocate, should be large enough
dist = zeros(sz1*5,1);

for i=1:sz1
    idx = R_(i,sz2);
    neighbor = routes(idx).neighbor;

    if isempty(neighbor) % if no neighbors, delete this route
        continue;
    end
    
    for j=1:size(neighbor, 1)      
        k = find (R_(i,:) == neighbor(j));
        if size(k, 2)== 0
            R(index,:) = [R_(i,:), neighbor(j)];
            dist(index,1) = dist_(i,1);
            index = index+1;
        else
            continue;
        end          
    end    
end

R = R(1:index-1,:);  % shrink
dist = dist(1:index-1,1);
end