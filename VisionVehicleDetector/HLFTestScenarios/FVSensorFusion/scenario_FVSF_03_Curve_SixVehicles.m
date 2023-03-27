function [scenario,assessment] = scenario_FVSF_03_Curve_SixVehicles(nvp)
% scenario_FVSF_03_Curve_SixVehicles creates a driving scenario that is
% compatible with ForwardvehicleSesorFusionTestBench.slx. This test
% scenario is on a Curved road segment and contains six vehicles in the
% scene. In this scenario, the lead vehicle slows down in front of ego
% vehicle while others travel in adjacent lanes.
%  

%   Copyright 2020-2021 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

%  Get driving scenario that is compatible with
%  ForwardvehicleSesorFusionTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario(...
    "Curved road segment");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar
%		Actors(3) - SlowCar1
%		Actors(4) - SlowCar2
%		Actors(5) - FastCar1
%		Actors(6) - FastCar2

%% EgoCar: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
egoCar = scenario.Actors(1);

% Get waypoints from laneCenters.  
% Place the EgoCar in Lane3.
waypoints = laneInfo(3).LaneCenters;

% vary the ego velocity such that it replicate closed loop scenario
speed = [ones(4,1)*14;ones(5,1)*8;ones((length(waypoints)-9),1)*13];

% Set trajectory for EgoCar
trajectory(egoCar, waypoints, speed);

%% LeadCar: The following describes the path of Lead Car.  
% Segment-1: Initial head way time for Lead car is 13.6s and initial speed
% is 14 m/s and travel for 4s.
% Segment-2: After 4s, Lead car slows down to 8 m/s at -1.7 m/s^2 
% Segment-3: Travel with constant speed of 8 m/s for 10s. 
% Segment-4: After 10s increases it's speed to 13m/s at 1.3m/s^2 acceleration
% Segment-5: Travel with constant speed of 13 m/s till end of waypoints.
leadCar = scenario.Actors(2);

% Place the Lead car in the same lane as Ego car.
% Place the LeadCar in Lane3.
waypoints = laneInfo(3).LaneCenters;

% LeadCar - Segment-1: Set position and speed 
% Initialize Lead Car position at 50m ahead of ego vehicle. 
distanceFromFirstWaypoint  = 50;
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
% Compute distance to be travelled using v^2 - u^2 = 2as.
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
% Compute distance to be travelled using v^2 - u^2 = 2as.
% v is 13 m/s, u is 8 m/s, a is 1.3 m/s^2.
% Computed distance, s = 40.3846 m.
 distanceFromFirstWaypoint = distanceFromFirstWaypoint + 40.3846;
[posX, posY, segment4EndIndex]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];
speed = [speed; 13];

% LeadCar - Segment-5: Set position and speed
waypointsLeadCar = [waypointsLeadCar; waypoints(segment4EndIndex:end,:)];
numWaypoints = length(waypoints(segment4EndIndex:end,:));
speed = [speed; 13*ones(numWaypoints,1)];

% Set trajectory for LeadCar
trajectory(leadCar, waypointsLeadCar, speed);

%% SlowCar1: Travel with constant speed of 8 m/s in Lane4
slowCar1 = scenario.Actors(3);
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
speed =8*ones(length(waypointsSlowCar1),1);

% Set trajectory for SlowCar1
trajectory(slowCar1, waypointsSlowCar1, speed);

%% SlowCar2: Travel with a constant speed of 8 m/s in 
% adjacent lane with some distance from SlowCar1.
slowCar2 = scenario.Actors(4);
% Place the SlowCar2 in Lane4.
waypoints = laneInfo(4).LaneCenters;
% Set the initial position at 1060 m from the first waypoint
distanceFromFirstWaypoint = 1060;
[posX, posY, ...
    slowCar2InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar2 = [posX posY 0];
waypointsSlowCar2 = [waypointsSlowCar2;...
    waypoints(slowCar2InitialWayPointIndex:end,:)];

speed = 8*ones(length(waypointsSlowCar2),1);

% Set trajectory for SlowCar2
trajectory(slowCar2, waypointsSlowCar2, speed);

%% FastCar1: Travel with a constant speed of 15 m/s in Lane1.
fastCar1 = scenario.Actors(5);
% Place the FastCar1 in Lane2.
waypoints = laneInfo(2).LaneCenters;
% Set the initial position at 5 m from the first waypoint
distanceFromFirstWaypoint = 5;
[posX, posY, ...
    fastCar1InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar1 = [posX posY 0];
waypointsFastCar1 = [waypointsFastCar1; ...
    waypoints(fastCar1InitialWayPointIndex:end,:)];

speed =15*ones(length(waypointsFastCar1),1);

% Set trajectory for FastCar1.
trajectory(fastCar1, waypointsFastCar1, speed);


%% FastCar2: Travel with a constant speed of 15 m/s in Lane2 with some distance from FastCar1.
fastCar2 = scenario.Actors(6);
% Place the FastCar2 in Lane2.
waypoints = laneInfo(2).LaneCenters;
% Set the initial position at 40 m from the first waypoint
distanceFromFirstWaypoint = 40;
[posX, posY, fastCar2InitialWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar2 =  [posX posY 0];
waypointsFastCar2 = [waypointsFastCar2; waypoints(fastCar2InitialWayPointIndex:end,:)];
speed = 15*ones(length(waypointsFastCar2),1);

% Set trajectory for FastCar2.
trajectory(fastCar2, waypointsFastCar2, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 20;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 21;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
