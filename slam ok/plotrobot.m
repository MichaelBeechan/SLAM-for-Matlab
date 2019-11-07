function plotrobot( xpos, ypos, theta, color, filled, fillColor)
% PLOTROBOT

WAS_HOLD = ishold;

if ~WAS_HOLD
    hold on
end

radius = 13;

plotcircle( [xpos ypos], radius, 100, color, filled, fillColor);

orientationLine = [ xpos xpos+cos(theta)*(radius+3);
		    ypos ypos+sin(theta)*(radius+3)];

plot( orientationLine(1,:), orientationLine(2,:),'Color','black',...
      'LineWidth', 2);

if ~WAS_HOLD
    hold off
end
