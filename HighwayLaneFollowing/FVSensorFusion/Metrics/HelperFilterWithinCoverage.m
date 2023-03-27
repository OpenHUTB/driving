classdef HelperFilterWithinCoverage < matlab.System
    
%HelperFilterWithinCoverage Finds the actors that are in the coverage area
%   of any of the sensors mounted on the ego car. If any one of the corners
%   of the target actors are within coverage area then they are listed in
%   the ground truth else they are not listed in the truth information.

% This class is for example purpose only. It may be removed or changed
% in the future.

% Copyright 2020 The MathWorks, Inc.
    
    % Public, tunable properties
    properties       
        Camera = struct('ImageSize',[768 1024],'PrincipalPoint',[512 384],...
            'FocalLength',[512 512],'Position',[1.8750 0 1.2000],...
            'PositionSim3d',[0.5700 0 1.2000],'Rotation',[0 0 0],...
            'LaneDetectionRanges',[6 30],'DetectionRanges',[6 50],...
            'MeasurementNoise',diag([6,1,1]));
 
        Radar = struct('Position',[3.7290 0 0.8000],...
            'PositionSim3d',[2.4240 0 0.8000],'Rotation',[0 0 0],...
            'DetectionRanges',[1 70], 'FieldOfView', [40 5]);
    end
    
    properties(Nontunable)
        OutputBusName       = 'BusSimulation3DActors1';
    end
    
    % Pre-computed constants
    properties(Access = private)
        clustererDB
        sensorParamsVision;
        sensorParamsRadar;
        egoParams;
        measParamsVision;
        measParamsRadar;
        scenario;
        prevYaw;
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            
            % vision sensor parameters
            obj.sensorParamsVision = struct('Frame','spherical',...
                'OriginPosition',obj.Camera.PositionSim3d,...
                'Orientation',rotmat(quaternion([0 0 0],'eulerd','ZYX','frame'),'frame'));
            
            % radar sensor parameters
            obj.sensorParamsRadar = struct('Frame','spherical',...
                'OriginPosition',obj.Radar.PositionSim3d,...
                'Orientation',rotmat(quaternion([0 0 0],'eulerd','ZYX','frame'),'frame'));
            
            obj.egoParams = struct('Frame','rectangular',...
                'OriginPosition',[0,0,0],...
                'Orientation',rotmat(quaternion([0 0 0],'eulerd','ZYX','frame'),'frame'));
            
            
            obj.measParamsVision = [obj.sensorParamsVision; obj.egoParams];
            obj.measParamsRadar  = [obj.sensorParamsRadar;  obj.egoParams];
            obj.scenario = evalin('base', 'scenario');
        end
        
        function [truth] = stepImpl(obj,actors)
            
            %% Preallocate memory
            truth = actors;
            groundTruth = actors.Actors;
            
            % pre allocate memory for corners that has three fields(x,y,z)
            % for all the 4 corners of every actor.
            corners = zeros(3,1,4,actors.NumActors);
            
            % Find out the corners positions of each actor.
            for i=1:actors.NumActors
                actorLength = obj.scenario.Actors(i+1).Length;
                actorWidth = obj.scenario.Actors(i+1).Width;
                
                % Translate from rear axle (driving scenario) to vehicle center (Sim3D)
                % - Offset position along its orientation by -rearOverhang + length/2.
                positionVehicleCenter = driving.scenario.internal.Utilities.translateVehiclePosition(...
                    [groundTruth(i).Position(1), groundTruth(i).Position(2), groundTruth(i).Position(3)],...     % Position with respect to rear axle (m)
                    obj.scenario.Actors(i+1).RearOverhang,...                % veh.RearOverhang,
                    actorLength,...
                    groundTruth(i).Roll,...
                    groundTruth(i).Pitch,...
                    groundTruth(i).Yaw);
                
                % get the corner positions of current actor and store in
                % corners.
                corners(:,:,:,i) = ctrectcorners([positionVehicleCenter(1); positionVehicleCenter(2); groundTruth(i).Velocity(1);groundTruth(i).Yaw; 1; actorLength; actorWidth]); % [x; y; s; θ; ω; L; W]
            end
            
            % pre allocate memory for detectable list.
            detactableList = false(actors.NumActors,1);
            
            % initialize the index to 1.
            index =1;
            
            % initialize state vectors with corner positions
            cornerStates = zeros(6, 4); % for each of the 4 corners of a cuboid
            
            % Iterate over the number actors to check if any of the four
            % corners of each actor is within coverage area.
            for actorIndex = 1:actors.NumActors
                for cornerIndex = 1 : 4 % Number of corners
                    actorCorners(cornerIndex, :) = [corners(1, :, cornerIndex, actorIndex), corners(2, :, cornerIndex, actorIndex), corners(3, :, cornerIndex, actorIndex);];
                end
                
                
                % update the position of corners.
                cornerStates([1 3 5], :) = actorCorners';
                
                % get the position measurement of the state
                visionMeasurement = cvmeas(cornerStates,obj.measParamsVision);
                radarMeasurement = cvmeas(cornerStates,obj.measParamsRadar);
                
                % check if any of the four corners is in vision field of
                % view and range.
                [withinAzVision, withinElVision, withinRVision] = obj.checkVehicleCornersInSensorView(visionMeasurement, obj.Camera);

                % check if any of the four corners is in radar field of
                % view and range    
                [withinAzRadar, withinElRadar, withinRRadar] = obj.checkVehicleCornersInSensorView(radarMeasurement, obj.Radar);
                
                % Find if any of the four corners of the current actor is
                % within the vision coverage.
                isDetectableVision = withinAzVision & withinElVision & withinRVision;
                
                % Find if any of the four corners of the current actor is
                % within the radar coverage.
                isDetectableRadar = withinAzRadar & withinElRadar & withinRRadar;
                
                % Extract the isDectable list for any of the corners
                % present in at least one sensors coverage area.
                isDetectable = (isDetectableVision | isDetectableRadar);
                
                % Update the detactableList to true only if any one of the
                % corners are in the coverage area.
                if(any(isDetectable))
                    detactableList(index) = 1;
                    index = index+1;
                else
                    detactableList(index) = 0;
                    index = index+1;
                end
               
            end
            
            % extract the trackable actors that are in the coverage area
            % from the input groundTruth
            trackableTruth = groundTruth(detactableList);
            
            % update the out put bus with trackable truth.
            truth.NumActors = int32(numel(trackableTruth));
            truth.Time = actors.Time;
            for i = 1:numel(trackableTruth)
                truth.Actors(i) = trackableTruth(i);
            end
            
        end
        
        function [withInAZ, withInEL, withInR] =  checkVehicleCornersInSensorView(~, measurement, sensor)
            % check if any detection is in sensor field of
            % view and range.
            withInAZ = abs(measurement(1,:)) < sensor.FieldOfView(1);
            withInEL = abs(measurement(2,:)) < sensor.FieldOfView(2);
            withInR = measurement(3,:) < sensor.DetectionRanges(2);
        end
        
        function [out1] = getOutputSizeImpl(obj)
            % Return size for each output port
            out1 = [1 1];
        end
        
        function [out1] = getOutputDataTypeImpl(obj)
            out1 = obj.OutputBusName;
        end
        
        function [out1] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out1 = false;
        end
        
        function [out1] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out1 = true;
        end
    end
    
    methods(Access = protected, Static)
        %------------------------------------------------------------------
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end
        
        %------------------------------------------------------------------
        function flag = showSimulateUsingImpl
            % Return false if simulation mode hidden in System block dialog
            flag = false;
        end
    end
end
