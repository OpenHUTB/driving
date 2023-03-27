function [scenario,assessment] = scenario_RRHighway_01_NoShadowToShadow
% scenario_RRHighway_01_NoShadowToShadow creates a driving scenario by
% importing the OpenDRIVE file from the RoadRunner scene. This scenario
% contains five other vehicles in the scene. In this scenario the vehicles
% travel from a road segment where the trees do not cast shadows on the
% road to the segment where the trees cast shadows on lane markings of the
% road.

%   Copyright 2020 The MathWorks, Inc.

% Get the scenario object from OpenDRIVE file, corresponding laneInfo and
% assessment
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("RR Highway road");

% Ego and Target Vehicles representation in this test case.
%       Actors(1) - EgoCar
%       Actors(2) - LeadCar
%       Actors(3) - SlowCar1
%       Actors(4) - SlowCar2
%       Actors(5) - FastCar1
%       Actors(6) - FastCar2

%% EgoCar: Set position, speed using trajectory
% Add Trajectory for EgoCar. This vehicle travels in lane number 5 and
% starts at 1050 meters from the initial waypoint. Set velocity of the
% vehicle to 10 m/s

egoCar = scenario.Actors(1);

% Get waypoints from laneCenters.  
% Place the EgoCar in Lane5.
waypoints = laneInfo(5).LaneCenters;
speed = 14;

% Find the start waypoint for EgoCar at a distance of 1050 meters from
% initial waypoint.
startDistanceFromFirstWaypoint = 1050;
[~, ~, waypointStartIndex]...
    = helperGetPositionFromWaypoint(waypoints,startDistanceFromFirstWaypoint);

% Find the end waypoint for EgoCar at a distance of 1500 meters from
% initial waypoint.
endDistanceFromFirstWaypoint = 1500;
[~, ~, waypointEndIndex]...
    = helperGetPositionFromWaypoint(waypoints,endDistanceFromFirstWaypoint);
waypointsEgoCar = waypoints(waypointStartIndex:waypointEndIndex,:);

% Set trajectory for EgoCar
trajectory(egoCar, waypointsEgoCar, speed);

%% LeadCar: Set position, speed using trajectory
% The following describes the path of Lead Car.  
% Segment-1: Initial head way time for Lead car is 13.6s and initial speed
% is 14 m/s and travel for 4s.
% Segment-2: After 4s, Lead car slows down to 8 m/s at -1.7 m/s^2 
% Segment-3: Travel with constant speed of 8 m/s for 10s. 
% Segment-4: After 10s increases it's speed to 13m/s at 1.3m/s^2 acceleration
% Segment-5: Travel with constant speed of 13 m/s till end of waypoints.

leadCar = scenario.Actors(2);

% Place the Lead car in the same lane as Ego car.
% Place the LeadCar in Lane3.
waypoints = laneInfo(5).LaneCenters;

% LeadCar - Segment-1: Set position and speed 
% Initialize Lead Car position at 70m ahead of ego vehicle. 
distanceFromFirstWaypoint  = 1120;
% Get and set first way point for the Lead car in Segment-1
[posX, posY, ...
    segment1StartIndex] = helperGetPositionFromWaypoint(...
    waypoints, distanceFromFirstWaypoint);
waypointsLeadCar = [posX posY 0];

% Travel 56m to maintain 14m/s for 4 sec to reach end of Segment-1.
distanceFromFirstWaypoint  = distanceFromFirstWaypoint + 56;

% Get waypoints for Segment-1 and update waypointsLeadCar
[posX, posY, segment1EndIndex ]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar ; ...
    waypoints(segment1StartIndex:segment1EndIndex-1,:)];

% Set end way points for the Lead car in Segment-1 (or Segment-2 first way
% point).
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];

speed =14*ones(length(waypointsLeadCar),1);

% LeadCar - Segment-2: Set position and speed
% Compute distance to be traveled using v^2 - u^2 = 2as.
% v is 8 m/s, u is 14 m/s, a is -1.7m/s^2.
% Computed distance, s = 38.8235 m.
distanceFromFirstWaypoint = distanceFromFirstWaypoint + 38.8235;
[posX, posY, ~] = helperGetPositionFromWaypoint(...
    waypoints, distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];
speed = [speed; 8];

% Lead Car - Segment-3: Set position and speed
% Travel 80m to maintain 8m/s for 10 sec to reach end of Segment-3.
distanceFromFirstWaypoint = distanceFromFirstWaypoint + 80;
[posX, posY, ~]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];
speed = [speed; 8];

% LeadCar - Segment-4: Set position and speed
% Compute distance to be traveled using v^2 - u^2 = 2as.
% v is 13 m/s, u is 8 m/s, a is 1.3 m/s^2.
% Computed distance, s = 40.3846 m.
distanceFromFirstWaypoint = distanceFromFirstWaypoint + 40.3846;
[posX, posY, segment4EndIndex]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];
speed = [speed; 13];

% Find the end waypoint for EgoCar from the lane centers of lane number 5
% at a distance of 1560 meters from initial waypoint.
distanceFromFirstWaypoint = 1560;
[~, ~, endWaypoint]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);

