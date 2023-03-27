classdef HelperLaneDetectorWrapper < matlab.System
    %HelperLaneDetectorWrapper Provides wrapper to the helperLaneDetector class.
    %
    % NOTE: The name of this System Object and it's functionality may
    % change without notice in a future release,
    % or the System Object itself may be removed.
    
    % Copyright 2020 The MathWorks, Inc.
    
    properties(Nontunable)
        % Enabling lane tracker
        EnableLaneTracker (1, 1) logical = true;
        
         % Display debug visualization windows
        EnableDisplays (1, 1) logical = true;
    end
    
    properties
       % Camera sensor parameters
        Camera = struct('ImageSize',[768 1024],'PrincipalPoint',[512 384],...
            'FocalLength',[512 512],'Position',[1.8750 0 1.2000],...
            'PositionSim3d',[0.5700 0 1.2000],'Rotation',[0 0 0],...
            'LaneDetectionRanges',[6 30],'DetectionRanges',[6 50],...
            'MeasurementNoise',diag([6,1,1]));
    end
    
    properties (SetAccess='private', GetAccess='private', Hidden)
        % helperLaneDetector object
        LaneMarkerDetector
    end
    
    methods(Access = protected)
        %------------------------------------------------------------------
        % System object methods for Simulink integration
        %------------------------------------------------------------------
        function setupImpl(obj)
            % Camera setup
            %-------------
            camera = obj.Camera;     
            focalLength    = camera.FocalLength;
            principalPoint = camera.PrincipalPoint;
            imageSize      = camera.ImageSize;
            % mounting height in meters from the ground
            height         = camera.Position(3);  
            % pitch of the camera in degrees
            pitch          = camera.Rotation(2);  
            
            camIntrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
            sensor        = monoCamera(camIntrinsics, height, 'Pitch', pitch);
            obj.LaneMarkerDetector = helperLaneDetector(sensor);
            % Lane marker detection parameters
            %---------------------------------
            % The percentage extent of the ROI a lane needs to cover. It can remove
            % noisy detections
            obj.LaneMarkerDetector.LaneXExtentThreshold = 0.25;
            % Sensitivity for the lane segmentation routine
            obj.LaneMarkerDetector.LaneSegmentationSensitivity = 0.5; 
            % Approximate lane marker width specified in meters
            obj.LaneMarkerDetector.ApproximateLaneMarkerWidth = 0.3;  
            % The percentage of inlier points required per unit length
            obj.LaneMarkerDetector.LaneStrengthThreshold = 0.2;   
            % Maximum number of lane marker detections from
            % findParabolicLaneBoundaries
            obj.LaneMarkerDetector.MaxNumLaneMarkersToDetect = 5;
            % Min and max lane detection range specified in meters
            obj.LaneMarkerDetector.LaneDetectionRanges = camera.LaneDetectionRanges;
            
        end
        
        function lanes = stepImpl(obj,frame)
            
            % Detect lane boundaries
            [leftEgoBoundary,rightEgoBoundary] = laneDetector(obj.LaneMarkerDetector, frame);

            % Reject invalid lanes when lane tracker is enabled
            if obj.EnableLaneTracker
                [leftEgoBoundary,rightEgoBoundary] = rejectInvalidLanes(obj.LaneMarkerDetector,leftEgoBoundary,rightEgoBoundary);
            end
            
            % Display debugging windows in Normal simulation mode and when EnableDisplays is set.
            if(isempty(coder.target))
                if obj.EnableDisplays
                    displaySensorOutputs(obj, frame, leftEgoBoundary,rightEgoBoundary, false);
                end
            end
            
            % Pack lane boundaries to LaneSensor as expected by LaneFollowingDecisionLogicandControl
            lanes = packLaneBoundaryDetections(obj,leftEgoBoundary,rightEgoBoundary);
        end
        
        %------------------------------------------------------------------
        % packLaneBoundaryDetections method packs left and right lane
        % detections into a format expected by
        % LaneFollowingDecisionLogicandControl.
        function detections = packLaneBoundaryDetections(obj,leftEgoBoundary,rightEgoBoundary)
            % Parameters of parabolicLaneBoundary object = [A B C]
            %  corresponds to the three coefficients of a second-degree
            %  polynomial equation:
            %                y = Ax^2 + Bx + C
            % Comparing this equation with lane model using 2nd order
            % polynomial approximation:
            %  y = (curvature/2)*(x^2) + (headingAngle)*x + lateralOffset
            %
            % This leads to the following relationship
            %   curvature           = 2 * A = 2 * Parameters(1)  (unit: 1/m)
            %   headingAngle        = B     = Parameters(2)      (unit: radians)
            %   lateralOffset       = C     = Parameters(3)      (unit: meters)
            %
            
            % Preallocate struct expected by controller
            DefaultLanesLeft = struct('Curvature',{single(obj.LaneMarkerDetector.DefaultLeftLaneParams(1))},...
                'CurvatureDerivative',{single(0)},...
                'HeadingAngle',{single(obj.LaneMarkerDetector.DefaultLeftLaneParams(2))},...
                'LateralOffset',{single(obj.LaneMarkerDetector.DefaultLeftLaneParams(3))},...
                'Strength',{single(0)},...
                'XExtent',{single([0,0])},...
                'BoundaryType',{LaneBoundaryType.Unmarked});
            
            DefaultLanesRight = struct('Curvature',{single(obj.LaneMarkerDetector.DefaultRightLaneParams(1))},...
                'CurvatureDerivative',{single(0)},...
                'HeadingAngle',{single(obj.LaneMarkerDetector.DefaultRightLaneParams(2))},...
                'LateralOffset',{single(obj.LaneMarkerDetector.DefaultRightLaneParams(3))},...
                'Strength',{single(0)},...
                'XExtent',{single([0,0])},...
                'BoundaryType',{LaneBoundaryType.Unmarked});
            
            field1 = 'Left'; field2 = 'Right';
            detections = struct(field1,DefaultLanesLeft,field2,DefaultLanesRight);                     
            
            % Pack left lane detections 
            detections.Left.Curvature(:)     = 2 * leftEgoBoundary.Parameters(1);
            detections.Left.HeadingAngle(:)  = leftEgoBoundary.Parameters(2); % Coordinate transform
            detections.Left.LateralOffset(:) = leftEgoBoundary.Parameters(3); % Coordinate transform
            detections.Left.Strength(:)      = leftEgoBoundary.Strength;
            detections.Left.XExtent(:)       = leftEgoBoundary.XExtent;
            detections.Left.BoundaryType(:)  = leftEgoBoundary.BoundaryType;
            
            % Pack right lane detections 
            detections.Right.Curvature(:)     = 2 * rightEgoBoundary.Parameters(1);
            detections.Right.HeadingAngle(:)  = rightEgoBoundary.Parameters(2); % Coordinate transform
            detections.Right.LateralOffset(:) = rightEgoBoundary.Parameters(3); % Coordinate transform
            detections.Right.Strength(:)      = rightEgoBoundary.Strength;
            detections.Right.XExtent(:)       = rightEgoBoundary.XExtent;
            detections.Right.BoundaryType(:)  = rightEgoBoundary.BoundaryType;

            % Shift detections to vehicle center as required by controller
            % Note: camera.PositionSim3d(1) represents the X mount location of the
            %       camera sensor with respect to the vehicle center
            if nnz(leftEgoBoundary.Parameters)
                detections.Left.LateralOffset(:) = polyval(...
                    leftEgoBoundary.Parameters, -obj.Camera.PositionSim3d(1));
                % Lane to left should always have positive lateral offset
                if detections.Left.LateralOffset < 0
                    detections.Left = DefaultLanesLeft;
                end
            end
            if nnz(rightEgoBoundary.Parameters)
                detections.Right.LateralOffset(:) = polyval(...
                    rightEgoBoundary.Parameters, -obj.Camera.PositionSim3d(1));
                % Lane to right should always have negative lateral offset
                if detections.Right.LateralOffset > 0
                    detections.Right = DefaultLanesRight;
                end
            end
        end
        
        %------------------------------------------------------------------
        % displaySensorOutputs method displays core information and
        % intermediate results from the monocular camera sensor simulation.
        function isPlayerOpen = ...
                displaySensorOutputs(obj, frame, leftEgoBoundary,rightEgoBoundary, closePlayers)
            sensor = obj.LaneMarkerDetector.Sensor;
            bottomOffset      = obj.LaneMarkerDetector.LaneDetectionRanges(1);
            distAheadOfSensor = obj.LaneMarkerDetector.LaneDetectionRanges(2);
            xVehiclePoints = bottomOffset:distAheadOfSensor;
            birdsEyeViewImage = obj.LaneMarkerDetector.BirdsEyeImage;
            birdsEyeConfig    = obj.LaneMarkerDetector.BirdsEyeConfig;
            birdsEyeViewBW    = obj.LaneMarkerDetector.BirdsEyeBW;
            if(~nnz(leftEgoBoundary.Parameters))
                leftEgoBoundary = parabolicLaneBoundary.empty;
            end
            if(~nnz(rightEgoBoundary.Parameters))
                rightEgoBoundary = parabolicLaneBoundary.empty;
            end
            birdsEyeWithOverlays = insertLaneBoundary(birdsEyeViewImage, leftEgoBoundary , birdsEyeConfig, xVehiclePoints, 'Color','Red');
            birdsEyeWithOverlays = insertLaneBoundary(birdsEyeWithOverlays, rightEgoBoundary, birdsEyeConfig, xVehiclePoints, 'Color','Green');
            
            frameWithOverlays = insertLaneBoundary(frame, leftEgoBoundary, sensor, xVehiclePoints, 'Color','Red');
            frameWithOverlays = insertLaneBoundary(frameWithOverlays, rightEgoBoundary, sensor, xVehiclePoints, 'Color','Green');
            
            imageROI = vehicleToImageROI(obj.LaneMarkerDetector);
            ROI = [imageROI(1) imageROI(3) imageROI(2)-imageROI(1) imageROI(4)-imageROI(3)];
            
            % Highlight candidate lane points that include outliers
            birdsEyeViewImage = insertShape(birdsEyeViewImage, 'rectangle', ROI); % show detection ROI
            birdsEyeViewImage = imoverlay(birdsEyeViewImage, birdsEyeViewBW, 'yellow');
            
            % Display the results
            frames = {frameWithOverlays, birdsEyeViewImage, birdsEyeWithOverlays};        
            persistent players;
            if isempty(players)
                frameNames = {'Lane marker detections', 'Raw segmentation', 'Lane marker detections'};
                players = HelperVideoPlayerSet(frames, frameNames);
            end
            update(players, frames);
            
            % terminate the loop when the first player is closed
            isPlayerOpen = isOpen(players, 1);
            
            if (~isPlayerOpen || closePlayers) % close down the other players
                clear players;
            end
        end        
        
        function [lanes] = getOutputSizeImpl(obj) %#ok<MANU>
            % Return size for each output port
            lanes = 1;
        end
        
        function [lanes] = getOutputDataTypeImpl(obj) %#ok<MANU>
            % Return data type for each output port
            lanes = "LaneSensor";
        end
        
        function [lanes] = isOutputComplexImpl(obj) %#ok<MANU>
            % Return true for each output port with complex data
            lanes= false;
        end
        
        function [lanes] = isOutputFixedSizeImpl(obj) %#ok<MANU>
            % Return true for each output port with fixed size
            lanes = true;
        end
    end
    
    methods(Access = protected, Static)
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(....
                "Title","HelperLaneDetectorWrapper",...
                "Text",...
                "Detects lanes from camera image." + newline + newline +...
                "Enable display of debugging visualizations to show intermediate processing for lane detections.");
        end

        function flag = showSimulateUsingImpl
            % Return false if simulation mode hidden in System block dialog
            flag = true;
        end
    end
            
    
end
