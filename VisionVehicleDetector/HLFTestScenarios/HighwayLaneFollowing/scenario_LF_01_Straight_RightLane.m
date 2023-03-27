function [scenario, assessment] = scenario_LF_01_Straight_RightLane
% scenario_LF_01_Straight_RightLane creates a scenario that is compatible
% with HighwayLaneFollowingTestBench.slx. This test scenario is on a
% Straight road. There are no other vehicles in this test scenario. Ego car 
% travels by following the lanes.

%   Copyright 2019 The MathWorks, Inc.

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Straight road");

%% EgoCar: Set position, speed using trajectory
% Actors(1) is EgoCar in this scenario. 

EgoCar = scenario.Actors(1);
% EgoCar travels in Lane5 with speed 15m/s
% Place EgoCar in Lane5 
Lane5CenterY  = laneInfo(5).LaneCenters(1,2);
waypoints = [...
    0   Lane5CenterY 0;
    300 Lane5CenterY 0];
speed = 15;
trajectory(EgoCar, waypoints, speed);

% Simulation stop time
scenario.StopTime = 10;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)

