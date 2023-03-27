function dist = helperComputeDistanceToTruth(track,truth)
% This function computes the distance between track and a truth.

% Copyright 2020 The MathWorks, Inc.

% Errors in each aspect
[posError,velError] =  helperComputeErrorToTruth(track,truth);

% Distance is the sum of errors
dist = posError + velError;

end

function [posError,velError] = helperComputeErrorToTruth(track,truth)
% Errors as a function of target track and associated truth.
% Get true information from the ground truth.
truePos = truth.Position(1:2)';

% Position is at the rear axle for all vehicles. We would like to compute
% the error from the center of the vehicle
rot = [cosd(truth.Yaw) -sind(truth.Yaw);sind(truth.Yaw) cosd(truth.Yaw)];
truePos = truePos + rot*[2.8/2;0];

trueVel = truth.Velocity(1:2);

estPos = track.State([1 3]);
estVel = track.State([2 4]);

% Compute 2-norm of error for each attribute.
posError = norm(truePos(:) - estPos(:));
velError = norm(trueVel(:) - estVel(:));
end
