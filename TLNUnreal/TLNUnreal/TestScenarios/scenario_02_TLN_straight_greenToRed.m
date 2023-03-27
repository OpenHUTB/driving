function [scenario, egoVehicle, referencePathInfo, intersectionInfo, trafficLightConfig] = scenario_02_TLN_straight_greenToRed()
% scenario_02_TLN_straight_greenToRed  creates a scenario that is
% compatible with TLNWithUnrealTestBench.slx. This open
% loop scenario has an intersection and contains ego vehicle that travels
% at a constant velocity of 10 m/s straight at the intersection.

%  Copyright 2020-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TLNWithUnrealTestBench.slx
[scenario, referencePathInfo, intersectionInfo] = ...
    helperGetTrafficLightScenario("Straight");

%% Add the ego vehicle
% The ego actor ID is 67.
egoVehicle = scenario.Actors(67);

% Ego vehicle speed.
speed = 10; % m/s

% Generate a trajectory for the ego vehicle.
trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%%
% Set initial traffic light state for this test scenario.
% 0 Red 
% 1 Yellow
% 2 Green
trafficLightConfig.initialState = 2;

% Set the state change distance threshold.
trafficLightConfig.stateChangeDistance = 12;

% State that will be applied to traffic light when ego vehicle reaches
% stateChangeDistance.
trafficLightConfig.changeState = 0;

% Simulation stop time.
scenario.StopTime = 10;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
