function [leftLaneMetrics, leftLaneStatus, averageLeftLaneDistance,...
    rightLaneMetrics, rightLaneStatus, averageRightLaneDistance] ...
    = helperComputeLaneMetrics(detectedLanes, groundTruthLanes, detectionRange, varargin)
%helperComputeLaneMetrics computes metrics by assessing the detected lane boundaries 
% against ground truth.  

%   [leftLaneMetrics, leftLaneStatus, averageLeftLaneDistance,...
%       rightLaneMetrics, rightLaneStatus, averageRightLaneDistance] ...
%       = helperComputeLaneMetrics(detectedLanes, groundTruthLanes, detectionRange) 
%   computes lane metrics by evaluating the lane boundaries 
%   computed from lane marker detection algorithm against ground truth.
%
%   Required inputs: 
%   'detectedLanes'             Detected lanes from lane marker detector 
%                               algorithm
%   'groundTruthLanes'          Lane Boundaries from scenario reader block
%   'detectionRange'            Detection range of the lane detection 
%                               algorithm

%   Outputs:
%   'leftLaneMetrics'           Array that contains number of left lane 
%                               matches, number of left lane misses and
%                               number of left lane false positives.
%   'leftLaneStatus'            True if the detected left lane boundary
%                               matches with corresponding ground truth
%                               lane boundary.
%   'averageLeftLaneDistance'   Average distance between the points that
%                               are computed along with lane detection
%                               range from detected left lane boundaries
%                               and the left lane boundaries from the
%                               scenario.
%   'rightLaneMetrics'          Array that contains number of right lane
%                               matches, number of right lane misses and
%                               number of right lfalse positives. 
%   'rightLaneStatus'           True if the detected right lane boundary
%                               matches with corresponding ground truth
%                               lane boundary.
%   'averageRightLaneDistance'  Average distance between the points that
%                               are computed along with lane detection
%                               range from detected right lane boundaries
%                               and the right lane boundaries from the
%                               scenario.
% 
%   Compute lane metrics using ground truth using preset lateral
%   distance threshold as below:
% 
%   [leftLaneMetrics, leftLaneStatus, averageLeftLaneDistance,...
%       rightLaneMetrics, rightLaneStatus, averageRightLaneDistance] ...
%       = helperComputeLaneMetrics(detectedLanes, groundTruthLanes,,...
%           detectionRange,LateralDistThresold)  
%
%   'LateralDistThresold'       Maximum lateral distance in meters between
%                               a lane boundary model and ground truth
%                               point for that point to be considered a
%                               valid match
%   
%   This is a helper function for example purposes and
%   may be removed or modified in the future.

% Copyright 2020 The MathWorks, Inc.

% Initialize leftLaneMetrics and rightLaneMetrics
leftLaneMetrics = zeros(1,3);
rightLaneMetrics = zeros(1,3);

% parse LateralDistThresold from varargin
defaultlateralDistThresold = 0.7;
p = inputParser;
addParameter(p,'LateralDistThresold',defaultlateralDistThresold,@isnumeric);
parse(p,varargin{:});
lateralDistThresold = p.Results.LateralDistThresold;

% Get left lane ground truth information 
leftLaneTruth = groundTruthLanes.LaneBoundaries(1);

% Get left lane detections information 
laneStrength = detectedLanes.Left.Strength;
laneCurvature = detectedLanes.Left.Curvature;
laneHeadingAngle = detectedLanes.Left.HeadingAngle;
laneLateralOffset = detectedLanes.Left.LateralOffset;
laneXExtent = detectedLanes.Left.XExtent;
laneBoundaryType = detectedLanes.Left.BoundaryType;

%% Evaluate lane boundaries for valid left lanes

% Construct parabolicLaneBoundary from left lane detections. This
% boundary is used for evaluating it against ground truth
% using evaluateLaneBoundaries
laneBoundaries.Left = parabolicLaneBoundary([...
    laneCurvature/2,...
    laneHeadingAngle,...
    laneLateralOffset]);
laneBoundaries.Left.Strength = laneStrength;
laneBoundaries.Left.XExtent = laneXExtent;
laneBoundaries.Left.BoundaryType = laneBoundaryType;

% Construct left lane parabolicLaneBoundary from ground truth
leftLaneTruthData = leftLaneTruth.Coordinates;
leftTruthParameters = polyfit(leftLaneTruthData(:,1),...
    leftLaneTruthData(:,2),2);
