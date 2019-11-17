%INTEGRATENEWOBS Augment map by new features.
%   G = INTEGRATENEWOBS(G,L,ASSOCIATIONS) integrates new and unmatched
%   observations from the local map L into the global map G and returns
%   the augmented map. ASSOCIATIONS is an array of structure with fields
%      ASSOCIATIONS(i).IL: index of local pairing feature in L
%      ASSOCIATIONS(i).IG: index of global pairing feature in G
%
%   For new observations, IG has a negative value ("star branch" match).
%   Type GET(G) or GET(L) for the data structure of G,L.
%
%   The function iterates over the new observations and calls the
%   INTEGRATE method of the feature objects. 
%
%   See also POINTFEATURE/INTEGRATE, ARLINEFEATURE/INTEGRATE.

% v.1.0, Nov 2003, Kai Arras, CAS-KTH


function G = integratenewobs(G,L,associations)

% Get states
Xl = get(L,'x');
Xg = get(G,'x');  Cg = get(G,'c');
nF = length(Xg);  nFold = nF;
% Get robot and its pose
r  = getrobot(G);
xr = get(r,'x'); Cr = get(r,'C');

% Augment map
for i = 1:length(associations),
  if associations(i).ig < 0,    % if starbranch id
    il = associations(i).il;

    % local-to-global transform
    [fw,Gr] = integrate(Xl{il},xr,Cr);
    
    % augment map state vector
    fw = set(fw,'id',nF);       % simply id
    Xg{nF+1} = fw;
    Cg(nF+1,nF+1).C = get(fw,'c');
    
    % update new row and column of C
    for j = 1:nF;
      Cg(nF+1,j).C = Gr*Cg(1,j).C;
      Cg(j,nF+1).C = Cg(nF+1,j).C';
    end;
    
    nF = nF + 1;
  end;
end;
G = set(G,'x',Xg,'c',Cg);

% Check on positive definiteness
[x,C] = getstate(G);
if det(C) < 0,
  disp('--> integratenewobs: cov negative definite!');
end;

% Echo what has been done
nnew = length(Xg)-nFold;
if nnew == 0, str1 = 'no'; str2 = 'features';
elseif nnew == 1, str1 = '1'; str2 = 'feature';
else str1 = int2str(nnew); str2 = 'features';
end; disp([' ',str1,' new ',str2,' added']);