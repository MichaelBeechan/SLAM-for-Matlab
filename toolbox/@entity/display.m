%DISPLAY Display method for map entity object.
%   DISPLAY(E) displays the map entity object E.
%
%   See also ENTITY.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function display(e)

if isequal(e.type,'none'),
  disp(sprintf(' map entity (type undefined) id = %d', e.id));
else
  disp(sprintf(' %s id = %d', e.type, e.id));
end;
