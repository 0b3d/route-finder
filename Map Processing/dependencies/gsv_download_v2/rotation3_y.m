% Returns a 3D rotation matrix which describes an anti-clockwise rotation by
% angle around the y axis.
%
% angle   Angle in radians.
% R       Optional.  Existing rotation matrix to apply rotation to.  Default: eye(3).
function R = rotation3_y(angle, R)
  if nargin < 2
    R = eye(3);
  end
  R = [ cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle) ] * R;
end
