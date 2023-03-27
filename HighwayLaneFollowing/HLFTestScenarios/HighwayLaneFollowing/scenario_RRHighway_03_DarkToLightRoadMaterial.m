function [scenario, assessment] = scenario_RRHighway_03_DarkToLightRoadMaterial()
% scenario_RRHighway_03_DarkToLightRoadMaterial creates a driving scenario by
% importing the OpenDRIVE file from the RoadRunner scene. This scenario
% contains five other vehicles in the scene. In this scenario the vehicles travel
% from a road segment with darker road material to the segment with lighter
% road material.

%   Copyright 2020 The MathWorks, Inc.

% Get the scenario object from OpenDRIVE file, corresponding laneInfo and
% assessment
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("RR Highway road");
% Ego and Target Vehicles representation in this test case.
%       Actors(1) - EgoCar
%       Actors(2) - LeadCar
%       Actors(3) - AdjacentCar
%       Actors(4) - FastCar1
%       Actors(5) - FastCar2
%       Actors(6) - SlowCar

%% EgoCar: Set position, speed using trajectory
% Add Trajectory for EgoCar. This vehicle travels in lane number 5 and
% starts at 2700 meters from initial waypoint. Set the velocity of the
% vehicle to 10 m/s

egoCar = scenario.Actors(1);

% Place EgoCar in lane number 5
waypoints = laneInfo(5).LaneCenters;
speed = 10;

% Find the start waypoint for Egocar at a distance of 2700 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 2700;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for Egocar at a distance of 3050 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3050;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for EgoCar
waypointsEgoCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(egoCar, waypointsEgoCar, speed);

%% LeadCar: Set position, speed using trajectory
% Add Trajectory for LeadCar. This vehicle travels in lane number 5 and
% starts at a distance of 35 meters from the ego vehicle. Set velocity of
% the vehicle to 10 m/s

leadCar = scenario.Actors(2);

% Place LeadCar in lane number 5
waypoints = laneInfo(5).LaneCenters;
speed = 10;

% Find the start waypoint for LeadCar at a distance of 2735 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 2735;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for LeadCar at a distance of 3090 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3090;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for LeadCar.
waypointsLeadCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(leadCar, waypointsLeadCar, speed);

%% AdjacentCar: Set position, speed using trajectory
% Add Trajectory for AdjacentCar. This vehicle travels in lane number 4 and
% starts at a distance of 2710 meters from the initial waypoint of lane
% number 4. Set velocity of the vehicle to 10 m/s

adjacentCar = scenario.Actors(3);

% Place AdjacentCar in lane number 4.
waypoints = laneInfo(4).LaneCenters;
speed = 10;

% Find the start waypoint for AdjacentCar at a distance of 2710 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 2710;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for AdjacentCar at a distance of 3060 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3060;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for AdjacentCar
waypointsAdjacentCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(adjacentCar, waypointsAdjacentCar, speed);

%% FastCar1: Set position, speed using trajectory
% Add Trajectory for FastCar1. This vehicle travels in lane number 3 and
% starts at a distance of 2600 meters from the initial waypoint of lane
% number 3. Set velocity of the vehicle to 13 m/s. The FastCar1 is
% traveling in counter clockwise direction with respect to ego vehicle.

fastCar1 = scenario.Actors(4);

% Place FastCar1 in lane number 3
waypoints = laneInfo(3).LaneCenters;
speed = 10;

% Find the start waypoint for FastCar1 at a distance of 2600 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 2600;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for FastCar1 at a distance of 3150 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3150;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for FastCar1
waypointsFastCar1 = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(fastCar1, waypointsFastCar1, speed);

%% FastCar2: Set position, speed using trajectory
% Add Trajectory for FastCar2. This vehicle travels in lane number 3 and
% starts at a distance of 2630 meters from the initial waypoint of lane
% number 3. Set velocity of the vehicle to 13 m/s. The FastCar2 is
% traveling in counter clockwise direction with respect to ego vehicle.

fastCar2 = scenario.Actors(5);

%Place FastCar2 in lane number3
waypoints = laneInfo(3).LaneCenters;
speed = 13;

% Find the start waypoint for FastCar2 at a distance of 2630 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 2630;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for FastCar2 at a distance of 3180 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3180;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for FastCar2
waypointsFastCar2 = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(fastCar2, waypointsFastCar2, speed);

%% SlowCar: Set position, speed using trajectory
% Add Trajectory for SlowCar. This vehicle travels in lane number 3 and
% starts at a distance of 2650 meters from the initial waypoint of lane
% number 3. Set velocity of the vehicle to 10 m/s

slowCar = scenario.Actors(6);

% Place SlowCar in lane number 2 
waypoints = laneInfo(3).LaneCenters;
speed = 8;

% Find the start waypoint for SlowCar at a distance of 2650 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 2650;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for SlowCar at a distance of 3100 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3100;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for SlowCar
waypointsSlowCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(slowCar, waypointsSlowCar, speed);

%% Scenario stop time
scenario.StopTime = 30;
end