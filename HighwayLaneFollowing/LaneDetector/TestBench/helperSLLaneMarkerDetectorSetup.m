function helperSLLaneMarkerDetectorSetup(varargin)
%helperSLLaneMarkerDetectorSetup creates data for Generate Code for Lane Marker Detector Example
%
% Initializes the LaneMarkerDetectorTestBench.slx model by creating data in 
% base workspace.
%
% helperSLLaneMarkerDetectorSetup(scenarioFcnName)
% 
% Optional inputs
%   scenarioFcnName:
%     - Name of function which returns scenario which is
%       compatable with LaneMarkerDetectorTestBench.slx
%     - Valid values are:
%         "scenario_LF_01_Straight_RightLane"
%         "scenario_LF_02_Straight_LeftLane"
%         "scenario_LF_03_Curve_LeftLane"
%         "scenario_LF_04_Curve_RightLane"
%         "scenario_LD_01_Curve_ThreeVehicles" 
%         "scenario_LD_02_Curve_SixVehicles" (default scenario)
%
% Examples of calling this function:
%
%    helperSLLaneMarkerDetectorSetup("scenario_LF_01_Straight_RightLane") 
%    helperSLLaneMarkerDetectorSetup("scenario_LF_02_Straight_LeftLane") 
%    helperSLLaneMarkerDetectorSetup("scenario_LF_03_Curve_LeftLane")  
%    helperSLLaneMarkerDetectorSetup("scenario_LF_04_Curve_RightLane") 
%    helperSLLaneMarkerDetectorSetup("scenario_LD_01_Curve_ThreeVehicles")
%    helperSLLaneMarkerDetectorSetup("scenario_LD_02_Curve_SixVehicles")
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2020-2021 The MathWorks, Inc.
%%
% load the system
modelName = 'LaneMarkerDetectorTestBench';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end
%% Inputs
% Scenario function name
defaultScenarioFcnName = "scenario_LD_02_Curve_SixVehicles";

validScenarioFcnNames = [...
    "scenario_LF_01_Straight_RightLane";...
    "scenario_LF_02_Straight_LeftLane";...
    "scenario_LF_03_Curve_LeftLane";...
    "scenario_LF_04_Curve_RightLane";...
    "scenario_LD_01_Curve_ThreeVehicles";...
    "scenario_LD_02_Curve_SixVehicles";];   

checkScenarioFncName = @(x) any(strcmp(x,validScenarioFcnNames));

% Parse inputs
p = inputParser;
addOptional(p,'ScenarioFcnName',defaultScenarioFcnName,checkScenarioFncName);
parse(p,varargin{:});
scenarioFcnName = p.Results.ScenarioFcnName;
assignin('base','scenarioFcnName',scenarioFcnName);

%% Scenario parameters
% Set random seed to ensure reproducibility.
rng(0);

% Call scenario function
scenarioFcnHandle = str2func(scenarioFcnName);
[scenario, ~] = scenarioFcnHandle();

%% Set Simulation 3D Scene Configuration block' SceneDesc parameter
% Configure model before assigning workspace variables
blkSim3DConfig = "LaneMarkerDetectorTestBench/Simulation 3D Scenario/Simulation 3D Scene Configuration";
setSim3DSceneDesc(blkSim3DConfig, scenario);

%% Scenario parameters
assignin('base','scenario',scenario);

%% Vehicle parameters
assignin('base','vehSim3D',  vehicleSim3DParams(scenario));

%% Sensor parameters
egoVehicle = scenario.Actors(1);
camera = cameraParams(egoVehicle);
assignin('base','camera',    camera); 
%% General model parameters
assignin('base','Ts',0.1);                   % Algorithm sample time  (s)

%% Bus creation
evalin('base','helperCreateLaneSensorBus');

end

function vehSim3D = vehicleSim3DParams(scenario)
%laneFollowingVehicleSim3DParams vehicle parameters used by Sim 3D

% Number of vehicles in scenario
numVehicles = numel(scenario.Actors);

% Preallocate struct
vehSim3D = repmat(...
    struct(...
        'Length', 0,...
        'RearOverhang', 0,...
        'InitialPos',[0 0 0],...
        'InitialRot',[0 0 0]),...
    numVehicles,1);
    
for n = 1:numVehicles
    % Vehicle information from driving scenario
    veh = scenario.Actors(n); 
    
    % Translate from rear axle (driving scenario) to vehicle center (Sim3D)
    % - Offset position along its orientation by -rearOverhang + length/2.
    positionVehicleCenter = driving.scenario.internal.Utilities.translateVehiclePosition(...
        veh.Position,...     % Position with respect to rear axle (m)
        veh.RearOverhang,... % (m)
        veh.Length,...       % (m)
        veh.Roll,...         % (deg)
        veh.Pitch,...        % (deg)
        veh.Yaw);            % (deg)
    
    % Update struct elements
    vehSim3D(n).Length = veh.Length;
    vehSim3D(n).RearOverhang = veh.RearOverhang;
    vehSim3D(n).InitialPos = positionVehicleCenter;
    vehSim3D(n).InitialRot = [veh.Roll veh.Pitch veh.Yaw]; 
end
end


function camera = cameraParams(egoVehicle)
% Camera sensor parameters
camera.NumColumns      = 1024;    % Number of columns in camera image
camera.NumRows         = 768;     % Number of rows in camera image
camera.FieldOfView     = [45,45]; % Field of view (degrees)
camera.ImageSize       = [camera.NumRows, camera.NumColumns];
camera.PrincipalPoint  = [camera.NumColumns,camera.NumRows]/2;
camera.FocalLength     = [camera.NumColumns / (2*tand(camera.FieldOfView(1))),...
                          camera.NumColumns / (2*tand(camera.FieldOfView(2)))];
camera.Position        = ...      % Position with respect to rear axle (m)
    [ 1.8750, ...                 %  - X (by the rear-view mirror)
      0,...                       %  - Y (center of vehicle width)
      1.2];                       %  - Height
camera.PositionSim3d   = ...      % Position with respect to vehicle center (m)
    camera.Position - ...         %  - Reduce position X by distance from vehicle center to rear axle
    [ egoVehicle.Length/2 - egoVehicle.RearOverhang,...
      0, 0];
camera.Rotation = [0, 0, 0];          % Rotation [roll, pitch, yaw] (deg)
camera.DetectionRanges  = [6 50];     % Full range of camera (m)
camera.LaneDetectionRanges  = [6 30]; % Range to detect lane markings (m)
camera.MeasurementNoise = diag([...   % Measurement noise for vehicle detection
    6,...                             % x is noisier than y
    1,...                             % y is most accurate
	1]); ...                          % z is also accurate
camera.MinObjectImageSize = [10,10];  % Min object size for probabilistic sensor (pixels)
end



function setSim3DSceneDesc(blkSim3DConfig, scenario)
% Set SceneDesc parameter of Simulation 3D Scene Configuration based on 
% road centers in scenario.

roadCentersValid = load('laneFollowingRoadCenters.mat','roadCentersStraightRoad','roadCentersCurvedRoadSegment');
% 
if isequal(scenario.RoadCenters, roadCentersValid.roadCentersStraightRoad)
    sceneDesc = "Straight road";
elseif isequal(scenario.RoadCenters, roadCentersValid.roadCentersCurvedRoadSegment)
    sceneDesc = "Curved road";
else
    error("Road centers do not match supported road types.");
end

% Set Sim 3D scene description
set_param(blkSim3DConfig, 'SceneDesc', sceneDesc);

end
