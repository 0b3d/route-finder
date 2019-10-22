for i=1:test_num
    for j=1:40
        gt = test_route(i,j);
        % check the gt probability
        rank_ = ranking(i,j);
        prob = dist{1,i}{1,j}(rank_,1);
        
        if (rank_ > 1) && (prob == 1) && (j ~= 1) 
            disp("Inconsistency in route ")
            i, j
            pause
        end
        
    end
end