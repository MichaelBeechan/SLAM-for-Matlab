function plotfield( detectedMarker)
% PLOTFIELD

global FIELDINFO;

WAS_HOLD = ishold;

if ~WAS_HOLD
    hold on
end

margin = 200;

axis manual;
axis([-margin, FIELDINFO.COMPLETE_SIZE_X+margin, -margin, FIELDINFO.COMPLETE_SIZE_Y+margin]);

for i = 1:6
  if i == detectedMarker
    plotcircle([FIELDINFO.MARKER_X_POS(i), FIELDINFO.MARKER_Y_POS(i)], ...
	       15, 200, 'black',1, [0.8 0.8 0.8]);
  else
    plotcircle([FIELDINFO.MARKER_X_POS(i), FIELDINFO.MARKER_Y_POS(i)], ...
	       15, 200, 'black',1, 'white');
  end
  text(FIELDINFO.MARKER_X_POS(i)-2, FIELDINFO.MARKER_Y_POS(i), num2str(i));
end

if ~WAS_HOLD
    hold off
end

