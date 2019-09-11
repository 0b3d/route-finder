function angle = coordsangle(A, B, C)
% geographic azimuth of ABC
[~, az_AB] = distance(A(1), A(2), B(1), B(2));
[~, az_BC] = distance(B(1), B(2), C(1), C(2));
angle = mod(az_BC - az_AB, 360);
end