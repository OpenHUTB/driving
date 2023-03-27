classdef HelperVisionVehicleDetector < matlab.System
%HelperVisionVehicleDetector 提供在图像帧上进行车辆检测的功能。
    % HelperVisionVehicleDetector 估计由单目相机monoCamera传感器所提供图像帧中的车辆位置
    % NOTE: The name of this System Object and it's functionality may 
    % change without notice in a future release, 
    % or the System Object itself may be removed.
    
    % Copyright 2020-2021 The MathWorks, Inc.

    % 默认情况下，所有属性均为可调的，这意味着属性值可以随时更改。
    % 当算法依赖于数据处理开始后始终恒定的值时，则要为属性设置为 Nontunable（不可调）。
    % 将属性定义为不可调属性后，不需要检查或响应可变值，从而可以提高算法的效率。
    % 对于代码生成，将某个属性定义为不可调属性可以优化与该属性关联的内存。
    % 您应该将影响输入或输出端口数量的所有属性都定义为不可调属性。
    properties(Nontunable)
        EnableDisplay (1, 1) logical = true;
    
        % 检测器
        Detector = VehicleDetector.ACF;
        
        % 相机传感器参数：输入图像大小
        Camera = struct('ImageSize',[768 1024],'PrincipalPoint',...
            [512 384],'FocalLength',[512 512],'Position',[1.8750 0 1.2000],...
            'PositionSim3d',[0.5700 0 1.2000],'Rotation',[0 0 0],...
            'DetectionRanges',[6 30],'MeasurementNoise',diag([6,1,1]));
    end
    
    properties (SetAccess='private', GetAccess='private', Hidden)
        % Sensor 保存单目相机配置的信息
        Sensor;
        
        % MonoDetector holds acf detector object returned by the
        % configureDetectorMonoCamera function.
        MonoDetector;
        
        % Detections that have scores less than this threshold value are
        % removed
        VehicleDetectionThreshold;
        
        % Threshold to increse the speed at the cost of accuracy for ACF
        % detector.
        ClassificationAccuracyThreshold;
        
        % Holds information of a trained you only look once (YOLO) v2
        % object detector for detecting vehicles
        YOLOv2Obj;
        
        % Default output bus 
        Vehicles
        
        % Output bus for detection information that has info about boxes
        % and scores.
        VisionInfo
    end
    
    methods
        function obj = HelperVisionVehicleDetector(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods(Access = protected)
        %------------------------------------------------------------------
        % System object methods for Simulink integration
        %------------------------------------------------------------------
        function setupImpl(obj)
            % Camera setup
            %-------------
            camera = obj.Camera;
            
            camIntrinsics = cameraIntrinsics(camera.FocalLength, ...
                camera.PrincipalPoint, camera.ImageSize);
            
            sensor = monoCamera(camIntrinsics, camera.Position(3),...
                'Pitch', camera.Rotation(2));
            
            % Assign mono camera sensor property
            obj.Sensor = sensor;
            
            if(obj.Detector == VehicleDetector.ACF)
                
                % Define the threshold for filtering detections based on
                % score.
                obj.VehicleDetectionThreshold = 20;
                
                % Define accuracy threshold for ACF detector.
                obj.ClassificationAccuracyThreshold = -1;
                
                % The width of common vehicles is between 1.5 to 2.5 meters.
                vehicleWidth = [1.5, 2.5];
                
                % Load model classifier and training options data.
                ACFModel = coder.load('vehicleDetectorACFModel.mat');
                
                % Detect objects in monocular camera using ACF features
                obj.MonoDetector = acfObjectDetectorMonoCamera(...
                    ACFModel.Classifier, ACFModel.TrainingOptions,...
                    sensor, vehicleWidth);
            elseif(obj.Detector == VehicleDetector.YOLOv2)
                % Define threshold for YOLOv2 detector.
                obj.VehicleDetectionThreshold = 0.5;

                % Load network.
                obj.YOLOv2Obj = coder.loadDeepLearningNetwork(...
                    'vehicleDetectorYOLOv2Model.mat');
            else
                error(['Please select a valid Detector:', ...
                'The valid detetcors are:', ... 
                '1.VehicleDetector.ACF', ...  
                '2.VehicleDetector.YOLOv2']);
            end
            
            % Initialize ObjectAttributes bus.
            ObjectAttributes = struct('TargetIndex', 0);
            
            % Initialize a variable with zeros for reuse in bus creation
            zo = cell(20,1);
            for i = 1:20
                zo{i} = 0;
            end
            
            % Initialize MeasurementParameters bus.
            MeasurementParameters = struct('Frame', ...
                drivingCoordinateFrameType.Invalid, ...
                'OriginPosition', zeros(3, 1), 'Orientation', ...
                zeros(3, 3), 'HasVelocity', false);
            
            % Initialize Detections bus.
            Detections = struct('Time', zo, ...
                'Measurement', zeros(3, 1), 'MeasurementNoise', ... 
                 zeros(3, 3), 'SensorIndex', ...
                zo, 'ObjectClassID', ...
                zo, 'ObjectAttributes', ...
                ObjectAttributes, 'MeasurementParameters', ...
                MeasurementParameters);

            % Initialize vehicles bus with zeros.
            obj.Vehicles = struct('NumDetections', 0,  ...
                'IsValidTime', false, 'Detections', Detections);
            
            % Initialize detections info with zeros
            VisionDetectionsInfo = struct('Boxes', zeros(1, 4), 'Scores', zo);
            
            % Initialize detection info bus with zeros.
            obj.VisionInfo = struct('NumDetections', 0, 'Detections', VisionDetectionsInfo);
            
        end
        
        function [vehicles, detectionsInfo] = stepImpl(obj,frame,t)
            
            %Initialize outputs bus with default values.
            vehicles =  obj.Vehicles;         
            detectionsInfo = obj.VisionInfo;        
            
            % Detect vehicles from the input frame.
            sensorOut = detectVehicles(obj, frame);
            
            % check if the display is enabled and the Simulation mode is
            % interpreted execution to show the results visually.
            if obj.EnableDisplay && isempty(coder.target)
                displaySensorOutputs(obj, frame, sensorOut, false);
            end
            
            % Pack the vehicle detections
            detections = packVehicleDetections(obj, sensorOut, t);
            
            % Update the output structs with vehicle detections from the
            % detector.
            vehicles.NumDetections = detections.NumDetections;
            detectionsInfo.NumDetections = detections.NumDetections;
            for n = 1:detections.NumDetections
                % Pack to constant velocity measurement format:
                vehicles.IsValidTime = true;
                vehicles.Detections(n).Measurement = detections.Detections(n).Measurement;
                vehicles.Detections(n).MeasurementNoise = detections.Detections(n).MeasurementNoise;
                vehicles.Detections(n).Time(:) = detections.Detections(n).Time(:);
                vehicles.Detections(n).SensorIndex = detections.Detections(n).SensorIndex;
                vehicles.Detections(n).ObjectClassID = detections.Detections(n).ObjectClassID;
                vehicles.Detections(n).MeasurementParameters.Frame = detections.Detections(n).MeasurementParameters.Frame;
                vehicles.Detections(n).MeasurementParameters.HasVelocity = detections.Detections(n).MeasurementParameters.HasVelocity;
                vehicles.Detections(n).MeasurementParameters.Orientation = detections.Detections(n).MeasurementParameters.Orientation;
                detectionsInfo.Detections(n).Boxes  = sensorOut.vehicleBoxes(n,:);
                detectionsInfo.Detections(n).Scores  = double(sensorOut.vehicleScores(n));
            end
        end
        
        function [vehicles, detectionInfo] = getOutputSizeImpl(obj) %#ok<MANU>
            % Return size for each output port
            vehicles = 1;
            detectionInfo = 1;
        end
        
        function [vehicles, detectionInfo] = getOutputDataTypeImpl(obj) %#ok<MANU>
            % Return data type for each output port
            vehicles = "BusVision";
            detectionInfo = "BusVisionInfo";
        end
        
        function [vehicles, detectionInfo] = isOutputComplexImpl(obj) %#ok<MANU>
            % Return true for each output port with complex data
            vehicles = false;
            detectionInfo = false;
        end
        
        function [vehicles, detectionInfo] = isOutputFixedSizeImpl(obj) %#ok<MANU>
            % Return true for each output port with fixed size
            vehicles = true;
            detectionInfo = true;
        end
        
        function sensorOut =  detectVehicles(obj,frame)
            
            % Detect the vehicles.
            if(obj.Detector == VehicleDetector.ACF)
                [bboxes, scores] = detect(obj.MonoDetector, ...
                    frame, [1 1 1024 480], 'Threshold',...
                    obj.ClassificationAccuracyThreshold);
                
                % Remove detections with low classification scores
                if ~isempty(scores)
                    ind = scores >= obj.VehicleDetectionThreshold;
                    bboxes = bboxes(ind, :);
                end
            elseif(obj.Detector == VehicleDetector.YOLOv2)
                [bboxes,scores,~] = detect(obj.YOLOv2Obj, frame,...
                    [1 1 1024 480], 'Threshold',...
                    obj.VehicleDetectionThreshold);
            end

            % Compute distance in vehicle coordinates
            sensorOut.vehicleLocations = computeVehicleLocations(bboxes, obj.Sensor);
            sensorOut.vehicleBoxes     = bboxes;
            sensorOut.vehicleScores     = scores;
        end
        
        % Display function.
        function isPlayerOpen = ...
                displaySensorOutputs(~, frame, sensorOut, closePlayers)
            
            locations        = sensorOut.vehicleLocations;
            
            frameWithOverlays = insertVehicleDetections(frame, locations, sensorOut.vehicleBoxes);
            
            % Display the results
            frames = {frameWithOverlays};
            
            persistent players;
            if isempty(players)
                frameNames = {'Vehicle detections'};
                players = HelperVideoPlayerSet(frames, frameNames);
            end
            update(players, frames);
            
            % terminate the loop when the first player is closed
            isPlayerOpen = isOpen(players, 1);
            
            if (~isPlayerOpen || closePlayers) % close down the other players
                clear players;
            end
        end
        
        % Pack the vehicles
        function detections = packVehicleDetections(obj,sensorOut,t)
            
            %Initialize detections bus with zeros.
            detections = obj.Vehicles;     
            
            locations = sensorOut.vehicleLocations;
            
            numDetections = size(locations,1);
            detections.NumDetections = numDetections;
            
            for n = 1:numDetections
                % Bias location measurements as expected by sensor fusion -
                % Sensor fusion is with respect to vehicle center with
                % Unreal sensors.
                %  - camera.PositionSim3D is mount position
                % with respect to vehicle center.
                locations(n,:) = locations(n,:) + obj.Camera.PositionSim3d(1:2);
                
                % Pack to constant velocity measurement format:
                detections.IsValidTime = true;
                detections.Detections(n).Measurement = [...
                    locations(n,1),...
                    locations(n,2),...
                    0]'; % [x,y,z]
                detections.Detections(n).MeasurementNoise = obj.Camera.MeasurementNoise;
                detections.Detections(n).Time(:) = t;
                detections.Detections(n).SensorIndex = 1;
                detections.Detections(n).ObjectClassID = 1;
                detections.Detections(n).MeasurementParameters.Frame = drivingCoordinateFrameType.Rectangular;
                detections.Detections(n).MeasurementParameters.HasVelocity = false;
                detections.Detections(n).MeasurementParameters.Orientation = eye(3);
            end
        end
        
    end
    
    methods(Access = protected, Static)
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(....
                "Title","HelperVisionVehicleDetector",...
                "Text",...
                "Detects vehicles from a monocamera image.");
        
        end
        
        function flag = showSimulateUsingImpl
            % Return false if simulation mode hidden in System block dialog
            flag = true;
        end
    end
    
end

function locations = computeVehicleLocations(bboxes, sensor)

locations = zeros(size(bboxes,1),2);
for i = 1:size(bboxes, 1)
    bbox  = bboxes(i, :);
    
    yBottom = bbox(2) + bbox(4) - 1;
    xCenter = bbox(1) + (bbox(3)-1)/2;
    
    locations(i,:) = imageToVehicle(sensor, [xCenter, yBottom]);
end
end

% insertVehicleDetections function inserts bounding boxes and displays
% [x,y] locations corresponding to returned vehicle detections.
function imgOut = insertVehicleDetections(imgIn, locations, bboxes)

imgOut = imgIn;

for i = 1:size(locations, 1)
    location = locations(i, :);
    bbox     = bboxes(i, :);
    
    label = sprintf('X=%0.2f, Y=%0.2f', location(1), location(2));
    
    imgOut = insertObjectAnnotation(imgOut, ...
        'rectangle', bbox, label);
end
end
