function [scenario, assessment] = scenario_LF_02_Straight_LeftLane
% scenario_LF_02_Straight_LeftLane creates a scenario that is compatible
% with HighwayLaneFollowingTestBench.slx This test scenario is on a
% Straight road. There are no other vehicles in this test scenario. Ego car
% travels by following the lanes. 

%   Copyright 2019 The MathWorks, Inc.

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingTestBench.slx

[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Straight road");

%% EgoCar: Set position, speed using trajectory
% Actors(1) is EgoCar in this scenario. 

EgoCar = scenario.Actors(1);
% EgoCar travels in Lane4 with speed 15m/s
% Place EgoCar in Lane4 

Lane4CenterY = laneInfo(4).LaneCenters(1,2);
waypoints = [...
    0   Lane4CenterY 0;
    300 Lane4CenterY 0];
speed = 15;
trajectory(EgoCar, waypoints, speed);

% Simulation stop time
scenario.StopTime = 10;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
