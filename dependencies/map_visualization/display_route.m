function [R_, dist_, t_, min_dist, hd, hg] = display_route(t, routes, R, N, dist, key_frame, T, threshold, route_length)
location = t(key_frame);
bad = routes(location).CNNs; % .x
[R_, dist_] = Nclosest_v4(bad,R,routes,dist,N); % filter based on sorting
if key_frame > 1 && key_frame <= route_length
    turn = T(key_frame-1);
    [R_, dist_] = Turn_filter(R_, dist_, turn, routes, key_frame, threshold); % filter based on turn
end
if key_frame > route_length
    turn = T(key_frame-1);
    [R_, dist_] = Turn_filter(R_, dist_, turn, routes, route_length, threshold); % filter based on turn
end
All = zeros(size(R_,1)*size(R_,2),2);
Score = zeros(size(R_,1)*size(R_,2),1);
index = 1;
for i=1:size(R_,1)
    for j=1:size(R_,2)
        curpoint = routes(R_(i,j)).gsv_coords;
        All(index,1) = curpoint(1);
        All(index,2) = curpoint(2);
        Score(index) = dist_(i);
        index = index+1;
    end
end 
Score(Score>=1000)=[];
sz1 = size(Score,1);

cmin = min(Score);
cmax = max(Score);
if cmin == cmax
    cmax = cmin+1;
end
    
hd(1) = scatter(All(1:sz1,2), All(1:sz1,1), 25, Score, 'o', 'filled');
hold on;
colormap('jet');
caxis([cmin,cmax]);
colorbar;

% true location
true_x = zeros(key_frame,1);
true_y = zeros(key_frame,1);
for i=1:key_frame
    true_x(i) = routes(t(i)).gsv_coords(2);
    true_y(i) = routes(t(i)).gsv_coords(1);
end
hg = plot(true_x(:,1), true_y(:,1), '*r');
hd(2) = plot(true_x(key_frame), true_y(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 40, 'LineWidth', 5);

% estimated location
t_ = R_(1,:);
min_dist = dist_(1);
sz2 = size(t_,2);
estimated_x = zeros(sz2,1);
estimated_y = zeros(sz2,1);
for i=1:sz2
    estimated_x(i) = routes(t_(i)).gsv_coords(2);
    estimated_y(i) = routes(t_(i)).gsv_coords(1);
end
hd(3) = plot(estimated_x(:,1), estimated_y(:,1), '*b');
hd(4) = plot(estimated_x(sz2), estimated_y(sz2), 'o', 'MarkerEdgeColor', 'b','MarkerSize', 30, 'LineWidth', 5);
end