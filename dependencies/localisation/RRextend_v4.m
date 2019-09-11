function [R, dist] = RRextend_v4(R_, dist_, routes)
index = 1;
sz1 = size(R_,1);
sz2 = size(R_,2);
R = zeros(sz1*5,sz2+1);   % preallocate, should be large enough
dist = zeros(sz1*5,sz2+1);
if sz2 == 1
    for i=1:sz1
        k = R_(i,sz2);
        neighbor = routes(k).neighbor;
        for j=1:size(neighbor, 2)     % one way
            R(index,:) = [R_(i,:), neighbor(j)];
            dist(index,1) = dist_(i,1);
            index = index+1;
        end
    end
else
    for i=1:sz1
        k = R_(i,sz2);
        neighbor = routes(k).neighbor;
        for j=1:size(neighbor, 2)     % one way
            if neighbor(j) == R_(i, sz2-1)       % two way
                continue;
            end
            R(index,:) = [R_(i,:), neighbor(j)];
            dist(index,1) = dist_(i,1);
            index = index+1;
        end
    end
end

R = R(1:index-1,:);  % shrink
dist = dist(1:index-1,1);
end