function [node1, node2] = nodes4pano(way1, intersection, pano, way2)
for i = 1:size(way1, 1)
    if(isequal(way1(i,:), intersection))
        if(i == 1)
            node1 = way1(2,:);
        elseif(i == size(way1,1))
            node1 = way1(end-1,:);
        else
            angle1 = coordsangle(pano, intersection, way1(i-1,:));
            angle2 = coordsangle(pano, intersection, way1(i+1,:));
            angle1 = abs(angle1 - 180); angle2 = abs(angle2 - 180);
            if(angle1 < angle2)
                node1 = way1(i-1,:);
            else
                node1 = way1(i+1,:);
            end
        end
        break
    end
end
if(isequal(way2(1,:), intersection))
    node2 = way2(2,:);
else
    node2 = way2(end-1,:);
end
end