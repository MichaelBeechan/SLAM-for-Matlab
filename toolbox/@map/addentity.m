%ADDENTITY Add map entity object to map.
%   M = ADDENTITY(M,E) appends map entity E to map M and
%   extends the map covariance matrix by filling in zeros
%   in the new row and column belonging to E.
%
%   See also ENTITY, MAP.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function m = addentity(m, e);

if isa(m,'map') & isa(e,'entity'),
  
  % extend state vector and matrix
  n = length(m.X);
  m.X{n+1} = e;
  Ce = get(e,'c');
  m.C(n+1,n+1).C = Ce;
  
  % fill up new block matrices with zeros
  dimc = length(Ce);
  for i = 1:n,
    dimr = length(get(m.X{i},'x'));
    m.C(i,n+1).C = zeros(dimr, dimc);
    m.C(n+1,i).C = m.C(i,n+1).C';
  end;
  
else
  disp('addentity: Wrong input. Check your arguments');
end;