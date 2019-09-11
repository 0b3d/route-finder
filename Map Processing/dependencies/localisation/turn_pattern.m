function T = turn_pattern(theta1, theta2, threshold)
% after setting different criteria, get a more complicated descriptor
% turn = abs(theta1 - theta2);
% if (turn > threshold && turn < (180 - threshold)) || (turn > (180+threshold) && turn < (360-threshold))
%     T = 1;
% else
%     T = 0;
% end

% ignore the fault in GSV
% turn = abs(theta1 - theta2);
% if (turn > threshold && turn < (360 - threshold))
%     T = 1;
% else
%     T = 0;
% end

% Andrew's suggestion
turn = theta2 - theta1; 

if turn > 180
    turn = turn-360;
elseif turn < -180
    turn = turn+360;
end

if abs(turn) > threshold
    T = 1;
else
    T = 0;
end
    


% This method is from Yam
% theta1 = GGang2Deg(theta1*pi/180);
% theta2 = GGang2Deg(theta2*pi/180);
% if abs(theta1-theta2) >= threshold %count as turn
%     T = 1;
% else
%     T = 0;
% end


end