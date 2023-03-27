function hFigure = helperEvaluateLaneMarkerDetector(logsout, scenario,...
    detectionRange,varargin)
%Evaluates lane boundary models against ground truth and plots average
%distance between detected lane points and ground truth lane points.
%
%   hFigure = helperEvaluateLaneMarkerDetector(logsout, scenario,cameraParams) 
%   extracts lane information from logsout and evaluates lane boundaries 
%   computed from lane marker detection algorithm against ground truth. It
%   also plots average deviations between lane detections and ground truth.
%   Below are the required inputs: 
% 
%   'logsout'           Output Simulink log. This function assumes that the
%                       test bench model outputs the Simulink log, logsout, 
%                       containing the "lane_detections"
%                       and "lane_boundaries" elements. 
%   'scenario'          drivingScenario object
%   'detectionRange'    Detection range of the lane detection algorithm
% 
%   Evaluate lane detections against ground truth using preset lateral
%   distance threshold as below:
% 
%   hFigure = helperEvaluateLaneMarkerDetector(logsout, scenario, cameraParams, LateralDistThresold) 
%
%   'LateralDistThresold' Maximum lateral distance in meters between a lane
%                         boundary model and ground truth point for
%                         that point to be considered a valid match 
%
%   Example - Evaluate lane detections using helperEvaluateLaneMarkerDetector
%   -------------------------------------------------------------------------
%
%   % Run the setup script to get scenario object and camera sensor
%   parameters
%   helperSLHighwayLaneFollowingSetup("scenario_LFACC_03_Curve_StopnGo",...
%       "VisionProcessingAlgorithm");
%
%   % Simulate HighwayLaneFollowingTestBench.slx model
%   simout = sim('HighwayLaneFollowingTestBench.slx');
% 
%   Get scenario and camera sensor parameters from workspace
%   scenario = evalin('base','scenario');
%   detectionRange = evalin('base','camera.LaneDetectionRanges');
%
%   Run helperEvaluateLaneMarkerDetector to get the plots that shows lane
%   deviations between detections and ground truth.
%   helperEvaluateLaneMarkerDetector(simout.logsout, scenario, detectionRange);
%
%   Specify maximum lateral distance, in meters as below:
%   helperEvaluateLaneMarkerDetector(simout.logsout, scenario,...
%            detectionRange,'LateralDistThresold',0.5);

%   This is a helper function for example purposes and
%   may be removed or modified in the future.

% Copyright 2019 The MathWorks, Inc.

defaultlateralDistThresold = 0.4;
p = inputParser;
addParameter(p,'LateralDistThresold',defaultlateralDistThresold,@isnumeric);
parse(p,varargin{:});
lateralDistThresold = p.Results.LateralDistThresold;

% Get logged signals from simulation log
hLaneDetections   = logsout.get('lane_detections').Values;
hLaneBoundaries   = logsout.get('lane_boundaries').Values;

numSamples = scenario.StopTime/scenario.SampleTime + 1;
% laneMetrics(:,1) contains average left lane deviations between left lane
% detections and ground truth. 
% laneMetrics(:,2) contains average right lane deviations between right lane
% detections and ground truth.
laneMetrics = zeros(numSamples,2);

