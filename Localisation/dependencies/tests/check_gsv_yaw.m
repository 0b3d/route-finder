% check gsv_yaw
load('london_BSD.mat');
count = 0;
for i=1:length(routes)
    curyaw = routes(i).gsv_yaw;
    rad = curyaw*pi/180;
    newyaw = GGang2Deg(rad);
    if curyaw ~= newyaw
        count = count+1;
    end    
end