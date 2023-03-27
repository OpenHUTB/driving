% Clean up script for the Automate Real-Time Testing for Forward Vehicle
% Sensor Fusion Example
%
% This script cleans up the RTForwardVehicleSensorFusionTarget.slx model.
% It is triggered by the CloseFcn callback.
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2021 The MathWorks, Inc.

clear assigThresh
clear BusRadar
clear BusSimulation3DRadarTruthSensor1Detections
clear BusSimulation3DRadarTruthSensor1DetectionsMeasurementParameters
clear BusSimulation3DRadarTruthSensor1DetectionsObjectAttributes
clear BusTrackerJPDA
clear BusTrackerJPDATracks
clear BusVision
clear BusVisionDetections
clear BusVisionDetectionsMeasurementParameters
clear BusVisionDetectionsObjectAttributes
clear Epsilon
clear M
clear MinNumPoints
clear N
clear numSensors
clear numTracks
clear P
clear R
clear Ts
clear RTConfig
clear maxNumRadarDets
clear maxNumTracks
clear maxNumVisionDets