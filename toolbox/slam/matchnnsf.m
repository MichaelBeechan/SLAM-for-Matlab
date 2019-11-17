%MATCHNNSF Perform data association using a NNSF.
%   [NU,R,H,ASSOCIATIONS] = MATCHNNSF(GPRED,HPRED,L,PARAMS) matches the
%   observed features in the local map L against the predicted features
%   in the predicted global map GPRED with a nearest neighbor strategy.
%   The significance level for matching is given by PARAMS.ALPHA.
%
%   The function returns the stacked p x 1 innovation vector NU, where
%   p is the number of matched observations (which in turn is the num-
%   ber of matched features times their number of parameters), the 
%   stacked p x p observation covariance matrix R (which can contain 
%   non-zero entries in the off-diagonal), and the stacked p x n  
%   measurement Jacobian matrix H with non-zero entries in each row at 
%   the robot position and the position of the corresponding feature  
%   (n is the size of the map state vector). Successful data associ-
%   ations are in the array of structure ASSOCIATIONS with fields:
%      ASSOCIATIONS(i).IL: index of local pairing feature in L
%      ASSOCIATIONS(i).IG: index of global pairing feature in G
%
%   The nearest neighbor standard filter (NNSF) is implemented in its
%   most conservative variant: local or global pairing candidates which
%   give rise to association ambiguities (i.e. a local feature in more
%   than one validation gate or a global feature with more than one
%   local features in its gate) are ignored.
%
%   See also PREDICTMEASUREMENTS, ESTIMATEMAP.

% v.1.0, Kai Arras, Nov. 2003, CAS-KTH

function [nu,R,H,associations] = matchnnsf(Gpred,Hpred,L,params);

Xg = get(Gpred,'x');
Xl = get(L,'x'); Cl = get(L,'c');
nG = length(Xg); nL = length(Xl);

if (nG > 0) & (nL > 0),
  
  % Step 1: compute distance matrix
  for i = 1:nL,
    Cli = Cl(i,i).C;
    for j = 1:nG,
      Cgj = get(Xg{j},'c');
      nu = calcinnovation(Xl{i},Xg{j});
      S  = Cgj + Cli;
      if det(S) < 0, disp('--> matchnnsf: S negative definite'); end;
      D(i,j).d  = mahalanobis(nu,S);
      D(i,j).nu = nu;
      D(i,j).R  = Cli;
    end;
  end;
  
  % Step 2: traverse D and find candidates
  iassoc = 1;
  for i = 1:nL,
    matched = 0;
    for j = 1:nG,
      dof = length(D(i,j).nu);
      if D(i,j).d < chi2invtable(params.alpha,dof),
        matched = 1;
        associations(iassoc).d  = D(i,j).d;
        associations(iassoc).ig = j;
        associations(iassoc).il = i;
        associations(iassoc).nu = D(i,j).nu;
        associations(iassoc).R  = D(i,j).R;
        iassoc = iassoc + 1;
      end;
    end;
    if ~matched,
      associations(iassoc).d  = Inf;
      associations(iassoc).ig = -1;
      associations(iassoc).il = i;
      associations(iassoc).nu = Inf;
      associations(iassoc).R  = zeros(dof);
      iassoc = iassoc + 1;
    end;
  end;
  nassoc = length(associations);
  
  % Step 3: find unique candidates, mark others
  ilvec = [associations(:).il];
  igvec = [associations(:).ig];
  for i = 1:nassoc,
    if associations(i).ig > 0,
      nl = length(find(ilvec==associations(i).il));
      associations(i).nl = nl;
      ng = length(find(igvec==associations(i).ig));
      associations(i).ng = ng;
      if (nl == 1) & (ng == 1),
        associations(i).accept = 1;
      else
        associations(i).accept = 2;
      end;
    else
      associations(i).accept = 0;
    end;
  end;
  
  % Step 4: Stack nu, R and H with unique data association
  nu = []; R = []; H = [];
  ir = 1;
  for i = 1:nassoc,
    if associations(i).accept == 1,
      nr = length(associations(i).nu);
      % construct nu
      nu = [nu; associations(i).nu];
      % construct R
      R(ir:ir+nr-1,ir:ir+nr-1) = associations(i).R;
      % construct H
      H(ir:ir+nr-1,1:3) = Hpred(associations(i).ig).Hr;
      ic = 4;  % put in robot Jacobian and start at ic=4
      for j = 1:nG,
        nc = length(get(Xg{j},'x'));
        if j == associations(i).ig,
          H(ir:ir+nr-1,ic:ic+nc-1) = Hpred(associations(i).ig).Hm;
        else
          H(ir:ir+nr-1,ic:ic+nc-1) = zeros(nr,nc);
        end;
        ic = ic + nc;
      end;
      ir = ir + nr;
    end;
  end;
  
  nmatch = length(find([associations(:).accept]==1));
  if nmatch == 0, str1 = 'no'; str2 = 'features';
  elseif nmatch == 1, str1 = '1'; str2 = 'feature';
  else str1 = int2str(nmatch); str2 = 'features';
  end; disp([' ',str1,' matched ',str2]);
  
  % Step 6: Plot if desired
  if 0,
    figure(2); clf; hold on; zoom on; axis equal;
    title('Matchings between predicted global and local map');
    draw(Gpred,1,1,0,[.0 .4 .8]);
    draw(L,1,1,0,[1. .5 .2]);
    for i = 1:nL,
      if associations(i).accept == 1,
        xl = get(Xl{associations(i).il},'x');
        xg = get(Xg{associations(i).ig},'x');
        plot([xl(1) xg(1)],[xl(2) xg(2)],'m-','LineWidth',3);
      end;
    end;
    pause;
  end;    
  
else
  if nL > 0,
    for i = 1:nL,
      associations(i).il = i;
      associations(i).ig = -1;
    end;
  else
    associations = [];
  end;
  nu = []; R = []; H = [];
end;


% Debug helper function
function dispassoc(a)
n = length(a);
for i = 1:n,
  disp(['  i = ',int2str(i),', d = ',num2str(a(i).d), ...
      ', ig = ',int2str(a(i).ig),', il = ',int2str(a(i).il)]);
  if isfield(a(i),'nl'), disp(['  nl = ',int2str(a(i).nl)]); end;
  if isfield(a(i),'ng'), disp(['  ng = ',int2str(a(i).ng)]); end;
  if isfield(a(i),'accept'), disp(['  accept = ',int2str(a(i).accept)]); end;
end;