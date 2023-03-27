function [scenario, referencePathInfo, intersectionInfo] = helperGetTrafficLightScenario(referencePathType)
%helperGetTrafficLightScenario Get the driving scenario for
%TLNWithUnrealTestBench.slx.
%
%   [scenario, referencePathInfo, intersectionInfo] =
%   helperGetTrafficLightScenario(referencePathType) gets the driving
%   scenario object, reference path information, and intersection
%   information needed for TLNWithUnrealTestBench.slx.
%   The referencePathType specifies the type of ego vehicle motion in the
%   scene at the intersection. Possible valid values of referencePathType
%   are as described below:
%
%   'referencePathType'      "Straight" - Ego vehicle travels straight at
%                            the intersection.
%
%                            "Left" - Ego vehicle takes left
%                            turn at the intersection.
%
%
%   'scenario'               Driving scenario
%
%   'referencePathInfo'      Predefined reference path information that the
%                            ego vehicle relies on at the intersection
%                            where there is no lane marking.
%
%   'intersectionInfo'       Intersection information like position of
%                            traffic light and intersection center.
%
%
%   Example - Configure a test scenario using helperGetTrafficLightScenario
%   -------------------------------------------------------------
%   % Define the direction for the ego vehicle at the intersection
%   referencePathType = "Left";
%
%   % Get the compatible scenario.
%   [scenario, referencePathInfo, intersectionInfo] = ...
%                        helperGetTrafficLightScenario(referencePathType);
%
%   % Add the ego vehicle
%   egoVehicle = scenario.Actors(1);
%
%   % Define the speed
%   speed = 8;
%
%   % Define the trajectory with the waypoints from referencePathInfo for
%   the ego vehicle.
%   trajectory(egoVehicle, referencePathInfo.waypoints, speed);
%
%
%   % Explore the scenario using Driving Scenario Designer
%   drivingScenarioDesigner(scenario);
%

%   This is a helper function for example purposes and may be removed or
%   modified in the future.

% Copyright 2020 The MathWorks, Inc.

%% Construct a drivingScenario equivalent of the US City Block
% Use Driving Scenario Designer to load prebuilt session file,
% "USCityBlock".
% drivingScenarioDesigner('USCityBlock.mat');
%
% Use the export option to save the scene as "USCityBlock.m" file. This
% example ships this USCityBlock.m file to load the scenario.
scenario = USCityBlock();

% define sample time in the scenario object
scenario.SampleTime = 0.1;

%% Get reference path information from MAT-file
% Based on the direction of travel select the reference path information
if(referencePathType == "Straight")
    load('referencePathsForUSCityBlock.mat', 'straightReferencePath');
    referencePathInfo  = straightReferencePath;
elseif(referencePathType == "Left")
    load('referencePathsForUSCityBlock.mat', 'leftReferencePath');
    referencePathInfo  = leftReferencePath;
else
    error('Not a valid direction of travel');
end

%% Add three vehicles to the scene.
% One Ego and two target vehicles.
% Vehicle profiles must match vehicles in Simulink model.

% Define the default position for the target vehicles.
defaultVehiclePosition = [-26.6 -96.2 0];

% helperAddVehicle function is used to add the
% vehicles to the scenario as below.
%
% helperAddVehicle(scenario, <VehicleType>, <StartPosition>);
%
% Add ego vehicle and other target vehicles to the scenario at default
% positions.
% As there are 66 static actors present in the USCity Block scene, the
% actor IDs for this vehicle will start from 67.
% Actor ID for the Ego Vehicle is 67.
helperAddVehicle(scenario, "Sedan", defaultVehiclePosition);
% Actor Id for target vehicle 1 is 68.
helperAddVehicle(scenario, "Sedan", defaultVehiclePosition);
% Actor ID for target vehicle 2 is 69.
helperAddVehicle(scenario, "Sedan", defaultVehiclePosition);

%% Intersection information
% Update intersection center information corresponding to Traffic light id
% 15 and 16.
intersectionInfo.intersectionCenter = [-20.34 0 0];

% Traffic Light ID that the ego vehicle needs to negotiate with at the
% intersection.
intersectionInfo.trafficLightToNegotiate = 16;

% The stop line position is treated as the traffic light position since the
% ego vehicle has to be stopped before the stop line based on the traffic
% light state.
intersectionInfo.tlStopLinePosition = [-30.9000 0.2000];

end