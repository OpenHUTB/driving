function helperSLHighwayLaneFollowingSetup(nvp)
%helperSLHighwayLaneFollowingSetup creates data for Highway Lane Following
%Example and Highway Lane Following with RoadRunner Scene Example
%
% Initializes the lane following model by creating data in 
% base workspace and modifying HighwayLaneFollowingTestBench.
%
% helperSLHighwayLaneFollowingSetup("scenarioFcnName","scenario_LFACC_03_Curve_StopnGo","detectorVariantName","YOLOv2 Simulation")
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
%       compatable with HighwayLaneFollowingTestBench.slx
%     - Valid values are:
%         "scenario_LF_01_Straight_RightLane"
%         "scenario_LF_02_Straight_LeftLane"
%         "scenario_LF_03_Curve_LeftLane"
%         "scenario_LF_04_Curve_RightLane"
%         "scenario_LFACC_01_Curve_DecelTarget"
%         "scenario_LFACC_02_Curve_AutoRetarget"
%         "scenario_LFACC_03_Curve_StopnGo" [Default]
%         "scenario_LFACC_04_Curve_CutInOut"
%         "scenario_LFACC_05_Curve_CutInOut_TooClose"
%         "scenario_LFACC_06_Straight_StopandGoLeadCar"
%         "scenario_RRHighway_01_NoShadowToShadow"
%         "scenario_RRHighway_02_DashedToSolidMarkings"
%         "scenario_RRHighway_03_DarkToLightRoadMaterial"
%
% Examples of calling this function:
%
%    helperSLHighwayLaneFollowingSetup("scenarioFcnName", "scenario_LFACC_01_Curve_DecelTarget")
%    helperSLHighwayLaneFollowingSetup("detectorVariantName","YOLOv2 Simulation");
%    helperSLHighwayLaneFollowingSetup("detectorVariantName","YOLOv2 Simulation", "scenarioFcnName","scenario_LFACC_01_Curve_DecelTarget");
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2019-2021 The MathWorks, Inc.
%% Inputs
arguments
    nvp.scenarioFcnName {mustBeMember(nvp.scenarioFcnName,...
    ["scenario_LF_01_Straight_RightLane";...
    "scenario_LF_02_Straight_LeftLane";...
    "scenario_LF_03_Curve_LeftLane";...
    "scenario_LF_04_Curve_RightLane";...
    "scenario_LFACC_01_Curve_DecelTarget";...
    "scenario_LFACC_02_Curve_AutoRetarget";...
    "scenario_LFACC_03_Curve_StopnGo";...
    "scenario_LFACC_04_Curve_CutInOut";...
    "scenario_LFACC_05_Curve_CutInOut_TooClose";...
    "scenario_LFACC_06_Straight_StopandGoLeadCar";...
    "scenario_RRHighway_01_NoShadowToShadow";...
    "scenario_RRHighway_02_DashedToSolidMarkings";...
    "scenario_RRHighway_03_DarkToLightRoadMaterial"])} = ...
    "scenario_LFACC_03_Curve_StopnGo";

    nvp.detectorVariantName {mustBeMember(nvp.detectorVariantName, ...
    ["ACF", ...
    "YOLOv2 Simulation", ...
    "YOLOv2 Code Generation"])}= ...
    "ACF";
end


% Load the test bench model
modelName = "HighwayLaneFollowingTestBench";
if ~bdIsLoaded(modelName)
    load_system(modelName);
end

% Create base work space variables based on the scenario function, vehicle
% detector variant selected.
assignin('base','scenarioFcnName',nvp.scenarioFcnName);
assignin('base','detectorVariant',nvp.detectorVariantName);

% Select the detector as ACF for ACF detector variant and YOLOv2 for YOLOv2
% Simulation and YOLOv2 code generation variants.
if(nvp.detectorVariantName == "ACF")
    detector = VehicleDetector.ACF;
elseif(nvp.detectorVariantName == "YOLOv2 Simulation" || nvp.detectorVariantName == "YOLOv2 Code Generation")
    detector = VehicleDetector.YOLOv2;
end

% create the required MAT file data based on the 'vehicleDetector'
% selected.
helperCreateCodeGenMatFile(detector);

%% Scenario parameters
% Set random seed to ensure reproducibility.
rng(0);

% Call scenario function
scenarioFcnHandle = str2func(nvp.scenarioFcnName);
[scenario, assessment] = scenarioFcnHandle();

%% Set Simulation 3D Scene Configuration block' SceneDesc parameter
% Configure model before assigning workspace variables
blkSim3DConfig = "HighwayLaneFollowingTestBench/Simulation 3D Scenario/Simulation 3D Scene Configuration";

% Configure the scene config block 
setSim3DSceneDesc(blkSim3DConfig, scenario)

blkMetrics = "HighwayLaneFollowingTestBench/Metrics Assessment/";

