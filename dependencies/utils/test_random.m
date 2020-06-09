% test random routes
clear all
load('routes_10m_2.mat');

max_route_length_init = 20;
R = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R(i) = i;   
end
dist = zeros(size(routes,2),1);

% random choose a seed
max_route_length = 0;    % need to be checked
while max_route_length < 20
    flag = 0;
    loop = 0;
    t = [];
    idx = randi(size(R, 1));
    t(1) = R(idx);
    for m=1:(max_route_length_init-1)
        neighbor = routes(t(m)).neighbor;
        if size(neighbor, 2) == 0
            max_route_length = m;
            break;
        end
        t(m+1) = rextend(neighbor);
        k = find(t == t(m+1));
        %while m~=1 && t(m+1) == t(m-1)
        %    t(m+1) = rextend(neighbor); 
        %end
        while m~=1 && size(k, 2) > 1
           if loop > 5
               flag = 1;
               break;
           end
           t(m+1) = rextend(neighbor); 
           k = find(t == t(m+1));
           loop = loop+1;
        end
        if flag == 1
            break;
        else
            max_route_length = m+1;
        end
    end
end