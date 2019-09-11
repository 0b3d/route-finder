function panoid = get_panoid(coord)
lat = num2str(coord(1));
lon = num2str(coord(2));
url = strcat('http://maps.google.com/cbk?output=xml&ll=',lat,',',lon); 
filename = 'tmp.xml';
folder = websave(filename,url);
str = fileread(fullfile(folder));
pano_ind = strfind(str, 'pano_id=');
panoid = panoExtract(pano_ind(1), str); 

end