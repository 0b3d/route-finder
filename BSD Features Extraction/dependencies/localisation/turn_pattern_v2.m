function T = turn_pattern_v2(theta1, theta2, threshold)
% no turn, turn left, turn right
% turn = abs(theta1 - theta2); % turn is between 0~360
% T = 0;
% if (turn > threshold && turn < 90) || (turn > (180+threshold) && turn < 270)
%     T = 1; % right
% end
% 
% if (turn > 90 && turn < (180-threshold)) || (turn > 270 && turn < (360-threshold))
%     T = 2; % left
% end

% ignore the fault in GSV
% turn = abs(theta1 - theta2); % turn is between 0~360
% % T = 0;
% if (turn > threshold && turn < 180)
%     T = 1; % right
% elseif (turn > 180 && turn < (360-threshold))
%     T = 2; % left
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

if turn > threshold
    T = 1;
elseif turn < -threshold
    T = 2;
else
    T = 0;
end

% This method is from Yam
% theta1 = GGang2Deg(theta1*pi/180);
% theta2 = GGang2Deg(theta2*pi/180);
% diff = theta1 - theta2;
% if abs(diff) >= threshold %count as turn
%     if (diff) >= 0
%         T = 1;
%     else
%         T = 2;
%     end
% else
%     T = 0;
% end
end