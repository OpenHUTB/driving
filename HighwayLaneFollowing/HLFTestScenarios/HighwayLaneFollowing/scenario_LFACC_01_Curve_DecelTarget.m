function [scenario,assessment] = scenario_LFACC_01_Curve_DecelTarget(nvp)
% scenario_LFACC_01_Curve_DecelTarget creates a driving scenario that is
% compatible with HighwayLaneFollowingTestBench.slx. This open loop
% scenario is on a Curved road segment and contains two vehicles in the
% scene. In this scenario, the lead vehicle moves at a constant speed of
% 22 m/s for 11s, then decreases speed by 3.5 m/s in 2s with deceleration
% of -1.7 m/s^2. In open loop, there is an expected collision between 
% ego vehicle and lead car.
%

%   Copyright 2020 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

% Get driving scenario that is synchronized with
% HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = helperGetLaneFollowingScenario("Curved road segment");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar

%% EgoCar: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
% Speed = 22 m/s
egoCar = scenario.Actors(1);
% Place the EgoCar in EgoLane.
waypoints = laneInfo(4).LaneCenters;
speed = 22;
trajectory(egoCar, waypoints, speed);

%% LeadCar: 
% Segment-1: Initial headway time for LeadCar is 2s and initial speed is
% 22m/sec and travel for 11sec.
% Segment-2: After 11s, LeadCar slows down to 18.5m/s at -1.8 m/s^2 and
% continues to travel till the end of waypoints.
LeadCar = scenario.Actors(2);
% Place the LeadCar in same as EgoLane.
waypoints = laneInfo(4).LaneCenters;
% Lead Car - Segment-1: Set position and speed 
% Initialize Lead Car position at 44m ahead of ego vehicle. 
distanceFromFirstWaypoint  = 44;
% Get and set first way point for the Lead car in Segment-1
[posX, posY, ...
    segment1StartIndex] = helperGetPositionFromWaypoint(waypoints, distanceFromFirstWaypoint);
waypointsLeadCar = [posX posY 0];

% Travel 242m to maintain 22 m/s for 11 sec to reach end of Segment-1.
distanceFromFirstWaypoint  = distanceFromFirstWaypoint + 242;
[posX, posY, ...
    segment1EndIndex] = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar; waypoints(segment1StartIndex:segment1EndIndex-1,:)];
% Set end way points for the Lead car in Segment-1 (or Segment-2 first way point).
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];
speed = 22*ones(length(waypointsLeadCar),1);

% LeadCar - Segment-2: Set position and speed
% Compute distance to be travelled using v^2 - u^2 = 2as.
% v is 18.5 m/s, u is 22 m/s, a is -1.7 m/s^2.
% Computed distance, s = 42.5 m.
distanceFromFirstWaypoint = distanceFromFirstWaypoint+42.5;
[posX, posY, ...
    leadCarSpeedReducePointIndex1] = helperGetPositionFromWaypoint(waypoints,...
    distanceFromFirstWaypoint);
waypointsLeadCar = [waypointsLeadCar; [posX posY 0]];
waypointsLeadCar = [waypointsLeadCar; waypoints(leadCarSpeedReducePointIndex1:end,:)];
numWaypoints = length(waypoints(leadCarSpeedReducePointIndex1:end,:));
speed = [speed;18.5*ones(numWaypoints+1,1)]; 

% Set trajectory for lead car
trajectory(LeadCar, waypointsLeadCar, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 25;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 20;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)

% LocalWords:  waypoints
