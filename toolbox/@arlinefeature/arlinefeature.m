%ARLINEFEATURE Constructor function for alpha,r-line feature object.
%   L = ARLINEFEATURE
%   Creates a new alpha,r-line feature object with default values
%
%   L = ARLINEFEATURE(L)
%   Copies and returns alpha,r-line feature L
%
%   L = ARLINEFEATURE(ID,X,C)
%   Creates a new alpha,r-line feature object with values
%     ID : identifier
%      X : 2x1 feature parameter vector, interpreted as [alpha;r]
%      C : 2x2 parameter covariance matrix [saa,sar;sar,srr]
%
%   The line feature class is a child class of the base class
%   entity. 
%
%   Examples:
%      l = arlinefeature(10,[-pi/3;2],0.001*eye(2));
%
%   See also ENTITY, CLASS.

% v.1.0, Dec. 2003, Kai Arras, CAS-KTH

function l = arlinefeature(varargin)
switch nargin,
  case 0,
    % if no input arguments, create a default object
    l.x = [0; 0];
    l.C = [0, 0; 0, 0];
    e = entity('alpha,r line feature', 0);
    l = class(l,'arlinefeature',e);      
  case 1,
    % if single argument of class pointfeature, return it
    if (isa(varargin{1},'arlinefeature'))
      l = varargin{1}; 
    else
      error('arlinefeature: Input argument is not a pointfeature object')
    end
  case 3,
    % create object using specified values
    x = varargin{2};
    C = varargin{3};
    if isnumeric(x) & (prod(size(x)) == 2) & isnumeric(C) & ...
       (size(C) == [2,2]) & isnumeric(varargin{1}),
      l.x = x;
      l.C = C;
      e = entity('alpha,r line feature', varargin{1});
      l = class(l,'arlinefeature',e);
    else
      error('arlinefeature: Wrong argument syntax');
    end;
  otherwise
    error('arlinefeature: Wrong number of input arguments')
end