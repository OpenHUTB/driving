classdef HelperVisualizeVehicles < matlab.System
    %HelperVisualizeVehicles visualizes vehicle detections on image frame.
    %It also overlays the ground truth bounding boxes for the vehicles
    % obtained from scenario.
    %
    % NOTE: The name of this class and it's functionality may
    % change without notice in a future release,
    % or the class itself may be removed.
    
    % Copyright 2020 The MathWorks, Inc.
    
    properties(Nontunable)
        % Enable display of vehicles from ground truth
        EnableTruthDisplay (1, 1) logical = false;
    end
    
    properties
        % Camera sensor parameters
        Camera = struct('ImageSize',[768 1024],'PrincipalPoint',...
            [512 384],'FocalLength',[512 512],'Position',[1.8750 0 1.2000],...
            'PositionSim3d',[0.5700 0 1.2000],'Rotation',[0 0 0],...
            'DetectionRanges',[6 30],'MeasurementNoise',diag([6,1,1]));
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
        
        function stepImpl(obj, frame, groundTruthVehicles, detectedVehicles)
            % Visualize detected vehicle and ground truth vehicles
            visualizeVehicles(obj, detectedVehicles, groundTruthVehicles,frame);
        end
        
        % Visualize the frame captured by camera sensor with overlay
        % vehicle boxes in yellow and ground truth vehicle boxes in blue
        % color.
        function frameOut = visualizeVehicles(obj, detectedVehicles, groundTruthVehicles, frame)

            frameOut = frame;
            
            % Insert label for detected vehicles.
            frameOut = insertText(frameOut,[800 100], 'Detected Vehicles','BoxColor', 'yellow','BoxOpacity',0.5,'TextColor','white','FontSize',18);
            % Display ground truth vehicles in blue when
            % EnableTruthDisplay is true.
            if obj.EnableTruthDisplay
                % Insert label for ground truth.
                frameOut = insertText(frameOut,[800 50], 'Ground Truth Vehicles','BoxColor', 'blue','BoxOpacity',0.8,'TextColor','white','FontSize',18);
                bboxes = zeros(20,4);
                nonZeroBbox = groundTruthVehicles(any(groundTruthVehicles, 2), :);
                for p = 1: size(nonZeroBbox,1)
                    bboxes(p,:) = nonZeroBbox(p,:);
                    thisBB = bboxes(p,:);  
                    label = sprintf('X=%0.2f, Y=%0.2f', thisBB(1), ...
                        thisBB(2));
                    frameOut = insertObjectAnnotation(frameOut, ...
                        'rectangle', [thisBB(1), thisBB(2), thisBB(3), ...
                        thisBB(4)], label, 'Color', 'blue');  
                end 
            end
            % Display vehicle detections in yellow when
            % NumDetections is greater than 0.
            if(detectedVehicles.NumDetections>0)
                for i=1:detectedVehicles.NumDetections
                    detectedBBoxes(i,:)= detectedVehicles.Detections(i).Boxes;
                end
                frameOut = insertVehicleDetections(frameOut, detectedBBoxes);
            end
            
            persistent players;
            
            % Display the results
            frames = {frameOut};
            if isempty(players)
                frameNames = {'Vehicle detections and ground truth'};
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
                "Title","HelperVisualizeVehicles",...
                "Text",...
                "Visualize ground truth and detected vehicle bounding boxes on image frame.");
        end
        
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
        
    end
    
end

% insertVehicleDetections function inserts bounding boxes.
function imgOut = insertVehicleDetections(imgIn, bboxes)

imgOut = imgIn;

for i = 1:size(bboxes, 1)
    bbox     = bboxes(i, :);
    
    label = sprintf('X=%0.2f, Y=%0.2f', bbox(1), bbox(2));
    
    imgOut = insertObjectAnnotation(imgOut, ...
        'rectangle', bbox, label,'Color','y');
end
end