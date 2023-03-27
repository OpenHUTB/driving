function distanceToTrafficLight  = helperSLComputeDistanceToTrafficLight(trafficLightPosition, currentEgoPose, prevDistanceToLight, minTLDist)
%helperSLComputeDistanceToTrafficLight Compute distance to upcoming traffic
%light.
%
% Current Ego position and the upcoming traffic light position information
% are used for calculating distance to traffic light. 
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%

% Copyright 2019-2021 The MathWorks, Inc.

% Once the vehicle reaches the traffic light, it should see the next
% traffic light if any. In this example, there is no next traffic light so
% the next traffic light is assumed at infinite distance. 
%
% if the previous distance between the vehicle and the traffic light is
% less than the minTLDist, then it is treated that vehicle has passed the
% light.

if(prevDistanceToLight < minTLDist || prevDistanceToLight == Inf)
    distanceToTrafficLight = inf;
else
    % Euclidean distance to upcoming traffic light from the current
    % position of ego vehicle.
    %
    distanceToTrafficLight = double(sqrt((trafficLightPosition(1)-currentEgoPose(1))^2 + ...
        (trafficLightPosition(2)-currentEgoPose(2))^2));
end
end
