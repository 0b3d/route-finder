function new_inters = inters_filter(inters, ways, thresh)
count = 0;

for i=1:size(inters,1)
    curinter = inters(i);
    ways_num = size(curinter.ways, 2);
    if ways_num > 2
        count = count+1;
        new_inters(count) = curinter; 
    else
        r1 = ways(curinter.ways(1));
        for idx = 1:size(r1.coords,1)
            if r1.coords(idx,1) == curinter.coords(1) && r1.coords(idx,2) == curinter.coords(2)
                if idx == 1
                    x = [r1.coords(idx, 1); r1.coords(idx+1, 1)];
                    y = [r1.coords(idx, 2); r1.coords(idx+1, 2)];
                elseif idx == size(r1.coords,1)
                    x = [r1.coords(idx-1, 1); r1.coords(idx, 1)];
                    y = [r1.coords(idx-1, 2); r1.coords(idx, 2)];
                else
                    x = [r1.coords(idx-1, 1); r1.coords(idx+1, 1)];
                    y = [r1.coords(idx-1, 2); r1.coords(idx+1, 2)];
                end 
            end
        end
        ang1 = azimuth(x(1),y(1),x(2),y(2));
        
        r2 = ways(curinter.ways(2));
        for idx = 1:size(r2.coords,1)
            if r2.coords(idx,1) == curinter.coords(1) && r2.coords(idx,2) == curinter.coords(2)
                if idx == 1
                    x = [r2.coords(idx, 1); r2.coords(idx+1, 1)];
                    y = [r2.coords(idx, 2); r2.coords(idx+1, 2)];
                elseif idx == size(r2.coords,1)
                    x = [r2.coords(idx-1, 1); r2.coords(idx, 1)];
                    y = [r2.coords(idx-1, 2); r2.coords(idx, 2)];
                else
                    x = [r2.coords(idx-1, 1); r2.coords(idx+1, 1)];
                    y = [r2.coords(idx-1, 2); r2.coords(idx+1, 2)];
                end 
            end
        end
        ang2 = azimuth(x(1),y(1),x(2),y(2));
        
        theta = abs(ang1 - ang2);
        if (theta > thresh && theta < (180 - thresh)) || (theta > (180+thresh) && theta < (360-thresh)) 
            count = count+1;
            new_inters(count) = curinter; 
        end
    end
end
end