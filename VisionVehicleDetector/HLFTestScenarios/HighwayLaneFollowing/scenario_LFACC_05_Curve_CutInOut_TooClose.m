function [scenario,assessment] = scenario_LFACC_05_Curve_CutInOut_TooClose(nvp)
% scenario_LFACC_05_Curve_CutInOut_TooClose creates a driving scenario that
% is compatible with HighwayLaneFollowingTestBench.slx. This test
% scenario is on a Curved road segment and contains four vehicles in the
% scene. In this scenario, the fast car travels ahead of ego vehicle in the
% same lane. The other two cars : passing car and slow moving car moves
% initially in adjacent lane. Passing car over takes slow moving car by
% cutting into ego vehicle's lane and cuts out from ego vehicle's lane. 
% Passing car performs cut in and cut out too close to the slow moving car.
% In open loop, there is an expected collision between ego vehicle and fast
% car.

%   Copyright 2020 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

% Get driving scenario that is compatible with
% HighwayLaneFollowingTestBench.slx
[scenario, assessment, laneInfo] = ...
    helperGetLaneFollowingScenario("Curved road segment");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - FastCar
%		Actors(3) - SlowCar1
%		Actors(4) - SlowCar2
%% EgoCar: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
% Speed = 20.6 m/s
egoVehicle = scenario.Actors(1);

% Get waypoints from laneCenters.  
% Place the EgoCar in Lane3.
waypoints = laneInfo(3).LaneCenters;
speed = 20.6;
trajectory(egoVehicle, waypoints, speed);

%% FastCar: Travel with constant speed of 18 m/s in Lane 3.
fastCar = scenario.Actors(2);
% Place the Lead car in the same lane as Ego car i.e in Lane3.
waypoints = laneInfo(3).LaneCenters;
% Initialize FastCar position at 90m ahead of ego vehicle. 
distanceFromFirstWaypoint  = 45;
[posX, posY,fastCarStartWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsFastCar = [posX posY 0];
waypointsFastCar = ...
    [waypointsFastCar; waypoints(fastCarStartWayPointIndex:end,:)];
speed =18*ones(length(waypointsFastCar),1);

% Set trajectory for FastCar
trajectory(fastCar, waypointsFastCar, speed);

%% PassingCar : The following describes the requirement of PassingCar 
% Segment-1: Starts moving at 30m ahead of initial waypoint in Lane2 and
% travels for 15m.
% Segment-2: Cut-in to EgoCar's lane to avoid SlowCar in
% Lane2 at 90m from initial Lane1 waypoint and Cut-out from EgoCar's lane
% to Lane2 after overtaking Slow car at 90m from initial Lane3 waypoint
% Segment-3: Travels in Lane1 till the end of waypoints

passingCar = scenario.Actors(3);

% PassingCar - Segment-1: Set position and speed 
% Place the PassingCar in Lane2.
waypoints = laneInfo(2).LaneCenters;

% Get way point position at 30m in adjacent lane
distanceFromFirstWaypoint = 30;  
[posX, posY, segment1StartIndex]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsPassingCar = [posX posY 0];

% Get way point at 45m to cut into ego vehicle's lane
distanceFromFirstWaypoint  = distanceFromFirstWaypoint+15;
[~, ~, segment1EndIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsPassingCar = ...
    [waypointsPassingCar; waypoints(segment1StartIndex:segment1EndIndex-1,:)];
speed = 19.6*ones(size(waypointsPassingCar,1),1);

% PassingCar - Segment-2: Set position and speed
% Get the waypoints in Lane3, as the PassingCar changes lane to Lane3
% Using flipped version of laneCenters to move the Lead car.
waypoints = laneInfo(3).LaneCenters;
% Get and set the Segment-2 end position at 90 m from the first waypoint in
% Lane3
distanceFromFirstWaypoint  = 90;
[~, ~, segment2EndIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);

% Skip some way points while cutting in to Lane3 so that the smooth
% trajectory is generated.
waypointsPassingCar = ...
    [waypointsPassingCar;waypoints(segment1EndIndex+1:segment2EndIndex-1,:)];
numWaypoints = length(waypoints(segment1EndIndex+1:segment2EndIndex-1,:)); 
speed = [speed;19.6*ones(numWaypoints-1,1)];

% PassingCar - Segment-3: Set position and speed
% Get the waypoints in Lane2, as the PassingCar changes lane to Lane2
waypoints = laneInfo(2).LaneCenters;
% Skip some way points while cutting in to Lane2 so that the smooth
% trajectory is generated.
waypointsPassingCar = ...
    [waypointsPassingCar;waypoints(segment2EndIndex+6:end,:)];
numWaypoints = length(waypoints(segment2EndIndex+6:end,:));
speed = [speed;18.5*ones(numWaypoints,1)];

% Set trajectory for PassingCar
trajectory(passingCar, waypointsPassingCar, speed);

%% SlowCar - Travels in Lane1 with constant speed of 11.1 m/s 
slowCar = scenario.Actors(4);
% Place the SlowCar in adjacent lane but moving in another direction.
% Place the SlowCar1 in Lane2.
waypoints = laneInfo(2).LaneCenters;

% Set the initial position at 50 m from the first waypoint
distanceFromFirstWaypoint  = 50;
[posX, posY, slowCarStartWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
    
waypointsSlowCar = [posX posY 0];
waypointsSlowCar = ...
    [waypointsSlowCar; waypoints(slowCarStartWayPointIndex:end,:)];
speed = 11.1*ones(length(waypointsSlowCar),1);
speed(3:end) = 14; 

% Set trajectory for SlowCar
trajectory(slowCar, waypointsSlowCar, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 25;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 13;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
