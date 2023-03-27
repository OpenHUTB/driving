function egoRefPath = helperEgoRefPathCreator(scenario, egoActorID)
% helperEgoRefPathCreator creates reference path for ego vehicle from the
% driving scenario.
%
% Inputs:
%
% scenario:     driving scenario object.
% egoActorID:   Actor ID of the ego vehicle in the scenario.
%
% Outputs:
%  egoRefPath: ego reference path.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2021 The MathWorks, Inc.

restart(scenario);
rec = record(scenario); % Run driving scenario and record actor states
num = length(rec);
time = zeros(num,1);
x = zeros(num,1);
y = zeros(num,1);
theta = zeros(num,1);
speed = zeros(num,1);
kappa = zeros(num,1);

for i = 1:num
    time(i)  = rec(i).SimulationTime;
    x(i)     = rec(i).ActorPoses(egoActorID).Position(1);
    y(i)     = rec(i).ActorPoses(egoActorID).Position(2);
    theta(i) = deg2rad(rec(i).ActorPoses(egoActorID).Yaw);
    speed(i) = norm(rec(i).ActorPoses(egoActorID).Velocity(1:2));
    if(speed(i) > 0)
        kappa(i) = deg2rad(rec(i).ActorPoses(egoActorID).AngularVelocity(3))/speed(i);
    end
end

egoRefPath.time = time;
egoRefPath.x  = x;
egoRefPath.y = y;
egoRefPath.theta = theta;
egoRefPath.kappa = kappa;
egoRefPath.speed = speed;
egoRefPath.numPoints = num;

restart(scenario);