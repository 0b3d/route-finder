% test geographical distance
% load('london_BSD_80.mat');
idx_t = test_route(2,20);
lat1 = routes(idx_t).gsv_coords(1);
lon1 = routes(idx_t).gsv_coords(2);

dist = zeros(20,1);
indices = ranked_points_of_routes{2};
for i=1:20
    idx = indices(i,20);
    lat2 = routes(idx).gsv_coords(1);
    lon2 = routes(idx).gsv_coords(2);
    [arclen,~] = distance(lat1, lon1, lat2, lon2);
    % earthRadius = 6378137;
    dist(i) = arclen / 360 * (2*earthRadius*pi); % earth radius = 6371000;
end

% lat1 = deg2rad(lat1);
% lat2 = deg2rad(lat2);
% lon1 = deg2rad(lon1);
% lon2 = deg2rad(lon2);
% dist2 = haversine(lat1, lon1, lat2, lon2);
% dist3 = greatcircledist(lat1, lon1, lat2, lon2, 1) * 6371000; %6378137;
% 
% 
% function rng = greatcircledist(lat1, lon1, lat2, lon2, r)
% 
% % Calculate great circle distance between points on a sphere using the
% % Haversine Formula.  LAT1, LON1, LAT2, and LON2 are in radians.  RNG is a
% % length and has the same units as the radius of the sphere, R.  (If R is
% % 1, then RNG is effectively arc length in radians.)
% 
% a = sin((lat2-lat1)/2).^2 + cos(lat1) .* cos(lat2) .* sin((lon2-lon1)/2).^2;
% 
% % Ensure that a falls in the closed interval [0 1].
% a(a < 0) = 0;
% a(a > 1) = 1;
% 
% rng = r * 2 * atan2(sqrt(a),sqrt(1 - a));

% end
