function [posX, posY, index] = helperGetPositionFromWaypoint(waypoints, distance)

% helperGetPositionFromWaypoint gets the intermediate way point that is at
% distance meters from initial position.

% Required inputs 
%   waypoints: Array of way points 
%   distance: Distance between intial position and required position.

% Output:
%   posX: X position of intermediate point 
%   posY: Y position of intermediate point 
%   index = Index of waypoint that is closest to intermediate way
%   point in waypoints array.

%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2019 The MathWorks, Inc.

startIndex = 1;
index = [];
actualDist = 0;

% Run the loop to get the closest road centers for the desired intermediate
% road center
for i= startIndex : length(waypoints)-startIndex-1
    x0 = waypoints(i,1);
    x1 = waypoints(i+1,1);
    y0 = waypoints(i,2);
    y1 = waypoints(i+1,2);
    presentDist = sqrt(((y1-y0)^2)+ ((x1-x0)^2));
    actualDist = actualDist + presentDist;
    if(isempty(index) && actualDist > distance)
        % getting the headWayPoint index in waypoints
        index = i+1;
        d = (actualDist - distance);
        maxStep = presentDist - d;   
        x = [x0, x1];
        y = [y0, y1];
        separation = max([abs(diff(x))'; abs(diff(y))'])';
        step = ceil(separation/maxStep);
        posX = ((x(2)-x(1))/step) + x(1);
        posY = ((y(2)-y(1))/step) + y(1);
        break;
    end
end

end