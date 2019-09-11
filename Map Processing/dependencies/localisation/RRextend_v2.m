function R = RRextend_v2(R_, routes)
index = 1;
sz1 = size(R_,1);
sz2 = size(R_,2);
R = zeros(sz1*3,sz2+1);   % preallocate, should be large enough
for i=1:sz1
    k = R_(i,sz2);
    neighbor = routes(k).neighbor;
    for j=1:size(neighbor, 2)     % one way
        R(index,:) = [R_(i,:), neighbor(j)];  % the slowest
        index = index+1;
    end
end
R = R(1:index-1,:);  % shrink
end