% bernuli distribution
Q = 0.75;
Nr = 40;
prob = zeros(4*Nr,1);
H = zeros(4*Nr,1);
i = 1;
figure(1)
for x = 4*Nr:-1:1
    H(i) = x;
    prob(i) = Q^(4*Nr-x)*(1-Q)^x;  
    i = i+1;
end

plot(H(:),prob(:),'b--o');