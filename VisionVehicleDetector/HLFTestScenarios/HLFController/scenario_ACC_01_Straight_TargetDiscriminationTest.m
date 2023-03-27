function [scenario,assessment] = scenario_ACC_01_Straight_TargetDiscriminationTest
% scenario_ACC_01_Straight_TargetDiscriminationTest creates a scenario that
% is compatible with HighwayLaneFollowingControllerTestBench.slx This test
% scenario is on a Straight road. There are three vehicles in this test
% scenario. LeadCar moves in the same lane as that of EgoCar. Another Car
% moves in the adjacent lane of ego lane.
%
%   Copyright 2020-2021 The MathWorks, Inc.

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingControllerTestBench.slx
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
speed = 30;
trajectory(EgoCar, waypoints, speed);

%% LeadCar: The following describes the path of Lead Car.  
% Initial head way time for Lead car is 2.2sec and initial speed
% is 24 m/s and travels with constant acceleration of 2m/sec^2 till it
% reaches a velocity of 27m/sec.

leadCar = scenario.Actors(2);
waypoints = [...
    76     Lane4CenterY 0;
    148    Lane4CenterY 0;
    186.25 Lane4CenterY 0;
    790    Lane4CenterY 0];
speed = [24;24;27;27];
trajectory(leadCar, waypoints, speed);

%% PassingCar: The following describes the path of passing Car.  
% Passing car moves in the adajacent lane with constant speed 24 m/s 
% Place PassingCar in Lane5
passingCar = scenario.Actors(3);
Lane4CenterY = laneInfo(5).LaneCenters(1,2);
waypoints = [...
    76  Lane4CenterY 0;
    790 Lane4CenterY 0];
speed = 24;
trajectory(passingCar, waypoints, speed);

% Simulation stop time
scenario.StopTime = 25;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
