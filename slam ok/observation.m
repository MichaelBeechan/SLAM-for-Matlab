%-------------------------------------------------------
% shift state
%-------------------------------------------------------
function [obs, H] = observation( state, fieldInfo, id)

% Compute expected observation.
dx = fieldInfo.MARKER_X_POS( id) - state(1);
dy = fieldInfo.MARKER_Y_POS( id) - state(2);
dist = sqrt( dx^2 + dy^2);

obs = [ dist;
	minimizedAngle(atan2(dy, dx) - state(3));
	id ];

% what is H?