% Configure static range block to avoid error for RoadRunner test scenarios.
setStaticRangeConfig(blkMetrics, scenario);

%% Scenario parameters
assignin('base','scenario',scenario);
assignin('base','assessment',assessment);
assignin('base', 'egoActorID', scenario.Actors(1).ActorID);

%% Vehicle parameters
egoVehDyn = egoVehicleDynamicsParams(scenario);
assignin('base','egoVehDyn', egoVehDyn);
assignin('base','vehSim3D',  vehicleSim3DParams(scenario));

%% Sensor parameters
egoVehicle = scenario.Actors(1);
assignin('base','camera',    cameraParams(egoVehicle));
assignin('base','radar',     radarParams(egoVehicle));

%% General model parameters
assignin('base','Ts',0.1);                   % Algorithm sample time  (s)
assignin('base','v_set', egoVehDyn.VLong0);  % Set velocity (m/s)

%% Path following controller parameters
assignin('base','tau',             0.5);     % Time constant for longitudinal dynamics 1/s/(tau*s+1)
assignin('base','time_gap',        1.5);     % Time gap               (s)
assignin('base','default_spacing', 10);      % Default spacing        (m)
assignin('base','max_ac',          2);       % Maximum acceleration   (m/s^2)
assignin('base','min_ac',          -3);      % Minimum acceleration   (m/s^2)
assignin('base','max_steer',       0.26);    % Maximum steering       (rad)
assignin('base','min_steer',       -0.26);   % Minimum steering       (rad) 
assignin('base','PredictionHorizon', 30);    % Prediction horizon  
assignin('base','ControlHorizon', 2);        % Control horizon
assignin('base','v0_ego', egoVehDyn.VLong0); % Initial longitudinal velocity (m/s)
assignin('base','tau2', 0.07);    % Longitudinal time constant (brake)             (N/A)
assignin('base','max_dc', -10);        % Maximum deceleration   (m/s^2)
assignin('base','LaneWidth', single(3.6)); % Width of the lane (m)

%% Watchdog Braking controller parameters
assignin('base', 'PB1_decel',       3.8);      %1st stage Partial Braking deceleration (m/s^2)
assignin('base', 'PB2_decel',       5.3);      % 2nd stage Partial Braking deceleration (m/s^2)
assignin('base', 'FB_decel',        9.8);      % Full Braking deceleration              (m/s^2)
assignin('base', 'headwayOffset',   3.7);      % headway offset                         (m)
assignin('base', 'timeMargin',      0);
assignin('base', 'timeToReact',     1.2);      % driver reaction time                   (sec)
assignin('base', 'driver_decel',    4.0);      % driver braking deceleration            (m/s^2)
assignin('base','Default_decel', 0);           % Default deceleration (m/s^2)
assignin('base','TimeFactor', 1.2);            % Time factor (sec)
assignin('base','stopVelThreshold', 0.1);      % Velocity threshold for stopping ego vehicle (m/s)

%% Tracking and sensor fusion parameters
assignin('base','assigThresh',  400);    % Tracker assignment threshold          (N/A)
assignin('base','numTracks',    100);   % Maximum number of tracks              (N/A)
assignin('base','numSensors',   2);     % Maximum number of sensors             (N/A)
assignin('base','Epsilon',      2);     % Distance for clustering
assignin('base','MinNumPoints', 2);     % Minimum number of points required for clustering
assignin('base', 'M',           3);     % Tracker M value for M-out-of-N logic
assignin('base', 'N',           4);     % Tracker N value for M-out-of-N logic
assignin('base', 'P',           4);     % Tracker P value for P-out-of-R logic
assignin('base', 'R',           5);     % Tracker R value for P-out-of-R logic


% Position selector from track state.
% The filter initialization function used in this example is initcvekf that 
% defines a state that is: [x;vx;y;vy;z;vz]. 
assignin('base','posSelector', [1,0,0,0,0,0; 0,0,1,0,0,0]); % Position selector   (N/A)

%% Dynamics modeling parameters
assignin('base','m',  1575);                    % Total mass of vehicle                          (kg)
assignin('base','Iz', 2875);                    % Yaw moment of inertia of vehicle               (m*N*s^2)
assignin('base','Cf', 19000);                   % Cornering stiffness of front tires             (N/rad)
assignin('base','Cr', 33000);                   % Cornering stiffness of rear tires              (N/rad)
assignin('base','lf', egoVehDyn.CGToFrontAxle); % Longitudinal distance from c.g. to front tires (m)
assignin('base','lr', egoVehDyn.CGToRearAxle);  % Longitudinal distance from c.g. to rear tires  (m)

%% Bus creation
evalin('base','helperCreateLFBusObjects');
end

