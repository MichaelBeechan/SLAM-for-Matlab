% Toolbox initialization script. Needs to be called once per session.
% For toolbox version 1.0, Jan. 2004, koa, CAS-KTH

% Clear command window
clc;
disp(' ');
disp('           The CAS Robot Navigation Toolbox version 1.0');
disp('                    Copyright (c) 2004 CAS-KTH');
disp('       This is free software without any warranty. You are');
disp('    welcome to redistribute it under the conditions described');
disp('        in the licence files included in this distribution');
disp(' ');

% Add all paths of the toolbox recursively
% (this command works on all platforms)
path(path,genpath(pwd));

% Call chi2invtable once to put table into memory
% (not needed but accelerates first call)
chi2invtable(0.5,2);

% Add your initializations here if needed
% ...
% ...

% Notify user
disp('inittoolbox: Paths added, lookup table in memory');