% Clean up script for the Forward Vehicle Sensor Fusion Example
%
% This script cleans up the Forward vehicle sensor example model. It is
% triggered by the CloseFcn callback.
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2020 The MathWorks, Inc.

clear BusActors1;
clear BusDetectionConcatenation1;
clear BusDetectionConcatenation1Detections;
clear BusDetectionConcatenation1DetectionsMeasurementParameters;
clear assigThresh;
clear BusObjectDetections1;
clear BusObjectDetections1Detections;
clear BusRadar;
clear BusVehiclePose;
clear BusVision;
clear BusVisionDetections;
clear BusVisionDetectionsMeasurementParameters;
clear BusVisionDetectionsObjectAttributes;
clear BusLaneDetections1;
clear BusLaneDetections1LaneBoundaries;
clear camera;
clear M;
clear N;
clear numSensors;
clear numTracks;
clear radar;
clear scenario;
clear Ts;
clear BusObjectDetections;
clear BusTrackerJPDA;
clear BusTrackerJPDATracks;
clear Epsilon
clear MinNumPoints
clear P
clear R
clear alpha
clear cutOffDistance
clear order 
clear switchingPenalty
clear vehSim3D
clear assessment