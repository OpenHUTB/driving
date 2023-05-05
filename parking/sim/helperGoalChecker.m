function reachGoal = helperGoalChecker(nextGoal, currPose, currVel, endRefVel, direction)
%helperGoalChecker Check if the current pose has reached the goal pose
% 
% Copyright 2018 The MathWorks, Inc.

% The goal checker acts when the distance from the vehicle to the goal
% point is within a distance tolerance, disTol. 
disTol = 3; % meters
distToGoal = norm(nextGoal(1:2) - currPose(1:2));

if distToGoal > disTol
    reachGoal = false;
    return
end

% Check if the vehicle has passed the goal position by checking the angle
% between two vectors
vectorGoalTangent  = [cosd(nextGoal(3)), sind(nextGoal(3))];
vectorNormalToPath = [currPose(1)-nextGoal(1), currPose(2)-nextGoal(2)];

passGoal = (vectorGoalTangent*vectorNormalToPath'*direction > 0);

% Steps of goal checking:
% 1) If the vehicle passes the goal, check its current velocity. 
% 2) If the velocity is less than a threshold, assume the vehicle stops.
% Otherwise, check the reference velocity at the goal position.
% 3) If the goal reference velocity is non-zero, then assume the vehicle  
% reaches the goal. If the goal reference velocity is zero, i.e., the 
% vehicle is supposed to stop at the goal position, then allow the vehicle 
% to move until its velocity decreases below the threshold.

velTol = 0.05; % meters/second

if passGoal 
    if abs(currVel) < velTol
        reachGoal = true;
    else
        if endRefVel ~= 0
            reachGoal = true;
        else
            reachGoal = false;
        end
    end
else
    if abs(currVel) < velTol 
        reachGoal = true;
    else
        reachGoal = false;
    end  
end

