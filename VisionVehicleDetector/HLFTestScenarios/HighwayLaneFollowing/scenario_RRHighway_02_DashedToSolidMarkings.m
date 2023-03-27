function [scenario, assessment] = scenario_RRHighway_02_DashedToSolidMarkings()
% scenario_RRHighway_02_DashedToSolidMarkings creates a driving scenario by
% importing the OpenDRIVE file from the RoadRunner scene. This scenario
% contains five other vehicles. In this scenario the vehicles travel from a road
% segment where the lane markings are dashed to a segment where the lane
% markings are solid.

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
% starts at 1950 meters from the from initial waypoint point. Set velocity
% of the vehicle to 10 m/s

egoCar = scenario.Actors(1);

%Place EgoCar in lane number 5
waypoints = laneInfo(5).LaneCenters;
speed = 10;

% Find the start waypoint for EgoCar at a distance of 1950 meters from the
% start waypoint.
startDistanceFromFirstWaypoint = 1950;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for EgoCar at a distance of 2250 meters from the
% first waypoint.
endDistanceFromFirstWaypoint = 2250;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for EgoCar
waypointsEgoCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(egoCar, waypointsEgoCar, speed);

%% LeadCar: Set position, speed using trajectory
% Add Trajectory for LeadCar. This vehicle travels in lane number 5 and
% starts at a distance of 30 meters from the ego vehicle. Set velocity of
% the vehicle to 10 m/s

leadCar = scenario.Actors(2);

% Place the LeadCar in lane number 5
waypoints = laneInfo(5).LaneCenters;
speed = 10;

% Find the start waypoint for LeadCar at a distance of 1980 meters from the
% first waypoint.
startDistanceFromFirstWaypoint = 1980;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for LeadCar at a distance of 2270 meters from the
% first waypoint.
endDistanceFromFirstWaypoint = 2270;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for LeadCar.
waypointsLeadCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(leadCar,waypointsLeadCar ,speed);

%% AdjacentCar: Set position, speed using trajectory
% Add Trajectory for AdjacentCar. This vehicle travels in lane number 4 and
% starts at a distance of  1960 meters from the start waypoint of lane
% number4. Set velocity of the vehicle to 10 m/s

adjacentCar = scenario.Actors(3);

% Place AdjacentCar in lane number 4
waypoints = laneInfo(4).LaneCenters;
speed = 10;

% Find the start waypoint for AdjacentCar at a distance of 1960 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 1960;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for AdjacentCar at a distance of 2260 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 2260;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for AdjacentCar
waypointsAdjacentCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(adjacentCar,waypointsAdjacentCar ,speed);

%% FastCar1: Set position, speed using trajectory
% Add Trajectory for FastCar1. This vehicle travels in lane number 4 and
% starts at a distance of  3400 meters from the start waypoint of lane
% number 3. Set velocity of the vehicle to 13 m/s.  The FastCar1 is
% traveling in counter clockwise direction with respect to ego vehicle.

fastCar1 = scenario.Actors(4);

% Place the FastCar1 in lane number 3
waypoints = laneInfo(3).LaneCenters;
speed = 13;

% Find the start waypoint for FastCar1 at a distance of 3400 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 3400;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for FastCar1 at a distance of 3900 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 3900;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for FastCar1
waypointsFastCar1 = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(fastCar1, waypointsFastCar1, speed);

%% FastCar2: Set position, speed using trajectory
% Add Trajectory for FastCar2. This vehicle travels in lane number 4 and
% starts at a distance of  3450 meters from the start waypoint of lane
% number 3. Set velocity of the vehicle to 13 m/s. The FastCar2 travels in
% counter clock wise direction with respect to EgoCar.

fastCar2 = scenario.Actors(5);

% Place FastCar2 in lane number 3
waypoints = laneInfo(3).LaneCenters;
speed = 13;

% Find the start waypoint for FastCar2 at a distance of 3450 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 3450;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for FastCar2 at a distance of 4050 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 4050;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for FastCar2
waypointsFastCar2 = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(fastCar2, waypointsFastCar2, speed);

%% SlowCar: Set position, speed using trajectory
% Add Trajectory for SlowCar. This vehicle travels in lane number 4 and
% starts at a distance of  3500 meters from the start waypoint of lane
% number 2. Set velocity of the vehicle to 8 m/s. The SlowCar travels in
% counter clock wise direction with respect to EgoCar.

slowCar = scenario.Actors(6);

% Place SlowCar in lane number 2
waypoints = laneInfo(2).LaneCenters;
speed = 8;

% Find the start waypoint for SlowCar at a distance of 3500 meters from
% the first waypoint.
startDistanceFromFirstWaypoint = 3500;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for SlowCar at a distance of 4000 meters from
% the first waypoint.
endDistanceFromFirstWaypoint = 4000;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);

% Set trajectory for FastCar1
waypointsSlowCar = waypoints(waypointStartIndex:waypointEndIndex,:);
trajectory(slowCar, waypointsSlowCar, speed);

%% Scenario stop time
scenario.StopTime = 30;
end