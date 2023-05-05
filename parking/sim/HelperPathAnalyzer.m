classdef HelperPathAnalyzer < matlab.System 
%HelperPathAnalyzer Provide reference inputs for vehicle controllers.
%   HelperPathAnalyzer computes the reference pose and the reference
%   velocity based on the current pose of the vehicle.
%
%   pathAnalyzer = HelperPathAnalyzer creates a system object,
%   pathAnalyzer, that calculate reference inputs for vehicle controllers.
%
%   pathAnalyzer = HelperPathAnalyzer(Name,Value) creates a system object,
%   pathAnalyzer, with additional options specified by one or more
%   Name,Value pair arguments:
%
%   'Wheelbase'             Wheelbase of the vehicle
%
%                           Default: 2.8 (meters)
%
%   'RefPoses'              A N-by-3 matrix representing the poses of the
%                           reference path
%
%   'Directions'            A N-by-1 vector representing the driving
%                           directions at each point on the reference path.
%                           The vector is composed by possible values: 1
%                           for forward motion and -1 for reverse motion.
%
%   'Curvatures'            A N-by-1 vector representing the curvature
%                           of the reference path
%
%   'VelocityProfile'       A N-by-1 vector representing the velocities along
%                           the reference path (in meters/second)
%
%
%   Step method syntax:
%   [refPose, refVel, direction] = step(pathAnalyzer, currPose, currVel)
%   returns the reference pose, refPose, reference velocity, refVel, and
%   the driving direction based on the current pose, currPose and the
%   current velocity, currVel of the vehicle.
%
%   System objects may be called directly like a function instead of using
%   the step method. For example, y = step(obj) and y = obj() are equivalent.
%
%   HelperPathAnalyzer properties:
%   Wheelbase              - Wheelbase of the vehicle
%   RefPoses               - Poses of the reference path
%   VelocityProfile        - Velocities along the reference path
%   Directions             - Driving directions at each point on the path
%   Curvatures             - Path curvaturesa at each point on the path
%
%   HelperPathAnalyzer methods:
%   step                   - Compute reference poses, velocity and direction
%   release                - Allow property value changes
%   clone                  - Create a copy of the object
%   isLocked               - Locked status (logical)
%
%   See also lateralControllerStanley, HelperLongitudinalController,
%     smoothPathSpline, helperGenerateVelocityProfile
    
