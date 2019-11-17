%POINTFEATURE Constructor function for point feature object.
%   P = POINTFEATURE
%   Creates a new x,y-point feature object with default values
%
%   P = POINTFEATURE(P)
%   Copies and returns point feature P
%
%   P = POINTFEATURE(ID,X,C)
%   Creates a new point feature object with values
%     ID : identifier
%      X : 2x1 feature parameter vector, interpreted as [x;y]
%      C : 2x2 parameter covariance matrix [sxx,sxy;sxy,syy]
%
%   The point feature class is a child class of the base class
%   entity. 
%
%   Examples:
%      p = pointfeature(201,[-1;3],0.001*eye(2));
%
%   See also ENTITY, CLASS.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function p = pointfeature(varargin)
switch nargin,
  case 0,
    % if no input arguments, create a default object
    p.x = [0; 0];
    p.C = [0, 0; 0, 0];
    e = entity('point feature', 0);
    p = class(p,'pointfeature',e);      
  case 1,
    % if single argument of class pointfeature, return it
    if (isa(varargin{1},'pointfeature'))
      p = varargin{1}; 
    else
      error('pointfeature: Input argument is not a pointfeature object')
    end
  case 3,
    % create object using specified values
    x = varargin{2};
    C = varargin{3};
    if isnumeric(x) & (prod(size(x)) == 2) & isnumeric(C) & ...
       (size(C) == [2,2]) & isnumeric(varargin{1}),
      p.x = x;
      p.C = C;
      e = entity('point feature', varargin{1});
      p = class(p,'pointfeature',e);
    else
      error('pointfeature: Wrong argument syntax');
    end;
  otherwise
    error('pointfeature: Wrong number of input arguments')
end