%GET    Get method for map object.
%   V = GET(M,'PropertyName') returns the value of the specified
%   property for the map object M.
%
%   GET(M) displays all property names and their current values 
%   for the map object M.
%
%   Examples:
%      X = get(G,'x');
%      C = get(G,'c');
%
%   See also MAP/GETROBOT, MAP/SET, MAP/SETSTATE.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function val = get(varargin);

switch nargin,
  case 1,
    m = varargin{1};
    if (isa(m,'map')),
      nE = length(m.C);
      disp(sprintf('       Name = %s', m.name));
      disp(sprintf('       Time = [%d]', m.timestamp));
      disp(sprintf('          X = [%dx1] block state vector',nE));
      disp(sprintf('          C = [%dx%d] block covariance matrix',nE,nE));
      disp(sprintf('          --- X ---'));
      for i = 1:nE,
        get(m.X{i});
      end;
    else
      error('map/get: Wrong argument type')
    end;
  case 2,
    m = varargin{1};
    prop_name = varargin{2};
    switch lower(prop_name),
      case 'name',
        val = m.name;
      case {'time','timestamp'},
        val = m.timestamp;
      case 'x',
        val = m.X;
      case 'c',
        val = m.C;
      otherwise
        error([prop_name,' is not a valid map object property']);
    end;
  otherwise
    error('map/get: Wrong number of input arguments')
end