%   Copyright 2018-2021 The MathWorks, Inc.
    
    % Public, non-tunable properties
    properties(Nontunable)
        %Wheelbase Vehicle wheelbase (m)
        %   A scalar specifying the distance between the front and the rear
        %   axles.
        %
        %   Default: 2.8 (m)
        Wheelbase       = 2.8
    end
    
    % Public properties (Only used in MATLAB)
    properties    
        %RefPoses Vehicle poses along the reference path
        %   
        RefPoses
        
        %VelocityProfile Speed profile along the reference path
        %
        VelocityProfile
        
        %Directions Driving directions corresponding to RefPoses
        %
        Directions
        
        %Curvatures Path curvatures 
        %
        Curvatures
    end
    
    % Public properties (Only used in Simulink)
    properties(Nontunable)
        %HasResetOutput Show Reset output port
        %   Flag indicating if the Reset output port is enabled. 
        %
        %   Default:      false
        HasResetOutput (1, 1) logical  = false;
    end
    
    properties(Access = private)
        %ClosestPointIndex Store the previous projection point index
        %   to handle encircled path
        %
        %   Default: 1
        ClosestPointIndex      = 1
        
        %NumPathSegments Number of segments in a path. When 
        %
        %   Default: 1
        NumPathSegments        = 1
        
        %CurrentSegmentIndex Index of the current segment
        %
        CurrentSegmentIndex    = 1
        
        %SegmentStartIndex A vector storing the indices of the starting 
        %   points of all the path segments
        %
        SegmentStartIndex
        
        %SegmentStartIndex  A vector storing the indices of the ending 
        %   points of all the path segments
        SegmentEndIndex
        
        % The following four properties are used to transfer reference 
        % data within the system object. Depending on the environment the 
        % object is executing in, they are assigned either by public
        % properties, RefPoses, VelocityProfile, Directions and Curvatures 
        % in MATLAB, or by the input ports in Simulink. The selection is 
        % determined by the HasReferenceInports property.
        
        %RefPosesInternal
        RefPosesInternal
        
        %DirectionsInternal
        DirectionsInternal
        
        %CurvaturesInternal
        CurvaturesInternal
        
        %VelocityProfileInternal
        VelocityProfileInternal
        
        % The following four properties are used to store the last output.
        
        %LastRefPoseOutput
        LastRefPoseOutput      = [0 0 0]
        
        %LastRefVelocityOutput
        LastRefVelocityOutput  = 0
        
        %LastCurvatureOutput
        LastCurvatureOutput    = 0
        
        %LastDirectionOutput
        LastDirectionOutput    = 1
    end
    
    properties(Access = private, Nontunable)
        %HasReferenceInports Flag indicating if there are refPose, directions
        %    and VelocityProfile inputs in stepImp. In MATLAB, all these 
        %    values are set via properties while in Simulink they are 
        %    passed as inputs via input ports.
        %
        %   Default:          false
        HasReferenceInports (1, 1) logical   = false
    end
    
    %----------------------------------------------------------------------
    % Setter and constructor
    %----------------------------------------------------------------------
    methods
        %------------------------------------------------------------------
        function set.RefPoses(obj, refPoses)
            
            validateattributes(refPoses, {'single', 'double'}, ...
                {'nonnan', 'real', 'ncols', 3, 'finite', 'nonempty'}, ...
                mfilename, 'RefPoses');
            
            obj.RefPoses = refPoses;
        end
        
        %------------------------------------------------------------------
        function set.Directions(obj, directions)
            
            validateattributes(directions, {'single', 'double'}, ...
                {'nonnan', 'real', 'column', 'finite', 'nonempty'}, ...
                mfilename, 'Directions');
            
            obj.Directions =  directions;
        end
        
        %------------------------------------------------------------------
        function set.Curvatures(obj, kappas)
            
            validateattributes(kappas, {'single', 'double'}, ...
                {'nonnan', 'real', 'column', 'finite', 'nonempty'}, ...
                mfilename, 'Curvatures');
            obj.Curvatures =  kappas;
        end
        
        %------------------------------------------------------------------
        function set.VelocityProfile(obj, VelocityProfile)
            
            validateattributes(VelocityProfile, {'single', 'double'}, ...
                {'nonnan', 'real', 'column', 'finite', 'nonempty'}, ...
                mfilename, 'VelocityProfile');
            obj.VelocityProfile =  VelocityProfile;
        end
        
        %------------------------------------------------------------------
        function set.Wheelbase(obj, wheelbase)
            
            validateattributes(wheelbase, {'single', 'double'}, ...
                {'nonnan', 'real', 'scalar', 'finite', 'nonempty'}, ...
                mfilename, 'Wheelbase');
            obj.Wheelbase =  wheelbase;
        end
        
        %------------------------------------------------------------------
        function obj = HelperPathAnalyzer(varargin)
            %HelperPathAnalyzer Constructor 
            setProperties(obj,nargin,varargin{:}, 'RefPoses', ...
                'VelocityProfile','Directions', 'Wheelbase');
        end
    end
    
    %----------------------------------------------------------------------
    % Main algorithm
    %----------------------------------------------------------------------
    methods(Access = protected)
        %------------------------------------------------------------------
        function setupImpl(obj, ~, ~, varargin)
            %setupImpl Perform one-time calculations
            obj.ClosestPointIndex   = 1;
            obj.NumPathSegments     = 1;
            obj.CurrentSegmentIndex = 1;
            
            if isSimulinkBlock(obj) % In Simulink
                obj.HasReferenceInports = true;
      
                obj.RefPosesInternal     = nan(size(varargin{1}), 'like', varargin{1});
                obj.DirectionsInternal   = nan(size(varargin{2}), 'like', varargin{2});
                obj.CurvaturesInternal   = nan(size(varargin{3}), 'like', varargin{3});
                obj.VelocityProfileInternal = nan(size(varargin{4}), 'like', varargin{4});
            else % In MATLAB
                obj.HasReferenceInports = false;
            end
        end
        
        %------------------------------------------------------------------
        function processTunedPropertiesImpl(obj)
            % processTunedPropertiesImpl Perform actions when tunable 
            % properties change between calls to the System object
            propChange = isChangedProperty(obj,'RefPoses') || ...
                isChangedProperty(obj,'VelocityProfile') || ...
                isChangedProperty(obj,'Directions');
            if propChange
                obj.CurrentSegmentIndex = 1;
                obj.ClosestPointIndex   = 1;
            end
        end
        
        %------------------------------------------------------------------
        function [refPose, refVel, direction, curvature, varargout] = stepImpl(obj, ...
                currPose, currVel, varargin)
            %stepImpl Implement the main algorithm and return the reference
            %   pose, velocity and driving direction. varargout is an
            %   optional output in Simulink that signifies reaching
            %   intermediate goals within a reference path, i.e., reaching
            %   the direction-switching positions. 
            
            if obj.HasReferenceInports 
                % Check if the reference path is new
                if ~isequal(obj.RefPosesInternal, varargin{1})
                    obj.RefPosesInternal     = varargin{1};
                    obj.DirectionsInternal   = varargin{2};
                    obj.CurvaturesInternal   = varargin{3};
                    obj.VelocityProfileInternal = varargin{4};
                    
                    obj.CurrentSegmentIndex = 1;
                    obj.ClosestPointIndex   = 1;
                end
            else % In MATLAB, values are from properties
                obj.RefPosesInternal      = obj.RefPoses;
                obj.DirectionsInternal    = obj.Directions;
                obj.VelocityProfileInternal  = obj.VelocityProfile;
                obj.CurvaturesInternal    = obj.Curvatures;
            end
            
            % Divide the path to segments based on driving direction
            findSegmentBoundaryPointIndex(obj);
            
            % Check if reaching the final goal. If yes, use the previous
            % outputs
            if obj.CurrentSegmentIndex > obj.NumPathSegments
                refPose   = obj.LastRefPoseOutput;
                refVel    = obj.LastRefVelocityOutput;
                direction = obj.LastDirectionOutput;
                curvature = obj.LastCurvatureOutput;
                if obj.HasResetOutput && isSimulinkBlock(obj)
                    varargout{1} = 1;
                end
                return
            end
            
            % Get the desired pose, desired velocity and driving direction
            [refPose, refVel, direction, curvature] = findDesiredPoseAndVelocity(obj, currPose);
            
            % Check if the vehicle reaches the intermediate goal. If yes,
            % increment the path segment index and reset reference velocity
            % to zero as the vehicle needs to switch direction at the
            % intermediate goal positions
            currGoalIndex = obj.SegmentEndIndex(obj.CurrentSegmentIndex);
            nextGoal      = obj.RefPosesInternal(currGoalIndex, :);
            endRefVel     = obj.VelocityProfileInternal(currGoalIndex, :);
            
            reset = 0;
            if helperGoalChecker(nextGoal, currPose, currVel, endRefVel, direction)
                obj.CurrentSegmentIndex = obj.CurrentSegmentIndex + 1;
                refVel = endRefVel;
                reset  = 1;
            end
            
            if obj.HasResetOutput && isSimulinkBlock(obj)
                varargout{1} = reset;
            end
            
            % Store the output
            obj.LastRefPoseOutput     = refPose;
            obj.LastRefVelocityOutput = refVel;
            obj.LastDirectionOutput   = direction;
            obj.LastCurvatureOutput   = curvature;
        end
        
        %------------------------------------------------------------------
        function [refPose, refVel, direction, curvature] = findDesiredPoseAndVelocity(obj, pose)
            %findDesiredPoseAndVelocity Determine the desired pose and
            %   velocity based on the current pose. The desired pose is
            %   determined by searching the closest point on the reference
            %   path. The desired velocity is the velocity corresponding to
            %   the closest point.
            
            % Get the current segment indexes
            segStartIndex = obj.SegmentStartIndex(obj.CurrentSegmentIndex);
            segEndIndex   = obj.SegmentEndIndex(obj.CurrentSegmentIndex);
            
            pose(3) = deg2rad(pose(3));
            
            % Only search within the current segment of the path
            segRefPoses    = obj.RefPosesInternal(segStartIndex:segEndIndex, :);
            segRefPoses(:, 3) = deg2rad(segRefPoses(:, 3));
 
            % Current driving direction
            direction  = obj.DirectionsInternal(segEndIndex);
            
            % Compute the index of the closest point on the path segment
            segClosestPointIndex = findClosestPathPoint(obj, pose, segRefPoses);
            
            % Convert the segment index to the whole path index
            obj.ClosestPointIndex = segClosestPointIndex + segStartIndex - 1;
            
            % Get the desired velocity. Set a lower threshold to avoid zero 
            % reference velocity at the very beginning.
            lowSpeed = 0.1;
            if segClosestPointIndex == 1
                refVel= max(abs(obj.VelocityProfileInternal(obj.ClosestPointIndex)), lowSpeed)*direction;
            else
                refVel= obj.VelocityProfileInternal(obj.ClosestPointIndex);
            end
            
            % Get the desired pose. In forward motion, the refPose is
            % specified for the front wheel.
            if direction == 1 % forward
                refPose = driving.internal.control.rearPoseToFrontPose(segRefPoses(segClosestPointIndex, 1:3), obj.Wheelbase);
            else
                refPose = segRefPoses(segClosestPointIndex, 1:3);
            end
            
            % Workaround to support lateralControllerStanley in MATLAB
            % that does not require curvature input
            if ~isempty(obj.CurvaturesInternal)
                curvature = obj.CurvaturesInternal(obj.ClosestPointIndex);
            else
                curvature = 0; 
            end
            
            refPose(3) = rad2deg(refPose(3));
        end
        
        %------------------------------------------------------------------
        function closestIdx = findClosestPathPoint(obj, pose, refPoses)
            %findClosestPathPoint Find the index of the closest point
            
            segStartIndex = obj.SegmentStartIndex(obj.CurrentSegmentIndex);
            
            if obj.DirectionsInternal(segStartIndex) == 1 % forward driving uses front wheel as reference
                pose     = driving.internal.control.rearPoseToFrontPose(pose, obj.Wheelbase);
                refPoses = driving.internal.control.rearPoseToFrontPose(refPoses, obj.Wheelbase);
            end
            
            dis2PointsSquare  = (refPoses(:,1)- pose(1)).^2 + (refPoses(:,2)- pose(2)).^2;
            
            % Find the closest point on the reference path
            [closestIdx, ~] = find(dis2PointsSquare == min(dis2PointsSquare), 1);
            
            % Enforce to be a scalar in Simulink
            closestIdx = closestIdx(1);
            
            % If the reference pose is lagging behind the current pose,
            % move to the next reference path.
            if obj.moveToNext(refPoses(closestIdx, :), pose) && closestIdx~= size(refPoses, 1)
                closestIdx = closestIdx+1;
            end
        end
        
        %------------------------------------------------------------------
        function nextFlag = moveToNext(obj, refPose, pose)
            %moveToNext Check if the refPose is lagging behind the current
            %   pose. If yes, move to the next refPose.
            %   The is necessary when the vehicle is at accelerating stage.
            %   When the reference speed is small it takes relatively
            %   longer time to reach the desired maximum speed. When the
            %   vehicle reaches somewhere between two reference points,
            %   use the next one as the reference to set a larger
            %   reference speed.
            wheelbase = obj.Wheelbase;
            if obj.DirectionsInternal(1) == 1
                poseF    = driving.internal.control.rearPoseToFrontPose(pose, wheelbase);
                refPoseF = driving.internal.control.rearPoseToFrontPose(refPose, wheelbase);
                vec1 = [cos(refPoseF(3)), sin(refPoseF(3))];
                vec2 = [poseF(1)-refPoseF(1), poseF(2)-refPoseF(2)];
            else
                vec1 = [cos(refPose(3)), sin(refPose(3))];
                vec2 = [pose(1)-refPose(1), pose(2)-refPose(2)];
            end
            nextFlag = (vec1*vec2'*obj.DirectionsInternal(1) > 0);
        end
    end
    
    %----------------------------------------------------------------------
    % Common methods
    %----------------------------------------------------------------------
    methods(Access = protected)
        %------------------------------------------------------------------
        function validateInputsImpl(obj, currPose, currVelocity, varargin)
            % Validate inputs to the step method at initialization
            matlabshared.planning.internal.validation.checkPose(currPose, 3, 'currPose', mfilename);
            
            validateattributes(currVelocity, {'double', 'single'}, {'nonnan', ...
                'real', 'finite', 'scalar', 'nonempty'}, mfilename, 'currVelocity');
            
            if obj.HasReferenceInports && isSimulinkBlock(obj)
                % RefPoses
                validateattributes(varargin{1}, {'single', 'double'}, ...
                    {'nonnan', 'real', 'ncols', 3, 'finite', 'nonempty'}, ...
                    mfilename, 'refPoses');
                % Directions
                validateattributes(varargin{2}, {'single', 'double'}, ...
                    {'nonnan', 'real', 'column', 'finite', 'nonempty'}, ...
                    mfilename, 'directions');
                % Curvatures
                validateattributes(varargin{3}, {'single', 'double'}, ...
                    {'nonnan', 'real', 'column', 'finite', 'nonempty'}, ...
                    mfilename, 'curvatures');
                % VelocityProfile
                validateattributes(varargin{4}, {'single', 'double'}, ...
                    {'nonnan', 'real', 'column', 'finite', 'nonempty'}, ...
                    mfilename, 'VelocityProfile');
            end
        end
        
        %------------------------------------------------------------------
        function num = getNumInputsImpl(obj)
            % Define total number of inputs for system with optional inputs
            if isSimulinkBlock(obj)
                num = 6;
            else
                num = 2;
            end
        end
        
        %------------------------------------------------------------------
        function num = getNumOutputsImpl(obj)
            % Define total number of outputs for system with optional
            % outputs
            if ~obj.HasResetOutput
                num = 4;
            else
                num = 5;
            end
        end
        
        %------------------------------------------------------------------
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj
            
            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);
            
            % Set private and protected properties
            s.RefPoses              = obj.RefPoses;
            s.VelocityProfile          = obj.VelocityProfile;
            s.Directions            = obj.Directions;
            s.ClosestPointIndex     = obj.ClosestPointIndex;
            s.NumPathSegments       = obj.NumPathSegments;
            s.CurrentSegmentIndex   = obj.CurrentSegmentIndex;
            s.SegmentStartIndex     = obj.SegmentStartIndex;
            s.SegmentEndIndex       = obj.SegmentEndIndex;
            s.RefPosesInternal      = obj.RefPosesInternal;
            s.DirectionsInternal    = obj.DirectionsInternal;
            s.CurvaturesInternal    = obj.CurvaturesInternal;
            s.VelocityProfileInternal  = obj.VelocityProfileInternal;
            s.LastRefPoseOutput     = obj.LastRefPoseOutput;
            s.LastRefVelocityOutput = obj.LastRefVelocityOutput;
            s.LastDirectionOutput   = obj.LastDirectionOutput;
        end
        
        %------------------------------------------------------------------
        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s
            
            % Set private and protected properties
            obj.RefPoses              = s.RefPoses;
            obj.VelocityProfile          = s.VelocityProfile;
            obj.Directions            = s.Directions;
            obj.ClosestPointIndex     = s.ClosestPointIndex;
            obj.NumPathSegments       = s.NumPathSegments;
            obj.CurrentSegmentIndex   = s.CurrentSegmentIndex;
            obj.SegmentStartIndex     = s.SegmentStartIndex;
            obj.SegmentEndIndex       = s.SegmentEndIndex;
            obj.RefPosesInternal      = s.RefPosesInternal;
            obj.DirectionsInternal    = s.DirectionsInternal;
            obj.CurvaturesInternal    = s.CurvaturesInternal;
            obj.VelocityProfileInternal  = s.VelocityProfileInternal;
            obj.LastRefPoseOutput     = s.LastRefPoseOutput;
            obj.LastRefVelocityOutput = s.LastRefVelocityOutput;
            obj.LastDirectionOutput   = s.LastDirectionOutput;
            
            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
    end
    
    %----------------------------------------------------------------------
    % Simulink-only methods
    %----------------------------------------------------------------------
    methods(Access = protected)
        %------------------------------------------------------------------
        function icon = getIconImpl(~)
            % Define icon for System block
            icon = ["Helper", "Path", "Analyzer"]; % Use class name
        end
        
        %------------------------------------------------------------------
        function [name1,name2,name3,name4,name5,name6] = getInputNamesImpl(obj)
            % Return input port names for System block
            name1 = 'CurrPose';
            name2 = 'CurrVelocity';
            name3 = 'RefPoses';
            name4 = 'Directions';
            name5 = 'Curvatures';
            name6 = 'RefVelocities';
        end
        
        %------------------------------------------------------------------
        function varargout = getOutputNamesImpl(obj)
            % Return output port names for System block
            varargout{1} = 'RefPose';
            varargout{2} = 'RefVelocity';
            varargout{3} = 'Direction';
            varargout{4} = 'Curvature';
            if obj.HasResetOutput
                varargout{5} = 'Reset';
            end
        end
        
        %------------------------------------------------------------------
        function varargout = getOutputSizeImpl(obj)
            % Return size for each output port
            varargout{1} = [1 3]; % RefPose
            varargout{2} = [1 1]; % RefVelocity
            varargout{3} = [1 1]; % Direction
            varargout{4} = [1 1]; % Curvature
            if obj.HasResetOutput
                varargout{5} = [1 1]; % Reset
            end
        end
        
        %------------------------------------------------------------------
        function varargout = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            varargout{1} = propagatedInputDataType(obj,1);
            varargout{2} = propagatedInputDataType(obj,1);
            varargout{3} = propagatedInputDataType(obj,1);
            varargout{4} = propagatedInputDataType(obj,1);
            if obj.HasResetOutput
                varargout{5} = propagatedInputDataType(obj,1);
            end
        end
        
        %------------------------------------------------------------------
        function varargout = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            varargout{1} = false;
            varargout{2} = false;
            varargout{3} = false;
            varargout{4} = false;
            if obj.HasResetOutput
                varargout{5} = false;
            end
        end
        
        %------------------------------------------------------------------
        function varargout = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            varargout{1} = true;
            varargout{2} = true;
            varargout{3} = true;
            varargout{4} = true;
            if obj.HasResetOutput
                varargout{5} = true;
            end
        end
        
        %------------------------------------------------------------------
        function flag = isInputSizeMutableImpl(~,index)
            % Return false if input size cannot change
            % between calls to the System object
            
            % refPoses, directions, curvatures, and speeProfile are variable-size
            if any(index == [3,4,5,6])
                flag = true;
            else
                flag = false;
            end
        end
        
        %------------------------------------------------------------------
        function flag = isInactivePropertyImpl(obj,prop)
            % Return false if property is visible based on object
            % configuration, for the command line and System block dialog
            if strcmp(prop, 'HasResetOutput')
                flag = ~isSimulinkBlock(obj);
            else
                flag = false;
            end
        end
    end
    
    %----------------------------------------------------------------------
    % Simulink dialog
    %----------------------------------------------------------------------
    methods(Access = protected, Static)
        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(...
                'Title', 'Parameters', ...
                'PropertyList', {'Wheelbase', 'HasResetOutput'});
        end
    end
    
    %----------------------------------------------------------------------
    % Utility functions
    %----------------------------------------------------------------------
    methods (Access = protected)
        %------------------------------------------------------------------
        function flag = isSimulinkBlock(obj)
            %isSimulinkBlock Check if the system object in used in Simulink
            flag = getExecPlatformIndex(obj); % 0 for MATLAB, 1 for Simulink
        end
        
        %------------------------------------------------------------------
        function findSegmentBoundaryPointIndex(obj)
            %findSegmentBoundaryPointIndex Divide the path to segments 
            %based on driving direction
            directions = obj.DirectionsInternal;
            % Find the switching points
            switchIndex = find(directions(1:end-1)+directions(2:end)==0);
            % Divide the path into segments
            obj.SegmentStartIndex = [1; switchIndex+1];
            obj.SegmentEndIndex   = [switchIndex; length(directions)];
            obj.NumPathSegments   = numel(obj.SegmentStartIndex);
        end
    end
end