function [scenario, assessment] = scenario_FVSF_04_Straight_ThreeVehicles(nvp)
% scenario_FVSF_04_Straight_ThreeVehicles creates a scenario that is
% compatible with ForwardvehicleSesorFusionTestBench.slx This test scenario
% is on a Straight road. There are three vehicles in this test scenario
% including ego vehicle. Lead car travels in the ego lane with a constant
% velocity of 16 m/s and other target vehicle travels in right lane
% adjacent to lead car with a constant velocity of 16 m/s.

%   Copyright 2021 The MathWorks, Inc.

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
%		Actors(2) - LeadCar
%		Actors(3) - Car1
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

%% LeadCar: The following describes the path of Lead Car.  
% Initial head way time for Lead car is 2.2sec and initial speed
% is 16 m/s.

leadCar = scenario.Actors(2);
waypoints = [...
    25     Lane4CenterY 0;
    148    Lane4CenterY 0;
    186.25 Lane4CenterY 0;
    790    Lane4CenterY 0];
speed = 16;

trajectory(leadCar, waypoints, speed);

Lane5CenterY  = laneInfo(5).LaneCenters(1,2);

%% Car1: The following describes the path of Car1.  
% Car1 initial speed is 16 m/s and travels with constant velocity in
% adjacent lane to ego lane.
Car1 = scenario.Actors(3);
waypoints = [...
    25     Lane5CenterY 0;
    148    Lane5CenterY 0;
    186.25 Lane5CenterY 0;
    790    Lane5CenterY 0];
speed = 16;

trajectory(Car1, waypoints, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 15;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 10;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
