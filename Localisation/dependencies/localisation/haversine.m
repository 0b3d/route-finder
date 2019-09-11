function dist = haversine(lat1, lon1, lat2, lon2)
Re = 6371000;
diff_lat = (lat2 - lat1)/2;
diff_lon = (lon2 - lon1)/2;
sq = (sin(diff_lat))^2 + cos(lat1)*cos(lat2)*(sin(diff_lon))^2;
% dist = 2*Re*atan2(sqrt(sq), sqrt(1-sq));
dist = 2*Re*asin(sqrt(sq));
end