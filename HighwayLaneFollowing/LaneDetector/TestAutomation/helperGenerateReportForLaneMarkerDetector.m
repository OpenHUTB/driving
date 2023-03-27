function helperGenerateReportForLaneMarkerDetector(logsout)
% helperGenerateReportForLaneMarkerDetector plots figures and video for
% generating report from Automate Testing For Lane Marker Detector
% example. It takes logsout that is logged from simulation runs of
% LaneMarkerDetectorTestBench model. It is invoked from the CLEANUP
% callback of the test cases from Simulink Test.

% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2020-2021 The MathWorks, Inc.
 
% Plot lane boundary parameters 
helperPlotLaneBoundaryParams(logsout);

% Plot average lane deviations between the detected lanes and 
% their corresponding ground truth data
scenario = evalin('base','scenario');
camera = evalin('base','camera');

% Get output file name for the video logged during the simulation to 
% capture front view of the ego vehicle.
scenarioFcnName = evalin('base','scenarioFcnName');
fileLocation = evalin('base','cameraOutputFileDir');
forwardCameraOutputFile = fileLocation+"/"+scenarioFcnName+ '.mp4';
recordedVideoFileName = fileLocation+"/"+scenarioFcnName;

helperPlotLaneDetectionResults(...
logsout, forwardCameraOutputFile , scenario, camera,scenarioFcnName,...
"RecordVideo", true,"RecordVideoFileName", recordedVideoFileName); 

% Delete front view video after the video with detections is recorded.
delete(forwardCameraOutputFile);
end
