% Euclidean distance
function dist = eu_dist(x, y)
sq_sum = 0;
for i =1:length(x)
    sq = (x(i) - y(i))^2;
    sq_sum = sq + sq_sum;    
end
dist = sqrt(sq_sum);

end