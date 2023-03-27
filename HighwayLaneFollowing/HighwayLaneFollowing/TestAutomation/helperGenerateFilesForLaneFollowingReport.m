function helperGenerateFilesForLaneFollowingReport(logsout)
% helperGenerateFilesForLaneFollowingReport plots figures and video for
% generating report from Automate Testing For Highway Lane Following
% example. It takes logsout that is logged from simulation runs of
% HighwayLaneFollowingTestBench model. It is invoked from the CLEANUP
% callback of the test cases from Simulink Test.

% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2019-2021 The MathWorks, Inc.
 
% Plot longitudinal results
time_gap = evalin('base','time_gap');
default_spacing = evalin('base','default_spacing');
helperPlotLFLongitudinalResults(logsout,time_gap,default_spacing);

% Plot lateral results
helperPlotLFLateralResults(logsout);

% Plot average lane deviations between the detected lanes and 
% their corresponding ground truth data
scenario = evalin('base','scenario');
camera = evalin('base','camera');
laneDetectionRange = camera.LaneDetectionRanges;
helperEvaluateLaneMarkerDetector(logsout, scenario, laneDetectionRange);

% Get output file name for the video logged during the simulation to 
% capture front view of the ego vehicle.
cameraOutputFileDir = evalin('base','cameraOutputFileDir');
scenarioFcnName = evalin('base','scenarioFcnName');
forwardCameraOutputFile = cameraOutputFileDir+"/"+scenarioFcnName+ '.mp4';
recordedVideoFileName = cameraOutputFileDir+"/"+scenarioFcnName;

% Plot lane and vehicle detection results on the front view frames and
% generate another video with detections.
radar = evalin('base','radar');
helperPlotLFDetectionResults(...
    logsout, forwardCameraOutputFile, scenario, camera, radar,...
    scenarioFcnName,...
    'DisplayBEPLegend', false, ...
    'RecordVideo',true,...
    'RecordVideoFileName', recordedVideoFileName);

% Delete front view video after the video with detections is recorded.
delete(forwardCameraOutputFile);
end