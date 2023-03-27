%HelperBehavioralPlanner Behavioral planner helper class.
%   This is a helper class which acts as a simplified behavioral layer in a
%   hierarchical planning workflow. Use the requestManeuver method to
%   request the next maneuver in the route plan.
%
%   NOTE: The name of this class and it's functionality may change without
%   notice in a future release, or the class itself may be removed.
%
%   behaviorPlanner = HelperBehavioralPlanner(routePlan, steerLimit) 
%   returns a behavior planner object for the environment specified by
%   vehicleCostmap object costmap, for a route plan specified by table
%   routePlan. vehicleDims is a vehicleDimensions object describing the
%   dimensions of the vehicle, and steerLimit is a scalar specifying the
%   maximum possible steering angle for the vehicle (specified in degrees).
%
%   HelperBehavioralPlanner properties: 
%   RoutePlan   - Global route plan.
%
%   HelperBehavioralPlanner methods: 
%   requestManeuver     - Request next maneuver along route plan 
%   reachedDestination  - Check if destination has been reached 
%   replanNeeded        - Command to specify that maneuver needs replanning

% Copyright 2017-2019 The MathWorks, Inc.

%#codegen

classdef HelperBehavioralPlanner < handle
    
    properties (SetAccess = protected)  
        %RoutePlan Global route plan to be executed.
        %   RoutePlan is a table with variables Start, End and Attributes,
        %   with each row representing a segment of the route plan. Start
        %   and End variables represent the starting and ending poses along
        %   the center of the segment for a particular segment. Attributes
        %   is a struct containing information about the segment -
        %   StopLine, TurnManeuver and SpeedLimit. StopLine specifies
        %   whether the segment ends with a stop line, TurnManeuver
        %   specifies whether the segment represents a turn maneuver, and
        %   SpeedLimit specifies the speed limit in meters/sec.
        RoutePlan
        
        %SteerLimit
        %   A scalar specifying maximum possible steering angle the vehicle
        %   can achieve, specified in degrees.
        SteerLimit
    end
    
    properties (Access = protected)
        %GoalIndex
        %   Index to next goal
        GoalIndex
        
        %ReplanMode
        %   Flag indicating whether behavioral planner needs to replan.
        ReplanMode = false;
    end
    
    methods
        %------------------------------------------------------------------
        function this = HelperBehavioralPlanner(routePlan, steerLimit)

            this.RoutePlan = this.validateRoutePlan(routePlan);

            validateattributes(steerLimit, {'double'}, ...
                {'scalar', '>=', 0, '<=', 90}, mfilename, 'steerLimit');
            
            this.SteerLimit        = steerLimit;
            
            reset(this);
        end
        
        %------------------------------------------------------------------
        function [nextGoal, plannerConfig, speedProfile] = requestManeuver(this, currentPose, currentSpeed)
            %requestManeuver Request next maneuver along route plan
            %   [nextGoal, plannerConfig, speedProfile] = requestManeuver(behaviorPlanner, currentPose, currentSpeed)
            %   requests the next maneuver along the route plan. The
            %   maneuver is specified as the nextGoal, a 1-by-3 vehicle
            %   pose [x,y,theta], a plannerConfig struct with planner
            %   settings, and a speedProfile struct with speed profile
            %   settings. Use the plannerConfig to configure the
            %   pathPlannerRRT object. Use the speedProfile to configure
            %   the HelperSpeedProfileGenerator.
            
            % Determine planner settings
            [nextGoal, plannerConfig] = plannerSettings(this, currentPose);
            
            % Determine speed settings
            speedProfile = speedSettings(this, currentSpeed);
            
            % Point to next goal
            this.GoalIndex = this.GoalIndex + 1;
        end
        
        %------------------------------------------------------------------
        function tf = reachedDestination(this)
            %reachedDestination Check if destination has been reached
            %   tf = reachedDestination(behaviorPlanner) returns true if
            %   the destination has been reached (last maneuver has been
            %   executed), and false otherwise.
            
            destinationIndex = length(this.RoutePlan);
            
            tf = (this.GoalIndex > destinationIndex);
        end
        
        %------------------------------------------------------------------
        function replanNeeded(this)
            %replanNeeded command to specify that maneuver needs replanning
            %   replanNeeded(behaviorPlanner) commands the behavioral
            %   planner to replan the most recently requested maneuver.
            %   This configures the planner settings to be more defensive.
            
            % Reset to previous goal
            this.GoalIndex = max(this.GoalIndex - 1, 1);
            
            % Set replan mode
            this.ReplanMode = true;
        end
    end
    
    methods (Access = protected)
        %------------------------------------------------------------------
        function reset(this)
            
            % Point to first goal in route plan
            this.GoalIndex = 1;
        end
        
        %------------------------------------------------------------------
        function [nextGoal, config] = plannerSettings(this, currentPose)
            
            % Determine next goal pose
            idx = this.GoalIndex;
            
            if idx > length(this.RoutePlan)
                error('Route plan has been executed. No more waypoints left.')
            end
            
            nextGoal = this.RoutePlan(idx).EndPose;
            
            % Set planner range, minimum iterations and tolerance
            config.ConnectionDistance = 10;
            config.MinIterations      = 1000;
            config.GoalTolerance      = [0.5, 0.5, 5];
            
            % If parking maneuver is to be executed, decrease goal
            % tolerance
            isParkManeuver = (this.GoalIndex == length(this.RoutePlan));
            if isParkManeuver
                config.GoalTolerance = [0.5 0.5 10];
                config.ConnectionDistance = 6;
            end
            
            % Reduce range of planner if current pose are close to the goal
            dist = sqrt(sum((currentPose(1:2) - nextGoal(1:2)).^2));
            closeToGoal = dist < 10;
            if closeToGoal
                config.ConnectionDistance = 6;
            end
            
            % Use a higher turning radius if the route segment is not a
            % turn maneuver
            isTurnManeuver = this.RoutePlan(idx).Attributes.TurnManeuver;
            if ~isTurnManeuver
                config.MinTurningRadius = 20;
            else
                if isParkManeuver
                    config.MinTurningRadius = 4;
                else
                    config.MinTurningRadius = 5;
                end
            end
            
            config.IsParkManeuver = isParkManeuver;
        end
        
        %------------------------------------------------------------------
        function settings = speedSettings(this, currentSpeed)
            
            settings.StartSpeed = currentSpeed;
            
            segmentAttributes = this.RoutePlan(this.GoalIndex).Attributes;

            settings.EndSpeed = segmentAttributes.EndSpeed;
            settings.MaxSpeed = segmentAttributes.MaxSpeed;

        end
    end
    
    %----------------------------------------------------------------------
    % Validation
    %----------------------------------------------------------------------
    methods (Access = protected)
        %------------------------------------------------------------------
        function routePlan = validateRoutePlan(~, routePlan)
            if coder.target('MATLAB')
                validateattributes(routePlan, {'table'}, {'ncols', 3}, ...
                    mfilename, 'routePlan');
                routePlan = table2struct(routePlan);
            else
                validateattributes(routePlan, {'struct'}, {'column'}, ...
                    mfilename, 'routePlan');
            end
        end
    end
end