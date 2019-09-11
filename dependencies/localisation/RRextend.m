function R = RRextend(R_, routes)
index = 1;
for i=1:size(R_)
    endpoint = size(R_,2);
    k = R_(i,endpoint);
    neighbor = routes(k).neighbor;
    for j=1:size(neighbor, 2)
        if endpoint == 1
            R(index,:) = [R_(i,:), neighbor(j)];
            index = index+1;
        else
            if neighbor(j) ~= R_(i, endpoint-1)       % two way
               R(index,:) = [R_(i,:), neighbor(j)];
               index = index+1;
            end
        end
    end
end