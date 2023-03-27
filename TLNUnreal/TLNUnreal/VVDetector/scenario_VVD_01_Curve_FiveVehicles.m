function [scenario,assessment] = scenario_VVD_01_Curve_FiveVehicles(nvp)
% scenario_VVD_01_Five_Vehicles creates a driving scenario that is
% compatible with VisionVehicleDetectorTestBench.slx. This test scenario is
% on a Curved road segment and contains six vehicles in the scene. In this
% scenario, the lead vehicle goes with constant speed in front of ego
% vehicle while others travel in adjacent lanes.

%   Copyright 2021 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

%  Get driving scenario that is compatible with
%  HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario(...
    "Curved road segment");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar
%		Actors(6) - SlowCar1
%		Actors(4) - SlowCar2
%		Actors(3) - FastCar1


%% EgoCar: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
% Speed = 14 m/s
egoCar = scenario.Actors(1);
% Get waypoints from laneCenters.  
% Place the EgoCar in Lane3.
waypoints = laneInfo(3).LaneCenters;
speed = 14;

% Set trajectory for EgoCar
trajectory(egoCar, waypoints, speed);

%% LeadCar: The following describes the path of Lead Car.  
% Initial head way time for Lead car is 13.6s and initial speed
% is 14 m/s.
leadCar = scenario.Actors(2);
% Place the Lead car in the same lane as Ego car.
% Place the LeadCar in Lane3.
waypoints = laneInfo(3).LaneCenters;

% LeadCar- Set position and speed 
% Initialize Lead Car position at 20m ahead of ego vehicle. 
distanceFromFirstWaypoint  = 20;

% Get and set first way point for the Lead car in Segment-1
[posX, posY, ...
    leadCarStartIndex] = helperGetPositionFromWaypoint(...
    waypoints, distanceFromFirstWaypoint);
waypointsLeadCar = [posX posY 0];
waypointsLeadCar = [waypointsLeadCar; ...
    waypoints(leadCarStartIndex:end,:)];

speed =14*ones(length(waypointsLeadCar),1);

% Set trajectory for LeadCar
trajectory(leadCar, waypointsLeadCar, speed);

%% SlowCar1: Travel with constant speed of 8 m/s in Lane4
slowCar1 = scenario.Actors(6);
% Place the SlowCar1 in adjacent lane but moving in counter clockwise direction.
% Place the SlowCar1 in Lane4.
waypoints = laneInfo(4).LaneCenters;
% Set the initial position at 1100 m from the first waypoint
distanceFromFirstWaypoint = 1100;

[posX, posY,...
    slowCar1StartWayPointIndex ] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar1 = [posX posY 0];
waypointsSlowCar1 = [waypointsSlowCar1; ...
    waypoints(slowCar1StartWayPointIndex:end,:)];
speed =14*ones(length(waypointsSlowCar1),1);

% Set trajectory for SlowCar1
trajectory(slowCar1, waypointsSlowCar1, speed);


%% SlowCar2: Travel with a constant speed of 8 m/s in 
% adjacent lane with some distance from SlowCar1.
slowCar2 = scenario.Actors(4);
% Place the SlowCar2 in Lane4.
waypoints = laneInfo(4).LaneCenters;
% Set the initial position at 1090 m from the first waypoint
distanceFromFirstWaypoint = 1090;
[posX, posY, ...
    slowCar2InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar2 = [posX posY 0];
waypointsSlowCar2 = [waypointsSlowCar2;...
    waypoints(slowCar2InitialWayPointIndex:end,:)];

speed = 14*ones(length(waypointsSlowCar2),1);

% Set trajectory for SlowCar2
trajectory(slowCar2, waypointsSlowCar2, speed);

%% FastCar1: Travel with a constant speed of 14 m/s in Lane2.
fastCar1 = scenario.Actors(3);
% Place the FastCar1 in Lane2.
waypoints = laneInfo(2).LaneCenters;
% Set the initial position at 15 m from the first waypoint
distanceFromFirstWaypoint = 15;
[posX, posY, fastCar1InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar1 =  [posX posY 0];
waypointsFastCar1 = [waypointsFastCar1; waypoints(fastCar1InitialWayPointIndex:end,:)];
speed = 14*ones(length(waypointsFastCar1),1);

% Set trajectory for FastCar1.
trajectory(fastCar1, waypointsFastCar1, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 25;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 12;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
