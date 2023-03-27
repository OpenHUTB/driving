function [scenario, assessment] = scenario_FVSF_02_Straight_FourVehicles(nvp)
% scenario_FVSF_02_Straight_FourVehicles creates a scenario that is
% compatible with ForwardvehicleSesorFusionTestBench.slx This test scenario
% is on a Straight road. There are four vehicles in this test scenario
% including ego vehicle. The three cars initially travels at 15 m/s
% and attains 22m/s. Two cars move in the adjacent lane of ego lane.

%   Copyright 2020-2021The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

%  Get driving scenario that is compatible with
%  ForwardvehicleSesorFusionTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Straight road");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - Car1
%		Actors(3) - Car2
%       Actors(4) - Car3
% 
%% EgoCar: Set position, speed using trajectory
EgoCar = scenario.Actors(1);
% EgoCar travels in Lane4 with speed 16m/s
% Place EgoCar in Lane4 
Lane4CenterY  = laneInfo(4).LaneCenters(1,2);
waypoints = [...
    0   Lane4CenterY 0;
    790 Lane4CenterY 0];
speed = 16;
trajectory(EgoCar, waypoints, speed);

%% Car1: The following describes the path of Car1.  
% Initial head way time for Car1 is 2.2sec and initial speed
% is 15 m/s and travels with constant acceleration till it
% reaches a velocity of 22m/sec.

Car1 = scenario.Actors(2);
waypoints = [...
    25     Lane4CenterY 0;
    148    Lane4CenterY 0;
    186.25 Lane4CenterY 0;
    790    Lane4CenterY 0];
speed = [15;15;22;22];

trajectory(Car1, waypoints, speed);

Lane5CenterY  = laneInfo(5).LaneCenters(1,2);

%% Car2: The following describes the path of Car2.  
% Car2 initial speed is 16 m/s and travels with constant acceleration
% till it reaches a velocity of 22m/sec.
Car2 = scenario.Actors(3);
waypoints = [...
    10     Lane5CenterY 0;
    148    Lane5CenterY 0;
    186.25 Lane5CenterY 0;
    790    Lane5CenterY 0];
speed = [16;16;22;22];

trajectory(Car2, waypoints, speed);

%% Car3: The following describes the path of Car3.  
% Car3 initial speed is 16 m/s and travels with constant acceleration
% till it reaches a velocity of 22m/sec.
Car3 = scenario.Actors(4);
waypoints = [...
    20     Lane5CenterY 0;
    148    Lane5CenterY 0;
    186.25 Lane5CenterY 0;
    790    Lane5CenterY 0];
speed = [16;16;22;22];

trajectory(Car3, waypoints, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 20;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 15;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
