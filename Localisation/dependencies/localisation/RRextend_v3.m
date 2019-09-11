function R = RRextend_v3(R_, routes)
index = 1;
sz1 = size(R_,1);
sz2 = size(R_,2);
R = zeros(sz1*10,sz2+1);   % preallocate, should be large enough
if sz2 == 1
    for i=1:sz1
        k = R_(i,sz2);
        neighbor = routes(k).neighbor;
        for j=1:size(neighbor, 2)     % one way
            R(index,:) = [R_(i,:), neighbor(j)];
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
            index = index+1;
        end
    end
end

R = R(1:index-1,:);  % shrink
end