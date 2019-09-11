% FAST_CARTPROD Cartesian product of n sets.
%
% Usage: FAST_CARTPROD(v_1, v_2, v_3, ..., v_n)
%
% All inputs v_i must be column vectors.  At least two inputs must be given.
%
% FAST_CARTPROD computes the cartesian product of two sets - that is,

function r = fast_cartprod(varargin)
  
  % Check number of args
  
  if nargin < 2
    error('Not enough input arguments');
  end

  a = varargin{1};
  b = varargin{2};
  
  
  % Ensure column vectors
  
  %{
  if size(a,1) == 1
    a = transpose(a);
  end
  
  if size(b,1) == 1
    b = transpose(b);
  end
  %}
  
  
  % Cartesian product of the first two inputs
  
  r1 = repmat(b,1,size(a, 1));
  r1 = reshape(r1',[],1);
  r2 = repmat(a,size(b, 1),1);
  r = [r2 r1];
  
  
  % Now recursively calculate the cartesian product with the remaining inputs
  
  if nargin > 2
    r = fast_cartprod(r, varargin{3:end});
  end
  
end