function egoVehDyn = egoVehicleDynamicsParams(scenario)
%egoVehicleDynamicsParams vehicle dynamics parameters from scenario
%
% Scenario is in ISO 8855 (North-West-Up) with respect to rear axle
% Returns struct in SAE J670E (North-East-Down) with respect to
% center of gravity (vehicle center)
%
%  egoVehDyn.X0            % Initial position X (m)
%  egoVehDyn.Y0            % Initial position Y (m)
%  egoVehDyn.Yaw0          % Initial yaw (rad)
%  egoVehDyn.VLong0        % Initial longitudinal velocity(m/sec)
%  egoVehDyn.CGToFrontAxle % Distance center of gravity to front axle (m)
%  egoVehDyn.CGToRearAxle  % Distance center of gravity to rear axle (m)

% Ego in ISO 8855 (North-West-Up) with respect to rear axle
ego = scenario.Actors(1);

% Shift reference position to center of gravity (vehicle center)
position_CG = driving.scenario.internal.Utilities.translateVehiclePosition(...
    ego.Position,...     % Position with respect to rear axle (m)
    ego.RearOverhang,... % (m)
    ego.Length,...       % (m)
    ego.Roll,...         % (deg)
    ego.Pitch,...        % (deg)
    ego.Yaw);            % (deg)

% Translate to SAE J670E (North-East-Down)
% Adjust sign of y position to 
egoVehDyn.X0  =  position_CG(1); % (m)
egoVehDyn.Y0  = -position_CG(2); % (m)
egoVehDyn.VX0 =  ego.Velocity(1); % (m)
egoVehDyn.VY0 = -ego.Velocity(2); % (m)

% Adjust sign and unit of yaw
egoVehDyn.Yaw0 = -deg2rad(ego.Yaw); % (rad)

% Longitudinal velocity 
egoVehDyn.VLong0 = hypot(egoVehDyn.VX0,egoVehDyn.VY0); % (m/sec)

% Distance from center of gravity to axles
egoVehDyn.CGToFrontAxle = ego.Length/2 - ego.FrontOverhang;
egoVehDyn.CGToRearAxle  = ego.Length/2 - ego.RearOverhang;

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
radar.DetectionRanges = [1,150];  % Ranges (m)
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
                        'roadCentersCurvedRoadSegment',...
                        'roadCentersRRHighwayRoad');

% Check the scene used for the scenario based on road centers
if isequal(scenario.RoadCenters, roadCentersValid.roadCentersStraightRoad)
    sceneDesc = "Straight road";
    set_param(blkSim3DConfig, 'ProjectFormat', "Default Scenes");
    set_param(blkSim3DConfig, 'SceneDesc', sceneDesc);
elseif isequal(scenario.RoadCenters, roadCentersValid.roadCentersCurvedRoadSegment)
    sceneDesc = "Curved road";
    set_param(blkSim3DConfig, 'ProjectFormat', "Default Scenes");
    set_param(blkSim3DConfig, 'SceneDesc', sceneDesc);
elseif isequal(scenario.RoadCenters, roadCentersValid.roadCentersRRHighwayRoad)
    % Update sim3D scene config block for Road Runner game.
    pathToUnrealExe = fullfile( ...
        matlabshared.supportpkg.getSupportPackageRoot, ...
        "toolbox","shared","sim3dprojects","driving","RoadRunnerScenes",...
        "WindowsPackage", "RRScene.exe");
    
    % Set block parameters
    if exist(pathToUnrealExe, 'file')
        projectFormat = get_param(blkSim3DConfig, 'ProjectFormat');
        if projectFormat ~= "Unreal Executable"
            set_param(blkSim3DConfig, 'ProjectFormat', "Unreal Executable");
        end
        set_param(blkSim3DConfig, 'ProjectName', pathToUnrealExe);
        set_param(blkSim3DConfig, 'ScenePath', "/Game/Maps/RRHighway");
    end
else
    error("Road centers do not match supported road types.");
end
end

function setStaticRangeConfig(blkMetrics, scenario)
% setStaticRangeConfig function disables stopping simulation when assertion
% is encountered for "Verify Lateral Deviation" and "Verify In Lane" blocks
% in the metrics assessment subsystem. 
% 
% This is done to avoid stopping simulation from expected assertions at
% segment intersections for the roads imported through OpenDRIVE.

% Valid road centers that are can be used with this example
roadCentersValid = load('laneFollowingRoadCenters.mat',...
    'roadCentersStraightRoad',...
    'roadCentersCurvedRoadSegment',...
    'roadCentersRRHighwayRoad');
if isequal(scenario.RoadCenters, roadCentersValid.roadCentersRRHighwayRoad)
    set_param(strcat(blkMetrics,"Verify Lateral Deviation"),"stopWhenAssertionFail", 'off');
    set_param(strcat(blkMetrics,"Verify In Lane"),"stopWhenAssertionFail",'off');
else
    set_param(strcat(blkMetrics,"Verify Lateral Deviation"),"stopWhenAssertionFail", 'on');
    set_param(strcat(blkMetrics,"Verify In Lane"),"stopWhenAssertionFail",'on');
end
end