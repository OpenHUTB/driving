classdef DiscreteHighwayEnvironment < rl.env.MATLABEnvironment
    %HIGHWAYENVIRONMENT: Template for defining custom environment in MATLAB
    % using Deep Traffic Lab
    
    %% Properties (set properties' attributes accordingly)
    properties               
        % Sample time
        Ts = 0.1
        % Episode Maximum Run Time
        StopTime = 0.01*2000
        % Visualization Parameters
        SumoVisualization = true 
        DSDVisialization = true
        % Egovehicle Name
        EgoID = 'ego01'
        % Reward Gains
        CollisionReward = -1      % The reward received when colliding with a vehicle.
        RightLaneReward = 0.1      % The reward received when driving on the right-most lanes, linearly mapped to
                                   % zero for other lanes.
        HighSpeedReward = 0.4      % The reward received when driving at full speed, linearly mapped to zero for
                                   % lower speeds according to config["reward_speed_range"].
        RewardSpeedRange = [10, 40];
        %Number of Lanes Available
        NumLanes = 4;
    end
    
    properties (SetAccess = protected, GetAccess = public)
        % Vehicle Scenario
        Scenario
        % Number of traffic vehicles created
        NumTrafficActors = 0;
    end
    
    properties
        % Initialize system state [x, y, dx, dy, theta]'
        States = [0 0 0 0 0]'; 
        % MetaValues
        HasCollided = false;
        CurrentLane = [];
        %Previous States
        PreviousLane = [];
    end
    
    properties(Access = protected)
        % Initialize internal flag to indicate episode termination
        IsDone = false   
        % traffic environment class 
        TrafficEnv
        % Ego Vehicle List Holder
        Ego = [];
    end
    
    properties(Access = private)
        HasPlot = false;
    end

    %% Necessary Methods
    methods              
        % Contructor method creates an instance of the environment
        % Change class name and constructor name accordingly
        % In this constructor method, the driving Scenario defined as part
        % of the environment files is parsed as Scenario. Additionally, the
        % configuration files (SumoConfigFile, EgoConfigFile,
        % TrafficConfigfile) should be parsed as well to initialize the
        % SUMO connection and define traffic actors accordingly.
        % Additionally, in order to properly visualize the environment, a
        % variable containing a visualization command should be parsed in
        % here instead of using a separate method.
      
        function this = DiscreteHighwayEnvironment(Scenario, SumoConfigfile, ...
            EgoConfigFile, TrafficConfigFile, visualization)
            arguments
                Scenario
                SumoConfigfile (1,:) char
                EgoConfigFile (1,:) char
                TrafficConfigFile (1,:) char
                visualization (1,1) logical = false;
            end
            % Initialize Observation settings (For more information refer
            % to
            % (https://www.mathworks.com/help/reinforcement-learning/ref/rl.util.rlnumericspec.html)
            % or
            % (https://www.mathworks.com/help/reinforcement-learning/ref/rl.util.rlfinitesetspec.html)
            ObservationInfo(1) = rlNumericSpec([100,100,1],'LowerLimit',0,'UpperLimit',1);
            ObservationInfo(1).Name = 'OccupancyGrid';
            ObservationInfo(1).Description = 'x*y occupancy grid matrix';
            ObservationInfo(2) = rlNumericSpec([5 1]);
            ObservationInfo(2).Name = 'VehicleStates';
            ObservationInfo(2).Description = 'x, y, dx, dy, theta';
            ObservationInfo(3) = rlNumericSpec([1 1]);
            ObservationInfo(3).Name = 'CurrentLane';
            ObservationInfo(3).Description = 'Vehicle Current Lane';
            % Initialize Action settings   
            ActionInfo = rlFiniteSetSpec(1:5);
            ActionInfo.Name = 'VehicleDiscreteMetaAction';
            % The following line implements built-in functions of RL env
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
            % Initialize scenario
            this.Scenario = Scenario;
            % Initialize traffic environmenttraci.
            this.TrafficEnv = TrafficEnvironment(Scenario, ...
                SumoConfigfile, ...
                EgoConfigFile,...
                TrafficConfigFile,...
                this.StopTime,...
                'SampleTime', this.Ts,...
                'SumoVisualization', this.SumoVisualization,...
                'LaneChangeType','Resolution');
            % Propagate option for visualization
            this.DSDVisialization = visualization;
        end
        
        % Apply system dynamics and simulates the environment with the 
        % given action for one step.
        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)
            LoggedSignals = [];
            
            % Get action
            command = this.getAction(Action);         
            
            % Command Action on ego
            this.Ego.step(command);
            % Perform simulation update
            simulationHasStopped = ~this.TrafficEnv.step;
            
            % Check if ego has collided
            collisionContainer = this.TrafficEnv.check_ego_collisions;
            this.HasCollided = collisionContainer(this.EgoID);
            hasCollided = this.HasCollided;
            % Check if ego has arrived
            hasArrived = this.Ego.HasArrived;
            % Check terminal condition
            IsDone = simulationHasStopped || hasCollided || hasArrived;
                  
            % Update system states
            this.States = this.Ego.states;
            this.PreviousLane = this.CurrentLane;
            this.CurrentLane = this.Ego.CurrentLane;
            % Update Observations
            % Create Initial Observations 
            occupancyGrid = double(this.Ego.EgoMap.getOccupancy);
            states = this.States;   
            currentLane = this.Ego.CurrentLane;
            % If curves are too pronounced, it is better to put a
            % default currentLane due to a bug on currentLane method
            if isempty(currentLane)
                currentLane = 0;
            end
            
            % Construct observation list
            Observation = {occupancyGrid,states,currentLane};
            
            % Get reward
            Reward = getReward(this);
            if isempty(Reward)
                Reward = 0;
            end
            
            % Make sure dimensions are correct
            assert(all(size(occupancyGrid) == [100,100]),'error size mismatch occupancy grid')
            assert(all(size(states) == [5,1]),'error size mismatch states')
            assert(~isempty(currentLane),'error current lane is empty')
            assert(all(size(currentLane) == [1,1]),'error size mismatch currentLane')
            assert(all(size(IsDone) == [1,1]),'error size mismatch isDone')   
            assert(~isempty(IsDone),'error empty isDone')
            assert(all(size(Reward) == [1,1]),'error size mismatch isDone')
            assert(~isempty(Reward),'error empty Reward')
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
        end
        
        % Reset environment to initial state and output initial observation
        function InitialObservation = reset(this)
            
            % Deploy traffic and populate ego vehicle
            [hasBeenCreated, this.NumTrafficActors, egos] = ...
                this.TrafficEnv.deploy_traffic();
            
            % Check that environment has been created
            assert(hasBeenCreated,'Enviroonment could not be created, please check configurations')
            
            % Decompose Ego since there is only one ego
            this.Ego = egos{1};
            % Reset Collisions just in case
            this.HasCollided = false;
            % Propagate states
            this.States = egos{1}.states;
            this.CurrentLane = this.Ego.CurrentLane;
            this.PreviousLane = this.CurrentLane;
            % Create Initial Observations 
            InitialOccupancyGrid = double(this.Ego.EgoMap.getOccupancy);
            InitialStatesObs = this.States;
            InitialLane = this.PreviousLane;
            % construct observation list
            InitialObservation = {InitialOccupancyGrid,InitialStatesObs,InitialLane};
            
            % (optional) use notifyEnvUpdated to signal that the 
            % environment has been updated (e.g. to update visualization)
            notifyEnvUpdated(this);
            
            % If visualization option was defined, generate plots in here
            % only once
            if this.DSDVisialization && ~this.HasPlot
                this.TrafficEnv.create_chase_visualization(this.EgoID)
                % Update the visualization
                envUpdatedCallback(this)
                this.HasPlot = true;
            end
        end
    end
    %% Optional Methods (set methods' attributes accordingly)
    methods               
        % Helper methods to create the environment
        
        % Reward function
        function reward = getReward(this)
            % Determine if vehicle if on farmost right lane
            [cl,numlanes] = currentLane(this.Ego.Vehicle);
            if isempty(numlanes)
                cl = -1;
                numlanes = 0;
            end
            % Scale speed
            scaledSpeed = this.linearMap(this.States(3),...
                this.RewardSpeedRange,[0,1]);
            % Compute reward
            reward = ...
                this.CollisionReward*this.HasCollided + ...
                this.RightLaneReward*(cl==numlanes)+...
                this.HighSpeedReward*scaledSpeed;
            % Normalize reward to a value between 0 and 1
            reward = this.linearMap(reward,[this.CollisionReward, ...
                this.RightLaneReward+this.HighSpeedReward], [0,1]);
        end
        
        % (optional) Visualization method
        function plot(this)
            % Initiate the visualization
            plot(this.Scenario)

            % Update the visualization
            envUpdatedCallback(this)
        end
        
        % (optional) Properties validation through set methods
        function set.States(this,state)
            validateattributes(state,{'struct'},{});
            position = double(state.Position(:));
            velocity = double(state.Velocity(:));
            heading = double(state.Heading(:));
            this.States = [position; velocity; heading];
            notifyEnvUpdated(this);
        end
    end
    
    methods (Access = protected)
        % (optional) update visualization everytime the environment is updated 
        % (notifyEnvUpdated is called)
        function envUpdatedCallback(this)
        end
    end
    methods (Static)
        % Discrete Action integer value between 1 and 5
        function command = getAction(action)
            validateattributes(action,{'numeric'},{'scalar','>=',1,'<=',5})
            command = action;           
        end
        
        
        function value = linearMap(value, xInterval, yInterval)
            % Performs a linear map of value form XInterval to yInterval
            % -------------------------------------------------------------
            value = yInterval(1)+(value-xInterval(1))*...
                (yInterval(2)-yInterval(1))/(xInterval(2)-xInterval(1));
            if value > yInterval(2)
                value = yInterval(2);
            elseif value < yInterval(1)
                value = yInterval(1);
            end
        end
    end
end
