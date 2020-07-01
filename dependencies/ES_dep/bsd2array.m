
CNNs = zeros(5000,4)
BSDs = zeros(5000,4)
for i=1:5000
    CNNs(i,:) = routes(i).CNNs;
    BSDs(i,:) = routes(i).BSDs;
end
