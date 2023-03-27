function [scenario,assessment] = scenario_LD_01_Curve_ThreeVehicles
% scenario_LD_01_Curve_ThreeVehicles creates a driving scenario that is
% compatible with LaneMarkerDetectorTestBench.slx. This test scenario is on
% a Curved road segment and contains three vehicles in the scene including
% the ego car.  The other two cars : passing car and slow moving car move
% initially in adjacent lane. Passing car over takes slow moving car by
% cutting into ego vehicle's lane and cuts out from ego vehicle's lane.

%   Copyright 2020-2021 The MathWorks, Inc.

% Get driving scenario that is compatible with LaneMarkerDetectorTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Curved road segment");

% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - FastCar
%		Actors(3) - SlowCar

%% EgoCar: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
% Speed = 20.6 m/s
egoCar = scenario.Actors(1);
% Get waypoints from laneCenters. 
% Place the EgoCar in Lane3.
waypoints = laneInfo(3).LaneCenters;
speed = 20.6;
trajectory(egoCar, waypoints(3:end,:), speed);

%% PassingCar : The following describes the requirement of PassingCar 
% Segment-1: Starts moving at 60m ahead of initial waypoint in Lane2 and
% travels for 30m. 
% Segment-2: Cut-in to EgoCar's lane to avoid SlowCar in
% Lane1 at 90m from initial Lane1 waypoint and Cut-out from EgoCar's lane
% to Lane2 after overtaking Slow car at 200m from initial Lane2 waypoint.
% Segment-3: Travels in Lane1 till the end of waypoints
passingCar = scenario.Actors(2);

% PassingCar - Segment-1: Set position and speed 
% Place the PassingCar in the adjacent lane i.e in Lane2
waypoints = laneInfo(2).LaneCenters;

% Get and set the initial position at 60 m from the first waypoint in Lane1
distanceFromFirstWaypoint = 60;
[posX, posY, segment1StartIndex] = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsPassingCar = [posX posY 0];


% Get and set the segment-1 end position at 90 m from the first waypoint in Lane2 
distanceFromFirstWaypoint  = distanceFromFirstWaypoint+30;
[~, ~, segment1EndIndex ]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsPassingCar = [waypointsPassingCar; waypoints(segment1StartIndex:segment1EndIndex-1,:)];
speed = 19.6*ones(length(waypointsPassingCar),1);

% PassingCar - Segment-2: Set position and speed
% Get the waypoints in Lane3, as the PassingCar changes lane to Lane3
% Using flipped version of laneCenters to move the Lead car.
waypoints = laneInfo(3).LaneCenters;
% Get and set the Segment-2 end position at 200 m from the first waypoint
% in Lane3
distanceFromFirstWaypoint  = 200;
[~, ~, segment2EndIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);

% Skip immediate way points while cutting in to Lane3 so that the smooth
% trajectory is generated.
waypointsPassingCar = [waypointsPassingCar;waypoints(segment1EndIndex+3:segment2EndIndex-1,:)];
numWaypoints = length(waypoints(segment1EndIndex+3:segment2EndIndex-1,:)); 
speed = [speed;19.6*ones(numWaypoints-1,1)];

% PassingCar - Segment-3: Set position and speed
% Get the waypoints in Lane2, as the PassingCar changes lane to Lane2
waypoints = laneInfo(2).LaneCenters;
% Skip immediate way points while cutting in to Lane1 so that the smooth
% trajectory is generated.
waypointsPassingCar = [waypointsPassingCar;waypoints(segment2EndIndex+5:end,:)];
numWaypoints = length(waypoints(segment2EndIndex+5:end,:));
speed = [speed;18.5*ones(numWaypoints+1,1)];

% Set trajectory for PassingCar
trajectory(passingCar, waypointsPassingCar, speed);

%% SlowCar - Travels in Lane1 with constant speed of 11.1 m/s
slowCar = scenario.Actors(3);
% Place the SlowCar in adjacent lane but moving in another direction i.e in
% Lane2.
waypoints = laneInfo(2).LaneCenters;
% Set the initial position at 110 m from the first waypoint
distanceFromFirstWaypoint  = 110;
[posX, posY, ...
    slowCarStartWayPointIndex] = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
    
waypointsSlowCar = [posX posY 0];
waypointsSlowCar = [waypointsSlowCar; waypoints(slowCarStartWayPointIndex:end,:)];
speed =11.1*ones(length(waypointsSlowCar),1);

% Set trajectory for SlowCar
trajectory(slowCar, waypointsSlowCar, speed);

% Simulation stop time
scenario.StopTime = 15;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)

