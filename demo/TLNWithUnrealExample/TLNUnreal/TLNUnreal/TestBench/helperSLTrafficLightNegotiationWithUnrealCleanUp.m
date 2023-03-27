% Clean up script for the Traffic Light Negotiation  with Unreal Engine
% Visualization
%
% This script cleans up the example model. It is triggered by the
% CloseFcn callback.
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2020-2021 The MathWorks, Inc.

clear BusActors1
clear BusDetectionConcatenation1
clear BusDetectionConcatenation1Detections
clear BusDetectionConcatenation1DetectionsMeasurementParameters
clear BusLaneBoundaries1
clear BusLaneBoundaries1LaneBoundaries
clear BusLaneCenter
clear BusLanes
clear BusLanesLaneBoundaries
clear BusMultiObjectTracker1
clear BusMultiObjectTracker1Tracks
clear BusRadar
clear BusRadarDetections
clear BusRadarDetectionsMeasurementParameters
clear BusRadarDetectionsObjectAttributes
clear BusVehiclePose
clear BusVision
clear BusVisionDetections
clear BusVisionDetectionsMeasurementParameters
clear BusVisionDetectionsObjectAttributes
clear Cf
clear Cr
clear FB_decel
clear Iz
clear LaneSensor
clear LaneSensorBoundaries
clear M
clear N
clear PB1_decel
clear PB2_decel
clear PredictionHorizon
clear ControlHorizon
clear ReferencePathInfo
clear Ts
clear ans
clear assigThresh
clear default_spacing
clear driver_decel
clear Default_decel
clear egoVehDyn
clear egoVehicle
clear hFigResults
clear hFigure
clear headwayOffset
clear intersectionInfo
clear lf
clear logsout
clear lr
clear m
clear maxMIOLeadDistance
clear max_ac
clear max_dc
clear max_steer
clear min_ac
clear min_steer
clear numSensors
clear numTracks
clear posSelector
clear referencePathInfo
clear referencePathSwitchThreshold
clear refpathSize
clear scenario
clear setVelocity
clear stopVelThreshold
clear tau
clear tau2
clear TimeFactor
clear timeMargin
clear timeToReact
clear time_gap
clear trafficLightConfig
clear v0_ego
clear vehSim3D
clear vehicleLength
clear velSelector
clear waypointsSize
clear xlimit
clear ylimit
clear egoActorID
