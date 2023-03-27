function [scenario,assessment] = scenario_LF_03_Curve_LeftLane
% scenario_LF_03_Curve_LeftLane creates a scenario that is compatible with
% HighwayLaneFollowingTestBench.slx This test scenario is on a
% Curved road segment. There are no other vehicles in this test scenario. EgoCar
% travels by following the lanes.

% Copyright 2019 The MathWorks, Inc.

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Curved road segment");
%% EgoCar: Set position, speed using trajectory
% Actors(1) is EgoCar in this scenario. 
EgoCar = scenario.Actors(1);
% EgoCar travels in Lane3 with speed 20.6m/s
% Place EgoCar in Lane3 
waypoints = (laneInfo(3).LaneCenters);
speed = 20.6;
trajectory(EgoCar, waypoints, speed);
% Simulation stop time
scenario.StopTime = 18;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)



