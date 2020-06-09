function T = turn_pattern_v2(theta1, theta2, threshold)
% no turn, turn left, turn right

turn = theta2 - theta1;
if turn > 180
    turn = turn-360;
elseif turn < -180
    turn = turn+360;
end

if turn > threshold
    T = 1;
elseif turn < -threshold
    T = 2;
else
    T = 0;
end

end
