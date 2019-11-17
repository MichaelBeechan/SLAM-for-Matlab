%EXTRACTBEACONS   extract beacons from range data
%   L = EXTRACTBEACONS(BEACONDATA,PARAMS,DISPLAY) extracts beacons
%   from the raw measurements in BEACONDATA and returns them in
%   the local map L. 
%
%   A jump distance greater than PARAMS.BEACONTHRESHDIST is the
%   segmentation criterion and initiates a new beacon cluster. The
%   threshold PARAMS.MINNPOINTS rejects clusters which have less
%   points than the threshold value. PARAMS.CB is a constant 2x2
%   default covariance matrix of the beacon uncertainty. Readings
%   on the same cluster are averaged using an information filter.
%
%   With the flag DISPLAY = 1, the extraction result is plotted in
%   a new figure window.
%
%   See also EXTRACTLINES, MEANWM.

% v.1.0, Kai Arras, Nov. 2003, CAS-KTH
% v.1.1, Kai Arras, Dec. 2003, CAS-KTH: bug fix for single beacon case

function L = extractbeacons(bcndata,params,displ);

% Algorithm parameters
THRESHDIST = params.beaconthreshdist; % jump distance for segmentation
COVB       = params.Cb;               % constant default beacon uncertainty
MINNPOINTS = params.minnpoints;       % min. nof raw points on reflector

% Step 0: {S} --> {R}
xS = bcndata.steps.data2;
yS = bcndata.steps.data3;
sint = sin(bcndata.params.xs(3));
cost = cos(bcndata.params.xs(3));
xR = xS*cost - yS*sint + bcndata.params.xs(1);
yR = xS*sint + yS*cost + bcndata.params.xs(2);
beacons = [xR,yR];

% Step 1: segmentation
n = size(beacons,1);
if n > 0,
  nclust = 1;
  for i = 1:n,
    beacons(i,4) = nclust;
    j = mod(i, n) + 1;
    dij = norm(beacons(i,1:2)-beacons(j,1:2));
    if dij > THRESHDIST,
      beacons(i,3) = 1;
      if i < n,
        nclust = nclust + 1;  % increase only if not last
      end;
    else
      beacons(i,3) = 0;
    end;
  end;
  
  % Step 2: treat cyclic scan: wrap last (=first) segment
  if beacons(n,3) ~= 1,
    idfirst = beacons(1,4);
    idlast  = beacons(n,4);
    idcs = find(beacons(:,4)==idlast);
    beacons(min(idcs):max(idcs),4)=idfirst;
  end;
  
  % Step 3: fit: take multivariate weighted mean and fill in L
  created = 0; ibeacon = 1;
  for i = 1:nclust;
    % search for occurrences of clustid...
    xv = []; Cv = [];
    npoints = 0;      % nof raw points on reflector
    for j = 1:n,
      if beacons(j,4) == i,
        npoints = npoints + 1;
        xv = cat(2,xv,beacons(j,1:2)');
        Cv = cat(3,Cv,COVB);
      end;
    end;
    if npoints >= MINNPOINTS,
      if ~created,
        L = map('local map',0);
        created = 1;
      end;
      % ... and fuse all beacon points
      [xw,Cw] = meanwm(xv,Cv);
      % create point feature
      p = pointfeature(ibeacon,xw,Cw);
      % add it to local map
      L = addentity(L, p);
      % increase beacon index (= id)
      ibeacon = ibeacon + 1;
    else
      % disp(['extractbeacons: min nof points condition: np = ',int2str(npoints)]);
    end;
  end;
  if created,
    X = get(L,'x');
    nL = length(X);
  else
    L = []; nL = 0;
  end;
  
  if nL == 0, str1 = 'no'; str2 = 'beacons';
  elseif nL == 1, str1 = '1'; str2 = 'beacon';
  else str1 = int2str(nL); str2 = 'beacons';
  end; disp([' ',str1,' ',str2,' extracted']);
  
  % Step 4: plot if desired
  if displ,
    figure(2); clf; hold on; set(gca,'Box','on'); axis equal;
    title('Local map: extracted beacons');
    drawreference(zeros(3,1),'R',1.0,'k');
    plot(xR,yR,'.','Color',[.8 .8 .8],'MarkerSize',6);
    for i = 1:nL,
      xi = get(X{i},'x');
      Ci = get(X{i},'c');
      id = get(X{i},'id');
      drawprobellipse([xi(1); xi(2); 0],Ci,0.95,[.7 .7 .7]);
      plot(xi(1),xi(2),'d',xi(1),xi(2),'+','Color',[0 (nL-i+1)/nL 1-(nL-i+1)/nL],'MarkerSize',10)
      drawlabel([xi(1); xi(2); 0],int2str(id),0.18,0.07,'k');
    end;
    axisvec = axis;
    axis(1.1*axisvec); % enlarge slightly figure axes
  end;
else
  L = [];
end;