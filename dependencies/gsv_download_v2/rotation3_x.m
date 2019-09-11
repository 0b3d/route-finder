% Returns a 3D rotation matrix which describes an anti-clockwise rotation by
% angle around the x axis.
%
% angle   Angle in radians.
% R       Optional.  Existing rotation matrix to apply rotation to.  Default: eye(3).
function R = rotation3_x(angle, R)
  if nargin < 2
    R = eye(3);
  end
  R = [ 1 0 0; 0 cos(angle) -sin(angle); 0 sin(angle) cos(angle) ] * R;
end
