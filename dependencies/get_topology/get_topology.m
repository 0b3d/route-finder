function tops = get_topology(locaCoords, wayIdx, roads, nearest_junction)
interType = nearest_junction.type;
interCoord = nearest_junction.coords;
interWays = nearest_junction.ways;
interWaysEnd = nearest_junction.waysEnd';
otherWay = interWays(interWays ~= wayIdx);

wayOrder = find(interWays == wayIdx); % index of way in this interWays

if (interType == 2)
    [A, C] = nodes4pano(roads(wayIdx).coords, interCoord, locaCoords, roads(otherWay).coords);
    interAngle = coordsangle(A, interCoord, C);
    if(interAngle < 180)
        tops = 2;
    else 
        tops = 3;
    end
% for interType == 4, we need to make sure that the wayIdx is among the
% Interways!!!!!!!!! CHECK LATER
elseif (interType == 4)
    if(length(otherWay) == 2) % three roads
            ownWay = findOwnWay({roads.coords}', interWays, interCoord);
            if(ownWay == wayOrder)
                tops = 4;
            else
                otherWay = interWays(ownWay);
                [A, C] = nodes4pano(roads(wayIdx).coords, interCoord, locaCoords, roads(otherWay).coords);
                interAngle = coordsangle(A, interCoord, C);
                if(interAngle < 180)
                    tops = 5;
                else
                    tops = 6;
                end
            end
        elseif(length(otherWay) == 1) % two roads
            if(interWaysEnd(wayOrder))
                tops = 4;
            else
                [A, C] = nodes4pano(roads(wayIdx).coords, interCoord, locaCoords, roads(otherWay).coords);
                interAngle = coordsangle(A, interCoord, C);
                if(interAngle < 180)
                    tops = 5;
                else
                    tops = 6;
                end
            end
    end   
elseif (interType == 7)
    tops = 7;
end  

end