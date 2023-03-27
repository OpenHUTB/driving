function [scenario, assessment] = scenario_LFACC_06_Straight_StopandGoLeadCar(nvp)
% scenario_LFACC_06_Straight_StopandGoLeadCar creates a scenario that is
% compatible with HighwayLaneFollowingTestBench.slx This test scenario is
% on a Straight road. There are three vehicles in this test scenario. There
% is breakdown vehicle in the ego lane. Another Car  moves in the adjacent
% lane of ego lane.

%   Copyright 2020 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Straight road");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar
%		Actors(3) - PassingCar

%% EgoCar: Set position, speed using trajectory
EgoCar = scenario.Actors(1);
% EgoCar travels in Lane4 with speed 30m/s
% Place EgoCar in Lane4 
Lane4CenterY  = laneInfo(4).LaneCenters(1,2);
waypoints = [...
    0   Lane4CenterY 0;
    790 Lane4CenterY 0];
speed = 25;
trajectory(EgoCar, waypoints, speed);

%% LeadCar: The following describes the path of Lead Car.  
% Initial head way time for Lead car is 2.2sec and initial speed
% is 15 m/s and travels with constant acceleration till it
% reaches a velocity of 22m/sec.

leadCar = scenario.Actors(2);
waypoints = [...
    76     Lane4CenterY 0;
    148    Lane4CenterY 0;
    186.25 Lane4CenterY 0;
    790    Lane4CenterY 0];
speed = [0;15;22;22];
waittime = [4.5;0;0;0];
trajectory(leadCar, waypoints, speed, waittime);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 3;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 2.5;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
