function [relativeDistance,relativeVelocity,mioTrackIndex] = helperFindMIOTrack(tracks, lane, positionSelector, velocitySelector, maxDistance)
% This function finds the most important track (MIO): a track in front of
% the ego car that satisfies all the criteria below:
% * Within the ego car's lane.
% * In front of the ego car.
% * Closest to the ego car.

% Note: If you change state definition, change the following:
%       State = [x;vx;y;vy;z;vz] (3D constant velocity)

% Copyright 2019-2021 The MathWorks, Inc.

% Initialize outputs and parameters
mioTrackIndex = 0;

% If lane detection is not available, the ego car is assumed to be located
% in the middle of its lane. The lane width is assumed to be 3.6m, typical
% highway lane width.
laneWidth = 3.6;
halfLaneWidth = laneWidth/2;

if lane.Left.Strength > 0.01
    lb = [lane.Left.CurvatureDerivative/6,...
        lane.Left.Curvature/2,...
        lane.Left.HeadingAngle,...
        lane.Left.LateralOffset];
else
    lb = single([0,0,0,halfLaneWidth]);
end

if lane.Right.Strength > 0.01
    rb = [lane.Right.CurvatureDerivative/6,...
        lane.Right.Curvature/2,...
        lane.Right.HeadingAngle,...
        lane.Right.LateralOffset];
else
    rb = single([0,0,0,-halfLaneWidth]);
end

minDist = cast(maxDistance, 'like', tracks.Tracks(1).State);
for i = 1:tracks.NumTracks
    thisState = tracks.Tracks(i).State;
    pos = positionSelector * thisState;
    relativeDistance = pos(1); % Longitudinal position of this track
    latPos = pos(2);           % Lateral position of this track
    
    if relativeDistance < minDist && relativeDistance > 0 % No point checking otherwise
        
        latLeftLane  = polyval(lb,relativeDistance); % lateral position of left lane
        latRightLane = polyval(rb,relativeDistance); % lateral position of right lane
        
        % Find a new MIO track
        if (latRightLane <= latPos) && (latPos <= latLeftLane)
            minDist = relativeDistance;
            mioTrackIndex(:) = i;
        end
    end
end

if mioTrackIndex>0
    mioState = tracks.Tracks(mioTrackIndex).State;
    mioPos = positionSelector * mioState;
    mioVel = velocitySelector * mioState;
    
    % Output:
    relativeDistance = mioPos(1); % Longitudinal position of the MIO track
    relativeVelocity = mioVel(1); % Longitudinal velocity of the MIO track
    
%     relativeDistance = norm(mioPos(1:2));    % Longitudinal position of the lead car
%     uRel = mioPos(1:2)/relativeDistance;
%     mioVel = mioState([2 4]);
%     relativeVelocity = mioVel(:)'*uRel(:);
else
    % Output:
    relativeDistance = cast(inf,'like',minDist); % Longitudinal position of the lead car
    relativeVelocity = cast(inf,'like',minDist); % Longitudinal velocity of the lead car
end


