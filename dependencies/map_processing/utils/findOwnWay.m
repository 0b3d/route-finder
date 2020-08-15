function ownWay = findOwnWay(wayCoords, interWays, intersection)
coords = [];
for i = 1:length(interWays)
    if(isequal(wayCoords{interWays(i)}(1,:), intersection))
        coords(i,:) = wayCoords{interWays(i)}(2,:);
    else
        coords(i,:) = wayCoords{interWays(i)}(end-1,:);
    end
end

[~, az] = distance(coords(:,1), coords(:,2), intersection(1), intersection(2));

one2Two = abs(180 - abs(az(1) - az(2)));
one2Three = abs(180 - abs(az(1) - az(3)));
two2Three = abs(180 - abs(az(2) - az(3)));
[~, idx] = min([one2Two, one2Three, two2Three]);
switch idx
    case 1
        ownWay = 3;
    case 2
        ownWay = 2;
    otherwise
        ownWay = 1;
end
end