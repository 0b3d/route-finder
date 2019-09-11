% Convenience function to normalise a matrix of column vectors to unit length
%
% Usage:
%   result = unitCols(vec)
%
% vec   Vector to normalise.
function result = unitCols(vec)
  n = sqrt(sum(vec.^2) );
  result = vec ./ n(ones(1, size(vec, 1) ),:);
end
