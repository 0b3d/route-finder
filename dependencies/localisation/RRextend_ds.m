function [R, dist] = RRextend_ds(R_, dist_, routes, interval)
index = 1;
sz1 = size(R_,1);
sz2 = size(R_,2);
R = zeros(sz1*5,sz2+1);   % preallocate, should be large enough
dist = zeros(sz1*5,sz2+1);

for i=1:sz1
    idx = R_(i,sz2);
    for j=1:interval
        neighbor = [];
        for q=1:size(idx, 1)
            neigh_tmp = routes(idx(q)).neighbor; % may have multi neighbors
            neighbor = [neighbor; neigh_tmp];
        end
        
        if isempty(neighbor)
            break;
        else
            idx = neighbor;
        end
    end
    
    if isempty(neighbor) % if no neighbors, delete this route
        continue;
    end

%     if size(neighbor,1)>3
%         disp(size(neighbor,1));
%     end
            
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