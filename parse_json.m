% parse .json
filename = 'metadata.json';
str = fileread(filename);
data = jsondecode(str);
