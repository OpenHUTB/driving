function helperPlotPathMobileArm(start,waypoints,logicalMap)
% Copyright 2021 The MathWorks, Inc.

goal = waypoints(end,:);
binaryMap = binaryOccupancyMap(logicalMap,10);
show(binaryMap)
hold on
r=0.5;
% Show the start and goal in the grid map
plot([start(1), start(1) + r*cos(start(3))], [start(2), start(2) + r*sin(start(3))], 'r-' )
plot([goal(1), goal(1) + r*cos(goal(3))], [goal(2), goal(2) + r*sin(goal(3))], 'm-' )
hold on

% Interpolate and plot path
%interpolate(pthObj,300)
plot(waypoints(:,1), waypoints(:,2), 'r-', 'LineWidth', 2)

hold on

end