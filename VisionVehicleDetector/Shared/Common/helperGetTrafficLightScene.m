function [scenario,referencePathInfo,intersectionInfo] = helperGetTrafficLightScene(referencePathType)
%helperGetTrafficLightScene Get the driving scenario for
%TrafficLightNegotiationTestBench.slx.
%
%   [scenario,referencePathInfo,intersectionInfo] = helperGetTrafficLightScene(referencePathType)
%   gets the driving scenario object, reference path information and 
%   intersection information needed for TrafficLightNegotiationTestBench.slx. 
%   The referencePathType specifies the type of ego vehicle motion in the 
%   scene at the intersection. Possible valid values of
%   referencePathType are as described below:
%
%   'referencePathType'      "Straight" - Ego vehicle travels straight at 
%                            the intersection. 
%
%                            "Left" - Ego vehicle takes left
%                            turn at the intersection.
%                             
%                            "Right" - Ego vehicle takes right turn at the
%                            intersection
%
%
%   'scenario'               Driving scenario
% 
%   'referencePathInfo'      Predefined reference path information that the
%                            ego vehicle relies on at the intersection
%                            where there is no lane marking.
%
%   'intersectionInfo'       Intersection information like position of
%                            traffic light and intersection center.
%
%   Example - Configure a test scenario using helperGetTrafficLightScene
%   -------------------------------------------------------------
%   % Define the direction for the ego vehicle at the intersection
%   referencePathType = "Left";
%
%   % Get the compatible scenario. 
%   [scenario, referencePathInfo, intersectionInfo] = ...
%                        helperGetTrafficLightScene(referencePathType);
%
%   % Add the ego vehicle
%   egoVehicle = vehicle(scenario, ...
%     'ClassID', 1, ...
%     'Position', [referencePathInfo.waypoints(1,1) ...
%     referencePathInfo.waypoints(1,2) referencePathInfo.waypoints(1,3)], ...
%     'RearOverhang', 0, ...
%     'FrontOverhang', 1, ...
%     'Wheelbase', 3.7);
%
%   % Define the speed 
%   speed = 8;
%
%   % Define the trajectory with the waypoints from referencePathInfo for
%   the ego vehicle. 
%   trajectory(egoVehicle, referencePathInfo.waypoints, speed);
%
%
%   %Explore the scenario using Driving Scenario Designer
%   drivingScenarioDesigner(scenario);
%

%   This is a helper function for example purposes and may be removed or
%   modified in the future.

% Copyright 2019-2020 The MathWorks, Inc.

%% Construct a drivingScenario object.
scenario = drivingScenario();
scenario.SampleTime = 0.1;

%% Add all road segments
roadCenters = [60 0 0;
    -60 0 0];
marking = [laneMarking('Solid')
    laneMarking('Dashed')
    laneMarking('DoubleSolid', 'Color', [0.98 0.86 0.36])
    laneMarking('Dashed')
    laneMarking('Solid')];
laneSpecification = lanespec(4, 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification);

roadCenters = [0 60 0;
    0 -60 0];
marking = [laneMarking('Solid')
    laneMarking('Dashed')
    laneMarking('DoubleSolid', 'Color', [0.98 0.86 0.36])
    laneMarking('Dashed')
    laneMarking('Solid')];
laneSpecification = lanespec(4, 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification);

%% Get reference path information from MAT-file
% Load reference path data from MAT-file
referencePathData = load('referencePathsInfo.mat');

% Based on the direction of travel select the reference path information
if(referencePathType == "Straight")
    referencePath = referencePathData.referencePathStraight;
    waypoints = referencePathData.waypointsStraight;
    curvature = referencePathData.curvatureStraight;
elseif(referencePathType == "Right")    
    referencePath = referencePathData.referencePathRightTurn;
    waypoints = referencePathData.waypointsRightTurn;
    curvature = referencePathData.curvatureRightTurn;
elseif(referencePathType == "Left")
    referencePath = referencePathData.referencePathLeftTurn;
    waypoints = referencePathData.waypointsLeftTurn;
    curvature = referencePathData.curvatureLeftTurn;
end

% Store the reference path information in referencePathInfo variable in
% order to use during simulation.
referencePathInfo.referencePath = referencePath;
referencePathInfo.waypoints = waypoints;
referencePathInfo.curvature = curvature;

%% Intersection information 
% Get traffic light positions 
trafficLightPositions = getTrafficLightSensorPositions();
intersectionInfo.tlSensor1Position = trafficLightPositions.tlSensor1Position;
intersectionInfo.tlSensor2Position = trafficLightPositions.tlSensor2Position;
intersectionInfo.tlSensor3Position = trafficLightPositions.tlSensor3Position;
intersectionInfo.tlSensor4Position = trafficLightPositions.tlSensor4Position;

% Update intersection information with intersection center
intersectionInfo.intersectionCenter = [0 0 0];

end
%%
% Update TL Sensor 1, TL Sensor 2, TL Sensor 3, TL Sensor 4 traffic light
% positions at the intersection.
function trafficLightPositions = getTrafficLightSensorPositions()

    % TL Sensor 1 position as [x y z]. 
    % x - x co-ordinate. 
    % y - y co-ordinate. 
    % z - z co-ordinate. 
    trafficLightPositions.tlSensor1Position = [-6.9 -1.9 8];

    % TL Sensor 2 position as [x y z].
    % x - x co-ordinate. 
    % y - y co-ordinate. 
    % z - z co-ordinate. 
    trafficLightPositions.tlSensor2Position = [2 -7 8];

    % TL Sensor 3 position as [x y z].
    % x - x co-ordinate. 
    % y - y co-ordinate. 
    % z - z co-ordinate. 
    trafficLightPositions.tlSensor3Position = [7 2 8];

    % TL Sensor 4 position as [x y z].
    % x - x co-ordinate. 
    % y - y co-ordinate. 
    % z - z co-ordinate. 
    trafficLightPositions.tlSensor4Position = [-2 7 8];

end
