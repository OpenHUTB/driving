classdef HelperVisualizeLanes < matlab.System
    %HelperVisualizeLanes visualizes lane marker detections on image frame. It
    % also overlays ground truth lanes obtained from scenario.
    %
    % NOTE: The name of this class and it's functionality may
    % change without notice in a future release,
    % or the class itself may be removed.
    
    % Copyright 2020 The MathWorks, Inc.
    
    properties(Nontunable)        
        % Enable display of lanes from ground truth
        EnableTruthDisplay (1, 1) logical = false;
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
        Sensor
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
            % Assign mono camera sensor property
            obj.Sensor = sensor;
        end
        
        function stepImpl(obj,detectedLaneBoundaries,frame,groundTruthLaneboundaries)
            % Visualize detected lane boundaries and ground truth lane
            % boundaries
            visualizeLanes(obj,detectedLaneBoundaries,groundTruthLaneboundaries,frame);
            
        end
        % Visualize the frame captured by camera sensor with overlay left
        % lane boundary in Red, right lane boundary in green and ground
        % truth lane boundaries in blue color.
        function frameOut = visualizeLanes(obj,detectedLaneBoundaries,groundTruthLaneboundaries,frame)
            leftLanes = detectedLaneBoundaries.Left;
            rightLanes = detectedLaneBoundaries.Right;
            leftLaneBoundaries = parabolicLaneBoundary([leftLanes.Curvature/2,leftLanes.HeadingAngle,leftLanes.LateralOffset]);
            rightLaneBoundaries = parabolicLaneBoundary([rightLanes.Curvature/2,rightLanes.HeadingAngle,rightLanes.LateralOffset]);
            leftLaneBoundaries.BoundaryType = leftLanes.BoundaryType;
            rightLaneBoundaries.BoundaryType = rightLanes.BoundaryType;
            leftLaneBoundaries.XExtent = leftLanes.XExtent;
            rightLaneBoundaries.XExtent = rightLanes.XExtent;
            xVehiclePoints = obj.Camera.LaneDetectionRanges(1):obj.Camera.LaneDetectionRanges(2);
            sensor        = obj.Sensor;
            frameOut = frame;
            % Display ground truth lane boundaries in Blue when
            % EnableTruthDisplay is true.
            if obj.EnableTruthDisplay
                leftTruth.Parameters = polyfit(groundTruthLaneboundaries.LaneBoundaries(1).Coordinates(:,1), groundTruthLaneboundaries.LaneBoundaries(1).Coordinates(:,2),2);
                rightTruth.Parameters = polyfit(groundTruthLaneboundaries.LaneBoundaries(2).Coordinates(:,1), groundTruthLaneboundaries.LaneBoundaries(2).Coordinates(:,2),2);
                
                leftTruthBoundaries = parabolicLaneBoundary([leftTruth.Parameters(1), leftTruth.Parameters(2),leftTruth.Parameters(3)] );
                rightTruthBoundaries = parabolicLaneBoundary([rightTruth.Parameters(1), rightTruth.Parameters(2),rightTruth.Parameters(3)] );
                
                frameOut = insertLaneBoundary(frameOut, leftTruthBoundaries, sensor,xVehiclePoints, 'Color', 'Blue');
                frameOut = insertLaneBoundary(frameOut, rightTruthBoundaries, sensor,xVehiclePoints, 'Color', 'yellow');
                frameOut = insertText(frameOut,[680 120], '- Left Truth','Font','LucidaSansRegular','BoxColor','white','TextColor','blue','FontSize',18);
                frameOut = insertText(frameOut,[680 160], '- Right Truth','Font','LucidaSansRegular','BoxColor','white','TextColor','yellow','FontSize',18);
            end
            
            frameOut = insertLaneBoundary(frameOut, leftLaneBoundaries, sensor,xVehiclePoints, 'Color', 'Red');
            frameOut = insertLaneBoundary(frameOut, rightLaneBoundaries, sensor,xVehiclePoints, 'Color', 'Green');
            frameOut = insertText(frameOut,[680 40], '- Left Lane Detection','Font','LucidaSansRegular','BoxColor','white','TextColor','Red','FontSize',18);
            frameOut = insertText(frameOut,[680 80], '- Right Lane Detection','Font','LucidaSansRegular','BoxColor','white','TextColor','Green','FontSize',18);
            
            persistent players;
            
            % Display the results
            frames = {frameOut};
            if isempty(players)
                frameNames = {'Lane marker detections and ground truth'};
                players = HelperVideoPlayerSet(frames,frameNames);
            end
            update(players, frames);
            
            % terminate the loop when the first player is closed
            isPlayerOpen = isOpen(players, 1);
            
            if (~isPlayerOpen) % close down the other players
                clear players;
            end
            
        end
    end
    
    methods(Access = protected, Static)
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(....
                "Title","HelperVisualizeLanes",...
                "Text",...
                "Visualize the detected lane boundaries and ground truth lane boundaries.");
        end
        
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
           
    end
    
    
end

