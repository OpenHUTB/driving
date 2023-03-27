function [scenario,assessment] = scenario_ACC_02_Straight_StopnGo
% scenario_ACC_02_Straight_StopnGo creates a scenario that is compatible
% with HighwayLaneFollowingControllerTestBench.slx This test scenario is on
% a Straight road. There are four vehicles in this test scenario. LeadCar
% moves in the same lane as that of EgoCar. Slow moving cars travels in
% other lane. In open loop, there is an expected collision between ego
% vehicle and lead car.
%
%   Copyright 2020-2021 The MathWorks, Inc.

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingControllerTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Straight road");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar
%		Actors(3) - SlowCar1
%       Actors(4) - SlowCar2

%% EgoCar: Set position, speed using trajectory
EgoCar = scenario.Actors(1);
% EgoCar travels in Lane4 with speed 27m/s
% Place EgoCar in Lane4
Lane5CenterY  = laneInfo(4).LaneCenters(1,2);
waypoints = [...
    1   Lane5CenterY 0;
    700 Lane5CenterY 0];
speed = 27;
trajectory(EgoCar, waypoints, speed);
%% LeadCar: The following describes the path of Lead Car.  
% Lead car moves with initial speed 27 m/s. 
% It slows down to 15m/sec at -3m/sec^2 and stays constant for 7sec.
% Then speeds up to 25m/sec at 2.5m/sec^2

leadCar = scenario.Actors(2);
waypoints = [...
    51   Lane5CenterY 0;
    229.5 Lane5CenterY 0;
    380.5 Lane5CenterY 0;
    418.5 Lane5CenterY 0;
    498.5 Lane5CenterY 0;
    673.5 Lane5CenterY 0;
    790   Lane5CenterY 0];

speed = [27;27;15;15;25;25;25];
trajectory(leadCar, waypoints, speed);

%% SlowCar1 moves in the adjacent lane i.e in Lane5 with constant speed of 12m/s.
slowCar1 = scenario.Actors(3);
Lane5CenterY = laneInfo(5).LaneCenters(1,2);
waypoints = [...
    40 Lane5CenterY 0;
    700 Lane5CenterY 0];
speed = 12;
trajectory(slowCar1, waypoints, speed);

%% SlowCar2 moves in the adjacent lane i.e in Lane5 with constant speed of 12m/s.
slowCar2 = scenario.Actors(4);
waypoints = [...
    80 Lane5CenterY 0;
    700 Lane5CenterY 0];
speed = 12;
trajectory(slowCar2, waypoints, speed);

% Simulation stop time
scenario.StopTime = 18;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)