% LeadCar - Segment-5: Set position and speed
waypointsLeadCar = [waypointsLeadCar; waypoints(segment4EndIndex:endWaypoint,:)];
numWaypoints = length(waypoints(segment4EndIndex:endWaypoint,:));
speed = [speed; 13*ones(numWaypoints,1)];

% Set trajectory for LeadCar
trajectory(leadCar, waypointsLeadCar, speed);

%% SlowCar1: Set position, speed using trajectory
% Add Trajectory for SlowCar1. This vehicle travels in lane number 3 and
% starts at a distance of  4100 meters from the initial waypoint of lane
% number 3. Set velocity of the vehicle to 8 m/s. The SlowCar1 is traveling
% in counter clockwise direction with respect to ego vehicle.
slowCar1 = scenario.Actors(3);

% Place the SlowCar1 in adjacent lane but moving in counter clockwise
% direction.
% Place the SlowCar1 in Lane4.
waypoints = laneInfo(3).LaneCenters;

% Find the start waypoint for SlowCar1 at a distance of 4100 meters from
% initial waypoint
distanceFromFirstWaypoint = 4100;

[posX, posY,...
    slowCar1StartWayPointIndex ] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar1 = [posX posY 0];

% Find the end waypoint for SlowCar1 at a distance of 4600 meters from
% initial waypoint.
distanceFromFirstWaypoint = 4600;
[~, ~,...
    slowCar1EndWayPointIndex ] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar1 = [waypointsSlowCar1; ...
    waypoints(slowCar1StartWayPointIndex:slowCar1EndWayPointIndex,:)];
speed =8*ones(length(waypointsSlowCar1),1);

% Set trajectory for SlowCar1
trajectory(slowCar1, waypointsSlowCar1, speed);

%% SlowCar2: Set position, speed using trajectory
% Add Trajectory for SlowCar2. This vehicle travels in lane number 3 and
% starts at a distance of  4130 meters from the initial waypoint of lane
% number 3. Set velocity of the vehicle to 8 m/s. The SlowCar1 is traveling
% in counter clockwise direction with respect to ego vehicle.
slowCar2 = scenario.Actors(4);
% Place the SlowCar2 in Lane4.
waypoints = laneInfo(3).LaneCenters;

% Find the start waypoint for SlowCar2 at a distance of 4130 meters from
% initial waypoint.
distanceFromFirstWaypoint = 4130;
[posX, posY, ...
    slowCar2InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar2 = [posX posY 0];

% Find the end waypoint for SlowCar2 at a distance of 4630 meters from
% initial waypoint.
distanceFromFirstWaypoint = 4630;
[~, ~, ...
    slowCar2EndWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar2 = [waypointsSlowCar2;...
    waypoints(slowCar2InitialWayPointIndex:slowCar2EndWayPointIndex,:)];

speed = 8*ones(length(waypointsSlowCar2),1);

% Set trajectory for SlowCar2
trajectory(slowCar2, waypointsSlowCar2, speed);

%% FastCar1: Set position, speed using trajectory
% Add Trajectory for FastCar1. This vehicle travels in lane number 4 and
% starts at a distance of  1080 meters from the initial waypoint of lane
% number 4. Set velocity of the vehicle to 15 m/s
fastCar1 = scenario.Actors(5);
% Place the FastCar1 in Lane2.
waypoints = laneInfo(4).LaneCenters;

% Find the start waypoint for FastCar1 at a distance of 1080 meters from
% initial waypoint.
distanceFromFirstWaypoint = 1080;
[posX, posY, ...
    fastCar1InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar1 = [posX posY 0];

% Find the end waypoint for FastCar1 at a distance of 1600 meters from
% initial waypoint.
distanceFromFirstWaypoint = 1600;
[~, ~, ...
    fastCar1EndWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar1 = [waypointsFastCar1; ...
    waypoints(fastCar1InitialWayPointIndex:fastCar1EndWayPointIndex,:)];

speed =15*ones(length(waypointsFastCar1),1);

% Set trajectory for FastCar1.
trajectory(fastCar1, waypointsFastCar1, speed);


%% FastCar2: Set position, speed using trajectory
% Add Trajectory for FastCar1. This vehicle travels in lane number 4 and
% starts at a distance of  1105 meters from the initial waypoint of lane
% number 4. Set velocity of the vehicle to 15 m/s
fastCar2 = scenario.Actors(6);
% Place the FastCar2 in Lane2.
waypoints = laneInfo(4).LaneCenters;

% Find the start waypoint for FastCar2 at a distance of 1105 meters from
% initial waypoint.
distanceFromFirstWaypoint = 1105;
[posX, posY, fastCar2InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar2 =  [posX posY 0];

% Find the end waypoint for FastCar1 at a distance of 1580 meters from
% initial waypoint.
distanceFromFirstWaypoint = 1580;
[~, ~, fastCar2EndWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar2 = [waypointsFastCar2; waypoints(fastCar2InitialWayPointIndex:fastCar2EndWayPointIndex,:)];
speed = 15*ones(length(waypointsFastCar2),1);

% Set trajectory for FastCar2.
trajectory(fastCar2, waypointsFastCar2, speed);

%% Set Simulation stop time
scenario.StopTime = 32;

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
