function helperSLVisionVehicleDetectorSetup(nvp)
%helperSLVisionVehicleDetectorSetup 为车辆检测代码生成创建数据
%
% 通过在基础工作空间中创建数据来初始化模型VisionVehicleDetectorTestBench.slx
%
% 
% helperSLVisionVehicleDetectorSetup("detectorVariantName","ACF", "scenarioFcnName","scenario_VVD_01_Curve_FiveVehicles");
% 
% 可选输入
%   detectorVariantName:
%     - 用于车辆检测的检测器变体名
%     - 有效的值包括:
%         "ACF"  [默认变体]
%         "YOLOv2 Simulation"
%         "YOLOv2 Code Generation"
%   scenarioFcnName:
%     - 返回和VehicleDetectorTestBench.slx兼容的场景函数名
%     - 有效值为:  
%         "scenario_LFACC_01_Curve_DecelTarget" [减速的目标]
%         "scenario_LFACC_02_Curve_AutoRetarget" [自动改变目标]
%         "scenario_LFACC_03_Curve_StopnGo"        
%         "scenario_LFACC_04_Curve_CutInOut"
%         "scenario_LFACC_05_Curve_CutInOut_TooClose"
%         "scenario_LFACC_06_Straight_StopandGoLeadCar"
%         "scenario_VVD_01_Curve_FiveVehicles" [默认场景]
%         "scenario_FVSF_01_Curve_FourVehicles"
%         "scenario_FVSF_02_Straight_FourVehicles"
%         "scenario_FVSF_03_Curve_SixVehicles"
%
%
% 调用该函数的例子：
%
%    helperSLVisionVehicleDetectorSetup("scenarioFcnName", "scenario_LFACC_01_Curve_DecelTarget");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "ACF");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "YOLOv2 Simulation");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "YOLOv2 Code Generation");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName", "ACF", "scenarioFcnName", "scenario_LFACC_01_Curve_DecelTarget");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName","YOLOv2 Simulation", "scenarioFcnName","scenario_LFACC_01_Curve_DecelTarget");
%    helperSLVisionVehicleDetectorSetup("detectorVariantName","YOLOv2 Code Generation", "scenarioFcnName","scenario_LFACC_01_Curve_DecelTarget");


arguments

% nvp.scenarioFcnName的值必须为[]中的一个，等于后面的值为默认值
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

%% 加载Simulink模型
modelName = 'VisionVehicleDetectorTestBench';
wasModelLoaded = bdIsLoaded(modelName);  % 确定 模型、子系统、库 是否已经被加载
if ~wasModelLoaded
    load_system(modelName)
end

% 基于所选的车辆检测器变体创建基础工作空间变量
assignin('base', 'detectorVariant',nvp.detectorVariantName);  % 为指定工作区中的变量赋值

% 为ACF检测器变体选择ACF检测器，为YOLOv2 Simulation和YOLOv2代码生成变体选择YOLOv2检测器
if(nvp.detectorVariantName == "ACF")
    detector = VehicleDetector.ACF;
else
    detector = VehicleDetector.YOLOv2;
end

% 基于所选的'vehicleDetector'创建所需要的MAT文件数据
helperCreateCodeGenMatFile(detector);

% 调用场景函数
scenarioFcnHandle = str2func(nvp.scenarioFcnName);
[scenario, ~] = scenarioFcnHandle("mode", "openLoop");


%% Set Simulation 3D Scene Configuration block' SceneDesc parameter
% 分配工作空间变量之前进行模型的配置
blkSim3DConfig = "VisionVehicleDetectorTestBench/Sensors and Environment/Simulation 3D Scene Configuration";

% 配置场景配置模块
setSim3DSceneDesc(blkSim3DConfig, scenario);


%% 场景参数
assignin('base', 'scenario',scenario);


%% 传感器参数
egoVehicle = scenario.Actors(1);
camera = cameraParams(egoVehicle);
assignin('base','camera',    camera);
assignin('base','vehSim3D', vehicleSim3DParams(scenario));


%% 车辆参数
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