for sampleIndex = 1:numSamples
    i = sampleIndex;
    % Get left lane ground truth information from simulation log
    leftLaneTruth = hLaneBoundaries.LaneBoundaries(1);
    
    % Get left lane detections information from simulation log
    laneStrength = hLaneDetections.Left.Strength.Data(sampleIndex);
    laneCurvature = hLaneDetections.Left.Curvature.Data(sampleIndex);
    laneHeadingAngle = hLaneDetections.Left.HeadingAngle.Data(sampleIndex);
    laneLateralOffset = hLaneDetections.Left.LateralOffset.Data(sampleIndex);
    laneXExtent = hLaneDetections.Left.XExtent.Data(1,:,sampleIndex);
    laneBoundaryType = hLaneDetections.Left.BoundaryType.Data(sampleIndex);
    
    % Evaluate lane boundaries for valid left lanes
    if laneStrength > 0
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
        leftLaneTruthData = leftLaneTruth.Coordinates.Data(:,1:2,sampleIndex);
        leftTruthParameters = polyfit(leftLaneTruthData(:,1),...
            leftLaneTruthData(:,2),2);
        leftTruth = parabolicLaneBoundary(leftTruthParameters);
        leftTruth.Strength =  leftLaneTruth.Strength.Data(1,1,i);
        leftTruth.BoundaryType = leftLaneTruth.BoundaryType.Data(1,1,sampleIndex);
        leftTruth.XExtent = laneXExtent;
        
        % Evaluate left lane boundaries computed from lane detections
        % against lane boundaries computed from ground truth using
        % evaluateLaneBoundaries   
        [~,~,~,leftLaneAssignments] = evaluateLaneBoundaries(...
            laneBoundaries.Left,leftTruth,lateralDistThresold,detectionRange);
        averageLeftLaneDistance = computeLaneStatistics(...
            laneBoundaries.Left,leftTruth,leftLaneAssignments, @mean);
        laneMetrics(i,1) =  averageLeftLaneDistance;
    end
    
    % Get right lane ground truth information from simulation log
    rightLaneTruth = hLaneBoundaries.LaneBoundaries(2);
    
    % Get right lane detections information from simulation log
    laneStrength = hLaneDetections.Right.Strength.Data(sampleIndex);
    laneCurvature = hLaneDetections.Right.Curvature.Data(sampleIndex);
    laneHeadingAngle = hLaneDetections.Right.HeadingAngle.Data(sampleIndex);
    laneLateralOffset = hLaneDetections.Right.LateralOffset.Data(sampleIndex);
    laneXExtent = hLaneDetections.Right.XExtent.Data(1,:,sampleIndex);
    laneBoundaryType = hLaneDetections.Right.BoundaryType.Data(sampleIndex);
    
    % Evaluate lane boundaries for valid right lanes
    if laneStrength > 0
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
        rightLaneTruthData = rightLaneTruth.Coordinates.Data(:,1:2,sampleIndex);
        rightTruthParameters = polyfit(rightLaneTruthData(:,1),...
            rightLaneTruthData(:,2),2);
        rightTruth = parabolicLaneBoundary(rightTruthParameters);
        rightTruth.Strength =  rightLaneTruth.Strength.Data(1,1,i);
        rightTruth.BoundaryType = rightLaneTruth.BoundaryType.Data(1,1,sampleIndex);
        rightTruth.XExtent = laneXExtent;
        
        % Evaluate right lane boundaries computed from lane detections
        % against lane boundaries computed from ground truth using
        % evaluateLaneBoundaries
        [~,~,~, rightLaneAssignments] = evaluateLaneBoundaries(...
            laneBoundaries.Right,rightTruth,lateralDistThresold,detectionRange);
        averageRightLaneDistance = computeLaneStatistics(...
            laneBoundaries.Right,rightTruth,rightLaneAssignments, @mean);
        laneMetrics(i,2) = averageRightLaneDistance;
    end
end
time = hLaneBoundaries.Time.Time;
hFigure = figure('Name','Vision Perception algorithm performance');
tmax = hLaneBoundaries.Time.Time(end);

subplot(2,1,1);
stem(time, laneMetrics(:,1),'Color','b')
grid on
title('Average Left Lane Deviation');
xlim([0,tmax]);
xlabel('time (sec)')
ylabel('Distance in Meters')

subplot(2,1,2);
stem(time, laneMetrics(:,2),'Color','r')
title('Average Right Lane Deviation');
xlim([0,tmax])
grid on
xlabel('time (sec)')
ylabel('Distance in Meters')
end

function stat = computeLaneStatistics(estBoundary, gtBoundary, assignments, fcnHandle)
% computeLaneStatistics computes statistics between estimated lane
% boundaries and ground truth lane boundaries
% Ignore false positive assignments.
if assignments{1}(1) == 0
    stat =  NaN;
else
    xVehiclePoints = 6:30;
    estPoints = estBoundary.computeBoundaryModel(xVehiclePoints);
    gtPoints = gtBoundary.computeBoundaryModel(xVehiclePoints);
    yDist = abs(estPoints - gtPoints);
    stat = fcnHandle(yDist);
end
end
