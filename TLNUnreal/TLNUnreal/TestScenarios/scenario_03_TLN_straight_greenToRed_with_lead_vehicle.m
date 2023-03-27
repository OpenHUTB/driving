function [scenario, egoVehicle, referencePathInfo, intersectionInfo, trafficLightConfig, stopLinesPositions] = scenario_03_TLN_straight_greenToRed_with_lead_vehicle()
% scenario_03_TLN_straight_greenToRed_with_lead_vehicle creates a scenario
% that is compatible with TLNWithUnrealTestBench.slx.
% This open loop scenario has an intersection and contains two vehicles.
% The lead vehicle moves at a constant speed of 8 m/s. In open loop, there
% is an expected collision between the ego vehicle and lead car. The ego
% vehicle continues to travel straight at the intersection.

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

trajectory(egoVehicle, referencePathInfo.waypoints, speed);

%% Add the target actors. 
% Lead Vehicle moves with a constant velocity of 8 m/s in the ego lane
% and ahead of ego vehicle.
% The Actor ID for the first target vehicle is 68.
leadVehicle = scenario.Actors(68);

% Waypoints along which the lead vehicle should follow.
waypoints = [-75 2 0;
    11.1 2 0;
    47.6 2 0;
    58.2 2 0];

% Speed with which the lead vehicle travels.
speed = 8;

trajectory(leadVehicle, waypoints, speed);

%%
% Set initial traffic light state for this test scenario.
% 0 Red 
% 1 Yellow
% 2 Green
trafficLightConfig.initialState = 2;

% Set the state change distance threshold.
trafficLightConfig.stateChangeDistance = 10;

% State that will be applied to traffic light when ego vehicle reaches
% stateChangeDistance.
trafficLightConfig.changeState = 0;

% Simulation stop time.
scenario.StopTime = 11;

%% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario);