leftTruth = parabolicLaneBoundary(leftTruthParameters);
leftTruth.Strength =  leftLaneTruth.Strength;
leftTruth.BoundaryType = leftLaneTruth.BoundaryType;
leftTruth.XExtent = laneXExtent;

% Evaluate left lane boundaries computed from lane detections
% against lane boundaries computed from ground truth using
% evaluateLaneBoundaries
[leftLaneMatch, leftLaneMiss, leftLaneFalsePositive,leftLaneAssignments] = evaluateLaneBoundaries(...
    laneBoundaries.Left,leftTruth,lateralDistThresold,detectionRange);
averageLeftLaneDistance = computeLaneStatistics(...
    laneBoundaries.Left,leftTruth,leftLaneAssignments,detectionRange, @mean);

leftLaneMetrics(1,1) = leftLaneMatch;
leftLaneMetrics(1,2) = leftLaneMiss;
leftLaneMetrics(1,3) = leftLaneFalsePositive;

% Set leftLaneStatus if left lane is matched with ground truth
if (leftLaneMatch == 1)
    leftLaneStatus = 1;
else
    leftLaneStatus = 0;
end

%% Evaluate lane boundaries for valid left lanes
% Get right lane ground truth information 
rightLaneTruth = groundTruthLanes.LaneBoundaries(2);

% Get right lane detections information
laneStrength = detectedLanes.Right.Strength;
laneCurvature = detectedLanes.Right.Curvature;
laneHeadingAngle = detectedLanes.Right.HeadingAngle;
laneLateralOffset = detectedLanes.Right.LateralOffset;
laneXExtent = detectedLanes.Right.XExtent;
laneBoundaryType = detectedLanes.Right.BoundaryType;

% Evaluate lane boundaries for valid right lanes
% Construct parabolicLaneBoundary from right lane detections. This
% boundary is used for evaluating it against ground truth
% using evaluateLaneBoundaries
laneBoundaries.Right = parabolicLaneBoundary([...
    laneCurvature/2,...
    laneHeadingAngle,...
    laneLateralOffset]);
laneBoundaries.Right.Strength = laneStrength;
laneBoundaries.Right.XExtent = laneXExtent;
laneBoundaries.Right.BoundaryType = laneBoundaryType;

% Construct right lane parabolicLaneBoundary from ground truth
rightLaneTruthData = rightLaneTruth.Coordinates;
rightTruthParameters = polyfit(rightLaneTruthData(:,1),...
    rightLaneTruthData(:,2),2);
rightTruth = parabolicLaneBoundary(rightTruthParameters);
rightTruth.Strength =  rightLaneTruth.Strength;
rightTruth.BoundaryType = rightLaneTruth.BoundaryType;
rightTruth.XExtent = laneXExtent;

% Evaluate right lane boundaries computed from lane detections
% against lane boundaries computed from ground truth using
% evaluateLaneBoundaries
[rightLaneMatch, rightLaneMiss, rightLaneFalsePositive, rightLaneAssignments] = evaluateLaneBoundaries(...
    laneBoundaries.Right,rightTruth,lateralDistThresold,detectionRange);
averageRightLaneDistance = computeLaneStatistics(...
    laneBoundaries.Right,rightTruth,rightLaneAssignments, detectionRange,@mean);

% Set rightLaneStatus if right lane is matched with ground truth
if (rightLaneMatch == 1)
    rightLaneStatus = 1;
else
    rightLaneStatus = 0;
end

rightLaneMetrics(1,1) = rightLaneMatch;
rightLaneMetrics(1,2) = rightLaneMiss;
rightLaneMetrics(1,3) = rightLaneFalsePositive;

end

function stat = computeLaneStatistics(estBoundary, gtBoundary, assignments, detectionRange, fcnHandle)
    % computeLaneStatistics computes statistics like mean or median between
    % estimated lane boundaries and ground truth lane boundaries Ignore
    % false positive assignments.
    if assignments{1}(1) == 0
        stat =  0;
    else
        xVehiclePoints = detectionRange(1):detectionRange(2);
        estPoints = estBoundary.computeBoundaryModel(xVehiclePoints);
        gtPoints = gtBoundary.computeBoundaryModel(xVehiclePoints);
        yDist = abs(estPoints - gtPoints);
        stat = fcnHandle(yDist);
    end
end

