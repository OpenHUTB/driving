function [scenario,assessment] = scenario_FVSF_01_Curve_FourVehicles(nvp)
% scenario_FVSF_01_Curve_FourVehicles creates a driving scenario that is
% compatible with ForwardvehicleSesorFusionTestBench.slx. This test
% scenario is on a Curved road segment and contains four vehicles in the
% scene along with ego vehicle. In this scenario, the lead car initially
% travels ahead of ego vehicle in the same lane. The Slow car2 moves in
% adjacent lane and the slow car1 moves in the ego lane ahead of the lead
% car. Lead car over takes slow car1 by cutting into adjacent lane of the
% ego vehicle's lane and again over takes the slow car2 and thus comes in
% to the ego lane.

%  Copyright 2020-2021 The MathWorks, Inc.

% Optional input mode that specifies the openLoop or closedLoop. 
arguments
    nvp.mode {mustBeMember(nvp.mode, ["openLoop",...
    "closedLoop"])}= "closedLoop";
end

% Get driving scenario that is compatible with
% ForwardvehicleSesorFusionTestBench.slx
[scenario, assessment, laneInfo] = ...
    helperGetLaneFollowingScenario("Curved road segment");
% Ego and Target Vehicles representation in this test case.
% 		Actors(1) - EgoCar
%		Actors(2) - LeadCar
%		Actors(3) - SlowCar1
%		Actors(4) - SlowCar2

%% EgoCar: Set position, speed using trajectory
% Position: waypoints(1) is the initial position.
% Speed = 20.6 m/s
egoVehicle = scenario.Actors(1);

% Get waypoints from laneCenters.  
% Place the EgoCar in Lane4.
waypoints = laneInfo(2).LaneCenters;
speed = 16;
trajectory(egoVehicle, waypoints, speed);

%% SlowCar2: Travel with constant speed of 18 m/s in Lane 3.
slowCar2 = scenario.Actors(2);
% Place the Slow car2 in Lane3.
waypoints = laneInfo(3).LaneCenters;

% Initialize SlowCar2 position at 90m ahead of ego vehicle. 
distanceFromFirstWaypoint  = 45;
[posX, posY,slowCar2StartWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsSlowCar2 = [posX posY 0];
waypointsSlowCar2 = ...
    [waypointsSlowCar2; waypoints(slowCar2StartWayPointIndex:end,:)];
speed =18*ones(length(waypointsSlowCar2),1);

% Set trajectory for SlowCar2
trajectory(slowCar2, waypointsSlowCar2, speed);

%% LeadCar : The following describes the requirement of LeadCar 
% Segment-1: Starts moving at 30m ahead of initial waypoint in Lane2 and
% travels for 15m. Segment-2: Cut-in to EgoCar's adjacent lane to avoid
% SlowCar1 in Lane2 at 90m from initial Lane1 waypoint and Cut-out from
% EgoCar's adjacent lane to Lane2 after overtaking Slow car1 at 90m from
% initial Lane3 waypoint Segment-3: Travels in Lane1 till the end of
% waypoints

LeadCar = scenario.Actors(3);

% LeadCar - Segment-1: Set position and speed 
% Place the LeadCar in Lane2.
waypoints = laneInfo(2).LaneCenters;

% Get way point position at 30m in ego lane
distanceFromFirstWaypoint = 30;  
[posX, posY, segment1StartIndex]...
    = helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = [posX posY 0];

% Get way point at 45m to cut into ego vehicle's adjacent lane
distanceFromFirstWaypoint  = distanceFromFirstWaypoint+15;
[~, ~, segment1EndIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
waypointsLeadCar = ...
    [waypointsLeadCar; waypoints(segment1StartIndex:segment1EndIndex-1,:)];
speed = 19.6*ones(size(waypointsLeadCar,1),1);

% LeadCar - Segment-2: Set position and speed
% Get the waypoints in Lane3, as the leadCar changes lane to Lane3
% Using flipped version of laneCenters to move the Lead car.
waypoints = laneInfo(3).LaneCenters;
% Get and set the Segment-2 end position at 90 m from the first waypoint in
% Lane3
distanceFromFirstWaypoint  = 90;
[~, ~, segment2EndIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);

% Skip some way points while cutting in to Lane3 so that the smooth
% trajectory is generated.
waypointsLeadCar = ...
    [waypointsLeadCar;waypoints(segment1EndIndex+1:segment2EndIndex-1,:)];
numWaypoints = length(waypoints(segment1EndIndex+1:segment2EndIndex-1,:)); 
speed = [speed;19.6*ones(numWaypoints-1,1)];

% LeadCar - Segment-3: Set position and speed
% Get the waypoints in Lane2, as the LeadCar changes lane to Lane2
waypoints = laneInfo(2).LaneCenters;
% Skip some way points while cutting in to Lane2 so that the smooth
% trajectory is generated.
waypointsLeadCar = ...
    [waypointsLeadCar;waypoints(segment2EndIndex+6:end,:)];
numWaypoints = length(waypoints(segment2EndIndex+6:end,:));
speed = [speed;18.5*ones(numWaypoints,1)];

% Set trajectory for leadCar
trajectory(LeadCar, waypointsLeadCar, speed);

%% SlowCar1 - Travels in Lane1 with constant speed of 11.1 m/s 
slowCar1 = scenario.Actors(4);

% Place the SlowCar1 in Lane2.
waypoints = laneInfo(2).LaneCenters;

% Set the initial position at 50 m from the first waypoint
distanceFromFirstWaypoint  = 50;
[posX, posY, slowCar1StartWayPointIndex] = ...
    helperGetPositionFromWaypoint(waypoints,distanceFromFirstWaypoint);
    
waypointsSlowCar1 = [posX posY 0];
waypointsSlowCar1 = ...
    [waypointsSlowCar1; waypoints(slowCar1StartWayPointIndex:end,:)];
speed = 11.1*ones(length(waypointsSlowCar1),1);
speed(3:end) = 14; 

% Set trajectory for SlowCar
trajectory(slowCar1, waypointsSlowCar1, speed);

% Set Simulation stop time based on open loop or closed loop mode
if(nvp.mode == "closedLoop")
    scenario.StopTime = 20;
elseif(nvp.mode == "openLoop")
    scenario.StopTime = 13;
end

% Explore the scenario using Driving Scenario Designer
% drivingScenarioDesigner(scenario)
