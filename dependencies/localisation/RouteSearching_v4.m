function [location, t] = RouteSearching_v4(routes)
% load CNN networks
load('20180330_NETonly', 'net1', 'net2');

% parameters
N = [100, 100, 100, 100, 100, 100, 80, 80, 80, 80, 80, 80, 70, 70, 70, 60, 60, 60, 50, 50];
threshold = 60;
% max_route_length = 20;
% t = [42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61];

% route searching
R = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R(i) = i;   
end
dist = zeros(size(routes,2),1);

% random choose a seed
max_route_length_init = 20;
max_route_length = 0;   
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

% ture trun patterns
T = zeros(1, size(t, 2)-1);
for i=1:size(t, 2)-1
    theta1 = routes(t(i)).yaw;
    theta2 = routes(t(i+1)).yaw;
    T(i) = turn_pattern(theta1, theta2, threshold);
end

% download images in advance
zoom = 3;
download_num = 1;
for i=1:size(t, 2)
    curlocation = routes(t(i));
    curlocation = gsv_download_v2(curlocation, download_num, zoom);
    panos(i) = curlocation;
end
% save data in table form
filepath = 'test_snaps/';
[Tjc, Tbd] = genTabel(filepath, panos);

for m=1 : max_route_length
    %good = routes(t(m)).BSDs;    
    %bad = bit_flipped(good, accuracy); 
    %curlocation = routes(t(m));
    %bad = Cnn_classifier(curlocation, net1, net2);
    bad = Cnn_classifier_v2(net1,Tjc,net2,Tbd,m);
    
    [R_, ~, dist_] = Nclosest_v4(bad,R,routes,dist,N(m)); % filter based on sorting
    
    if m < max_route_length
        [R, dist] = RRextend_v5(R_, dist_, routes); 
    else
        % turn patterns
        T_ = zeros(size(R_, 1), size(R_, 2)-1);
        T_dist = zeros(size(R_, 1),1);
        for i=1:size(R_, 1)
            for j=1:size(R_, 2)-1
                idx1 = R_(i,j);
                idx2 = R_(i,j+1);
                theta1 = routes(idx1).yaw;
                theta2 = routes(idx2).yaw;
                T_(i, j) = turn_pattern(theta1, theta2, threshold);
            end 
            T_dist(i) = size(find(T_(i,:)~=T), 2); 
        end 
        k = T_dist == 0;
        R_ = R_(k,:);
    end   
end
if size(R_, 1) > 0
    t_ = R_(1,:);
    location = t_(1, size(t_, 2));
else 
    location = [];
end

% result = zeros(2,size(t,2));
% for i=1:size(t,2)
%     result(1, i) = t(1,i);
%     result(2, i) = t_(1,i);    
% end
% disp('end');
end
