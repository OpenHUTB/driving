function helperSLForwardVehicleSensorFusionHostSetup(nvp)
%helperSLForwardVehicleSensorFusionHostSetup creates data required for the
% RTForwardVehicleSensorFusionHost.slx model.
%
% Initializes the RTForwardVehicleSensorFusionHost.slx model by creating
% data in base workspace.
%
% helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_01_Curve_DecelTarget")
%
% Optional inputs
%   scenarioFcnName:
%     - Name of function which returns scenario which is
%       compatable with RTForwardVehicleSensorFusionHost.slx
%     - Valid values are:
%         "scenario_LFACC_01_Curve_DecelTarget"
%         "scenario_LFACC_02_Curve_AutoRetarget"
%         "scenario_LFACC_03_Curve_StopnGo" [Default]
%         "scenario_LFACC_04_Curve_CutInOut"
%         "scenario_LFACC_05_Curve_CutInOut_TooClose"
%         "scenario_LFACC_06_Straight_StopandGoLeadCar"
%         "scenario_FVSF_01_Curve_FourVehicles"
%         "scenario_FVSF_02_Straight_FourVehicles"
%         "scenario_FVSF_03_Curve_SixVehicles"
%         "scenario_FVSF_04_Straight_ThreeVehicles"
%         "scenario_FVSF_05_Straight_TwoVehicles"
%
% Examples of calling this function:
%
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_01_Curve_DecelTarget")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_02_Curve_AutoRetarget")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_03_Curve_StopnGo")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_04_Curve_CutInOut")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_05_Curve_CutInOut_TooClose")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_LFACC_06_Straight_StopandGoLeadCar")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_FVSF_01_Curve_FourVehicles")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_FVSF_02_Straight_FourVehicles")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_FVSF_03_Curve_SixVehicles")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_FVSF_04_Straight_ThreeVehicles")
%    helperSLForwardVehicleSensorFusionHostSetup(scenarioFcnName="scenario_FVSF_05_Straight_TwoVehicles")

%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2021 The MathWorks, Inc.


arguments

nvp.scenarioFcnName {mustBeMember(nvp.scenarioFcnName,...
    ["scenario_LFACC_01_Curve_DecelTarget",...
    "scenario_LFACC_02_Curve_AutoRetarget",...
    "scenario_LFACC_03_Curve_StopnGo",...
    "scenario_LFACC_04_Curve_CutInOut",...
    "scenario_LFACC_05_Curve_CutInOut_TooClose",...
    "scenario_LFACC_06_Straight_StopandGoLeadCar",...
    "scenario_FVSF_01_Curve_FourVehicles",...
    "scenario_FVSF_02_Straight_FourVehicles",...
    "scenario_FVSF_03_Curve_SixVehicles",...
    "scenario_FVSF_04_Straight_ThreeVehicles",...
    "scenario_FVSF_05_Straight_TwoVehicles"])}= ...
    "scenario_LFACC_03_Curve_StopnGo";
end

%% Load the Simulink model
modelName = 'RTForwardVehicleSensorFusionHost';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end

% Call scenario function
scenarioFcnHandle = str2func(nvp.scenarioFcnName);
[scenario, assessment] = scenarioFcnHandle("mode", "openLoop");

%% Set Simulation 3D Scene Configuration block' SceneDesc parameter
% Configure model before assigning workspace variables
blkSim3DConfig = "RTForwardVehicleSensorFusionHost/Sensors and Environment/Simulation 3D Scene Configuration";

% Configure the scene config block 
setSim3DSceneDesc(blkSim3DConfig, scenario);

%% Scenario parameters
assignin('base','scenario',scenario);
assignin('base','assessment',assessment);

%% Sensor parameters
egoVehicle = scenario.Actors(1);
camera = cameraParams(egoVehicle);
assignin('base','camera',    camera);
assignin('base','radar',     radarParams(egoVehicle));
assignin('base','vehSim3D',  vehicleSim3DParams(scenario));

%% GOSPA metric parameters
assignin('base', 'alpha',               2);        % Alpha parameter of GOSPA metric
assignin('base', 'order',               2);        % Order of GOSPA metric
assignin('base', 'switchingPenalty',    0);        % Penalty for assignment switching
assignin('base', 'cutOffDistance',     30);        % Threshold for cutoff distance between track and truth

%% General model parameters
assignin('base','Ts',0.1);                   % Algorithm sample time  (s)

%% Bus creation
evalin('base','helperCreateFVSFHostBusObjects');
evalin('base','helperCreateFVSFTargetBusObjects');

%% UDP interface params
try
    [~] = evalin('base', 'maxNumVisionDets');
catch
    assignin('base', 'maxNumVisionDets', 20);
end
try
    [~] = evalin('base', 'maxNumRadarDets');
catch
    assignin('base', 'maxNumRadarDets', 50);
end
try
    [~] = evalin('base', 'maxNumTracks');
catch
    assignin('base', 'maxNumTracks', 20);
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


function radar = radarParams(egoVehicle)
% Radar sensor parameters
radar.FieldOfView     = [40,5];   % Field of view (degrees)
radar.DetectionRanges = [1,100];   % Ranges (m)
radar.Position        = ...       % Position with respect to rear axle (m)
    [ egoVehicle.Length - egoVehicle.RearOverhang, ...
    0,...
    0.8];
radar.PositionSim3d   = ...       % Position with respect to vehicle center (m)
    radar.Position - ...
    [ egoVehicle.Length/2 - egoVehicle.RearOverhang, 0, 0];

radar.Rotation = [ 0, 0, 0];      % [roll, pitch, yaw] (deg)
end

function setSim3DSceneDesc(blkSim3DConfig, scenario)
% Set SceneDesc parameter of Simulation 3D Scene Configuration based on 
% road centers in scenario.

% Valid road centers that are can be used with this example
roadCentersValid = load('laneFollowingRoadCenters.mat',...
                        'roadCentersStraightRoad',...
                        'roadCentersCurvedRoadSegment');

% Check the scene used for the scenario based on road centers
if isequal(scenario.RoadCenters, roadCentersValid.roadCentersStraightRoad)
    sceneDesc = "Straight road";
    set_param(blkSim3DConfig, 'ProjectFormat', "Default Scenes");
    set_param(blkSim3DConfig, 'SceneDesc', sceneDesc);
elseif isequal(scenario.RoadCenters, roadCentersValid.roadCentersCurvedRoadSegment)
    sceneDesc = "Curved road";
    set_param(blkSim3DConfig, 'ProjectFormat', "Default Scenes");
    set_param(blkSim3DConfig, 'SceneDesc', sceneDesc);
else
    error("Road centers do not match supported road types.");
end
end

function vehSim3D = vehicleSim3DParams(scenario)
%vehicleSim3DParams vehicle parameters used by Sim 3D

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
