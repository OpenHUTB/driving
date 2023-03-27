function [scenario, egoVehicle, referencePathInfo, intersectionInfo, trafficLightConfig] = scenario_04_TLN_straight_redToGreen_with_cross_vehicle()
% scenario_04_TLN_straight_redToGreen_with_cross_vehicle  creates a
% scenario that is compatible with
% TLNWithUnrealTestBench.slx. This open loop scenario
% has an intersection and contains two vehicles. In open loop, the ego
% vehicle continues to travel straight at the intersection. A cross traffic
% vehicle travels in the other road in a direction perpendicular to the ego
% travel direction.

%  Copyright 2020-2021 The MathWorks, Inc.

%%
%  Get driving scenario that is compatible with
%  TLNWithUnrealTestBench.slx.
[scenario, referencePathInfo, intersectionInfo] = ...
    helperGetTrafficLightScenario("Straight");

%% Add the ego vehicle
% The ego actor ID is 67.
egoVehicle = scenario.Actors(67);

% Ego vehicle speed.
speed = 10; % m/s

% Generate a trajectory for the ego vehicle.
trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%% Add the target actors. 
% Cross traffic vehicle travels with constant speed of 7.2 m/s in a
% direction perpendicular to ego vehicle.
% The Actor ID for the first target vehicle is 68.
crossTraffic = scenario.Actors(68);

% Define waypoints for the cross traffic vehicle.
waypoints = [-25.6 -62 0;
    -24.3 24.6 0;
    -24.3 63.8 0;
    -24 103 0];

% Define speed for the cross traffic vehicle.
speed = 7.2;

% Generate a trajectory for the cross traffic vehicle.
trajectory(crossTraffic, waypoints, speed);
%%
% Set initial traffic light state for this test scenario.
% 0 Red 
% 1 Yellow
% 2 Green
trafficLightConfig.initialState = 0;

% Set the state change distance threshold.
trafficLightConfig.stateChangeDistance = 11;

% State that will be applied to traffic light when ego vehicle reaches
% stateChangeDistance.
trafficLightConfig.changeState = 2;

% Simulation stop time.
scenario.StopTime = 13;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
