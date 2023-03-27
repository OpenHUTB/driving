function [scenario,assessment] = scenario_LFACC_02_Curve_AutoRetarget(nvp)
% scenario_LFACC_02_Curve_AutoRetarget creates a driving scenario that is
% compatible with HighwayLaneFollowingTestBench.slx. This test
% scenario is on a Curved road segment and contains three vehicles in the
% scene. In this scenario, the lead vehicle travels with 13.9m/s and
% changes lane to over take the slow moving car in it's lane. The third
% car, which is a slow moving car moves with a constant speed of 10m/s. In
% open loop, there is an expected collision between ego vehicle and slow
% moving car.
%

% Copyright 2020 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

% Get driving scenario that is compatible with
% HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario(...
    "Curved road segment");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar
%		Actors(3) - SlowCar
%% Ego Car: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
% Speed = 14 m/s
egoCar = scenario.Actors(1);
% Get waypoints from laneCenters. 
% Place the EgoCar in Lane3.
waypoints = laneInfo(3).LaneCenters;
speed = 15;

% Set trajectory for EgoCar
trajectory(egoCar, waypoints, speed);

%% Lead Car: The following describes the path of Lead Car.
% LeadCar changes lane from Lane3 to Lane2.
leadCar = scenario.Actors(2);
waypointsLane2 = laneInfo(3).LaneCenters;
waypointsLane1 = laneInfo(2).LaneCenters;

% Initialize LeadCar position at 38m ahead of EgoCar. 
distanceFromFirstWaypoint  = 38;
[leadCarInitialX, leadCarInitialY, leadCarInitialIndex] = ...
    helperGetPositionFromWaypoint(waypointsLane2,distanceFromFirstWaypoint);
waypointsleadCar = [leadCarInitialX leadCarInitialY 0];

% Do lane change at a distance of 46m. 
distanceForLaneChange  = 46;
[~, ~, leadCarCutinIndex] = helperGetPositionFromWaypoint(...
    waypointsLane2,distanceForLaneChange);

waypointsleadCar = [waypointsleadCar; ...
    waypointsLane2(leadCarInitialIndex:leadCarCutinIndex-1,:);...
    waypointsLane1(leadCarCutinIndex+3:end,:)];

% Set speed as 13.9m/sec
speed =13.9*ones(length(waypointsleadCar),1);

% Set trajectory for LeadCar
trajectory(leadCar, waypointsleadCar, speed);

%% SlowCar: Travel with constant speed of 10 m/s in EgoLane
slowCar = scenario.Actors(3);
% Place the SlowCar in EgoLane
waypoints = laneInfo(3).LaneCenters;
% Set the initial position at 60 m from the first waypoint.
distanceFromFirstWaypoint  = 60;
[posX, posY, initialWaypointIndex] = helperGetPositionFromWaypoint(...
    waypoints,distanceFromFirstWaypoint);
waypointsSlowCar = [posX posY 0];
waypointsSlowCar = [waypointsSlowCar; waypoints(initialWaypointIndex:end,:)];

% Set speed as 10 m/s
speed =10*ones(length(waypointsSlowCar),1);

% Set trajectory for SlowCar
trajectory(slowCar, waypointsSlowCar, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 18;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 10;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
