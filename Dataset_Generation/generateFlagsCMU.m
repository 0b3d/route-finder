clear all;
% 1 .Load CMU struct
load('Data/streetlearn/cmu5k.mat');

coords = zeros(5000,2);
for i=1:5000
    coords(i, :) = routes(i).gsv_coords;
end

indices = find(coords(:,1) <= 40.44126 & coords(:,2) >= -79.9495182);
highway_flag = zeros(5000,1); % For compatibility
highway_flag(indices) = 1; % Set to 1 all the points inside park bbox 
save('Data/streetlearn/cmu5k_highwayflags.mat', 'highway_flag')

% Save a csvfile with the coordinates, just for visualisation 
discarded_points = coords(indices, :);
csvwrite('Data/streetlearn/cmu5k_discarded.csv', discarded_points)


