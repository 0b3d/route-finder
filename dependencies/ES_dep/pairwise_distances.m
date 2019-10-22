function pairwise_dist = pairwise_distances(routes)
    X = zeros(size(routes, 2), size(routes(1).x, 2));
    Y = zeros(size(routes, 2), size(routes(1).y, 2));


    for i=1:size(routes,2)
        X(i,:) = routes(i).x;  
        Y(i,:) = routes(i).y;
    end

    pairwise_dist = pdist2(X,Y);
end