% obtain map
minlon = -74.028;
minlat = 40.695;
maxlon = -73.940;
maxlat = 40.788;
dist = maxlon - minlon;
lat = [minlat, minlat+1/20*dist, minlat+2/6*dist, minlat+3/6*dist, minlat+4/6*dist, minlat+5/6*dist, maxlat];
url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(1)),',',num2str(maxlon),',',num2str(lat(2)),']'); 
% https://overpass-api.de/api/map?bbox=-74.0197,40.6999,-73.9400,40.7878
% https://api.openstreetmap.org/api/0.6/map?bbox=11.54,48.14,11.543,48.145
folder = websave(filename,url);

url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(2)),',',num2str(maxlon),',',num2str(lat(3)),']');
filename = 'newyork2.osm';
folder = websave(filename,url);

url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(3)),',',num2str(maxlon),',',num2str(lat(4)),']');
filename = 'newyork3.osm';
folder = websave(filename,url);

url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(4)),',',num2str(maxlon),',',num2str(lat(5)),']');
filename = 'newyork4.osm';
folder = websave(filename,url);

url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(5)),',',num2str(maxlon),',',num2str(lat(6)),']');
filename = 'newyork5.osm';
folder = websave(filename,url);

url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(6)),',',num2str(maxlon),',',num2str(lat(7)),']');
filename = 'newyork6.osm';
folder = websave(filename,url);

url = strcat('http://overpass.openstreetmap.ru/cgi/xapi_meta?*[bbox=',num2str(minlon),',',num2str(lat(4)),',',num2str(maxlon),',',num2str(lat(5)),']');
filename = 'newyork4.osm';
folder = websave(filename,url);