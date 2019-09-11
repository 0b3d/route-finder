% save .csv file
clear all
load('tmp3.mat', 'routes');

filename = 'london.csv';
fid = fopen(filename, 'w');
fprintf(fid, ['%s',',','%s',',','%s',',','%s',',','\n'], 'lat','lon','yaw','wayidx');   
for i=1:length(routes)
    a1 = routes(i).coords(1);
    a2 = routes(i).coords(2);
    b = routes(i).yaw;
    c = routes(i).wayidx;
    % we should check the precision here!
    fprintf(fid, ['%.15f',',','%.15f',',','%.15e',',','%d','\n'], a1,a2,b,c); 
end
fclose(fid);
