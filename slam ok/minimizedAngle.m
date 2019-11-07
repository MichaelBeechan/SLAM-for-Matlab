function angle = minimizedAngle( angle)
while angle < -pi
  angle = angle + 2*pi;
end
while angle >= pi
  angle = angle - 2*pi;
end
