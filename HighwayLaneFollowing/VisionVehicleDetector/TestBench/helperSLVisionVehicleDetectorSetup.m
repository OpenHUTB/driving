function helperSLVisionVehicleDetectorSetup(nvp)
%helperSLVisionVehicleDetectorSetup creates data for Generate Code For Vehicle Detector Example
%
% Initializes the VisionVehicleDetectorTestBench.slx model by
% creating data in base workspace.
%
% 
% helperSLVisionVehicleDetectorSetup("detectorVariantName","ACF", "scenarioFcnName","scenario_VVD_01_Curve_FiveVehicles");
% 
% Optional inputs
%   detectorVariantName:
%     - Name of the detector variant that is used for vehicle detection
%     - Valid values are:
%         "ACF"  [Default variant]
%         "YOLOv2 Simulation"
%         "YOLOv2 Code Generation"
%   scenarioFcnName:
%     - Name of function which returns scenario which is
%       compatible with VehicleDetectorTestBench.slx
%     - Valid values are:  
%         "scenario_LFACC_01_Curve_DecelTarget"
%         "scenario_LFACC_02_Curve_AutoRetarget"
%         "scenario_LFACC_03_Curve_StopnGo"        
%         "scenario_LFACC_04_Curve_CutInOut"
%         "scenario_LFACC_05_Curve_CutInOut_TooClose"
%         "scenario_LFACC_06_Straight_StopandGoLeadCar"
%         "scenario_VVD_01_Curve_FiveVehicles" [Default scenario]
%         "scenario_FVSF_01_Curve_FourVehicles"
%         "scenario_FVSF_02_Straight_FourVehicles"
%         "scenario_FVSF_03_Curve_SixVehicles"
%
%
% Examples of calling this function:
%
%    helperSLVisionVehicleDetectorSetup("scenarioFcnName", "scenario_LFACC_01_Curve_DecelTarget");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "ACF");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "YOLOv2 Simulation");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "YOLOv2 Code Generation");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "ACF", "scenarioFcnName", "scenario_LFACC_01_Curve_DecelTarget");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName","YOLOv2 Simulation", "scenarioFcnName","scenario_LFACC_01_Curve_DecelTarget");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName","YOLOv2 Code Generation", "scenarioFcnName","scenario_LFACC_01_Curve_DecelTarget");
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2020-2021 The MathWorks, Inc.

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
    "scenario_VVD_01_Curve_FiveVehicles"])}= ...
    "scenario_VVD_01_Curve_FiveVehicles";

nvp.detectorVariantName {mustBeMember(nvp.detectorVariantName, ...
    ["ACF", ...
    "YOLOv2 Simulation", ...
    "YOLOv2 Code Generation"])}= ...
    "ACF";
end

%% Load the Simulink model
modelName = 'VisionVehicleDetectorTestBench';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end

% Create base work space variables based on the vehicle detector variant
% selected.
assignin('base','detectorVariant',nvp.detectorVariantName);

% Select the detector as ACF for ACF detector variant and YOLOv2 for YOLOv2
% Simulation and YOLOv2 code generation variants.
if(nvp.detectorVariantName == "ACF")
    detector = VehicleDetector.ACF;
else
    detector = VehicleDetector.YOLOv2;
end

% create the required MAT file data based on the 'vehicleDetector'
% selected.
helperCreateCodeGenMatFile(detector);

% Call scenario function
scenarioFcnHandle = str2func(nvp.scenarioFcnName);
[scenario, ~] = scenarioFcnHandle("mode", "openLoop");


%% Set Simulation 3D Scene Configuration block' SceneDesc parameter
% Configure model before assigning workspace variables
blkSim3DConfig = "VisionVehicleDetectorTestBench/Sensors and Environment/Simulation 3D Scene Configuration";

% Configure the scene config block 
setSim3DSceneDesc(blkSim3DConfig, scenario);


%% Scenario parameters
assignin('base','scenario',scenario);

%% Sensor parameters
egoVehicle = scenario.Actors(1);
camera = cameraParams(egoVehicle);
assignin('base','camera',    camera);
assignin('base','vehSim3D', vehicleSim3DParams(scenario));

%% Vehicle parameters
% Get dimensions of all the vehicle actors that are used in computing
% ground truth bounding boxes.
all_actors = scenario.Actors;
dimensions(size(all_actors,2)) = struct();
for i = 1:size(all_actors,2)
    actor = all_actors(i);
    dimensions(i).id = actor.ActorID;
    dimensions(i).length = actor.Length;
    dimensions(i).width = actor.Width;
    dimensions(i).height = actor.Height;
    dimensions(i).rearOverhang = actor.RearOverhang;
    dimensions(i).roll = actor.Roll;
    dimensions(i).pitch = actor.Pitch;
    dimensions(i).yaw = actor.Yaw;
    dimensions(i).velocity = actor.Velocity;
    dimensions(i).frontOverhang = actor.FrontOverhang;
end

assignin('base', 'dimensions', dimensions);


%% General model parameters
assignin('base','Ts',0.1);                   % Algorithm sample time  (s)


%% Bus creation
evalin('base','helperCreateVehicleDetectorBusObjects');

end

function vehSim3D = vehicleSim3DParams(scenario)
%VehicleSim3DParams vehicle parameters used by Sim 3D

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

