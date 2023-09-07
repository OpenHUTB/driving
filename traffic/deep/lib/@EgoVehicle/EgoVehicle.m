classdef EgoVehicle < TrafficVehicle & matlab.System
    % EgoVehicle Class defines a vehicle within sumo and dsd by inheritance
    % from TrafficVehicle class. Additionally, it defines the vehicle model
    % to be used by the simulation and creates position updates on sumo
    % based on control action input and model. The available vehicle models
    % are (Kinematic Bicycle model, and default SUMO model) If Ego vehicle
    % class is initialized with a Kinematic Bicycle model, the available
    % control inputs are [speed_cmd, angle_cmd] ot [acc_cmd, ang_rate_cmd].
    % If default sumo model is selected, the available actions are
    % discrete-meta-action = {'LANE_LEFT','LANE_RIGHT', 'ACCELERATE',
    % 'DECELERATE','KEEP_SPEED'}. Additionally, the acceleration increment
    % is set to 1m/s^2 and decrement to -1m/s^2.
    % discrete action = [accel_cmd, ang_rate_cmd]
    
    
    properties (GetAccess = public, SetAccess = private)
        ActionType char {mustBeText, mustBeMember(ActionType,{'Discrete-MetaAction', 'Discrete', 'Continuous'})} = 'Discrete-MetaAction'
        ModelType char {mustBeText, mustBeMember(ModelType,{'Bicycle', 'SUMO'})} = 'SUMO'
        %SensorsList cell % Sensors placed on Vehicle. Must be cell type and can include {'radar','camera','lidar','ideal','grid','selfState')
        TargetPoses = []; % Target vehicles in default range of 250 m around ego vehicle
        Leader = [];
        TimeToCollisionLeader = []; % Time To COllision with leader
        % Physical Characteristics
        MaxSpeed (1,1) double {mustBeReal, mustBeFinite} = 40;
        MinSpeed (1,1) double {mustBeReal, mustBeFinite} = 0;
        MaxSteeringAnge = 0.52359878; %rad Maximum Vehicle Steering Angle (
        %Time Parameters
        SampleTime (1,1) = 0.1;
        % Lookaround distance
        LookAroundDistance = 250;
        % Vision Sensors
        VisionDets = struct('ActorDets',[],'LaneDets',[]);
        % Lidar Detections
        LidarDets = struct('PointCloud',[],'IsValidTime',[],'Clusters',[]);
        %Radar Detections
        RadarsDets = struct('Detections',[],'NumberDetections',[],'IsValidTime',[]);
        % Ego Map (Binary Occupancy Grid)
        EgoMap = [];
    end
    properties(Access = public)
        % Collision
        HasCollided logical {mustBeNumericOrLogical} = false;
    end
    properties (Access = private)
        % Sensors Related Variables
        HasLidar = false;
        HasGrid = false;
        HasCamera = false;
        HasRadar = false;
        GenerateGridPlot (1,1) logical {mustBeNumericOrLogical} = false;
        GenerateGridLaneDetection (1,1) logical {mustBeNumericOrLogical} = false;
        % \\Control related variables
        HasDisabledSafetyChecks = false;
        % - meta-action vars
        MetaActions = {...
            'LANE_LEFT', ...
            'LANE_RIGHT', ...
            'ACCELERATE', ...
            'DECELERATE',...
            'KEEP_SPEED'}
        AccelIncrement = 1; %m/s^2
        % continuos
        PreviousLane = 0;
    end
    properties (GetAccess = public, SetAccess = protected)
        % Metadata
        CurrentLane = [];
        Model = [];
        % Spawn Options
        SpawnOptions = struct(...
            route = 'random', ...
            departLane = 'random', ...
            departPos = 'random_free', ...
            departSpeed = 'random', ...
            arrivalLane = 'random', ...
            arrivalPos  = 'max', ...
            arrivalSpeed = 'random');
    end
    properties (GetAccess = protected, SetAccess = protected)
        firstSync  = true;
        VisionSensors = {};
        LidarSensors = {};
        RadarSensors = {};
        GridPlotAxis = [];
        
    end
    
    methods
        function obj = EgoVehicle(vehicleID, Scenario, typeOptions, spawnOptions)
            % EgoVehicle(vehicleID, Scenario, typeOptions, spawnOptions)
            %
            % -------------------------------------------------------------
            arguments
                vehicleID
                Scenario
                % Type Options
                typeOptions.TypeID  = 'DEFAULT_VEHTYPE'
                typeOptions.Color (1,3) double {mustBeNumeric} = [1 1 0] % Ego Vehicle Color (Default is yellow)
                typeOptions.ActionType char {mustBeText, mustBeMember(typeOptions.ActionType,{'Discrete-MetaAction', 'Discrete', 'Continuous'})} = 'Discrete-MetaAction'
                typeOptions.ModelType char {mustBeText, mustBeMember(typeOptions.ModelType,{'Bicycle', 'SUMO'})} = 'SUMO';
                % Spawn Options
                spawnOptions.route = 'random'
                spawnOptions.departLane = 'random'
                spawnOptions.departPos = 'random_free'
                spawnOptions.departSpeed = 'random'
                spawnOptions.arrivalLane = 'random'
                spawnOptions.arrivalPos  = 'max'
                spawnOptions.arrivalSpeed = 'random'
            end
            % Initialize traffic vehicle actor
            obj = obj@TrafficVehicle(vehicleID,Scenario,TypeID = typeOptions.TypeID, Color = typeOptions.Color);
            % Initialize vehicle model descriptor
            % make sure that model and action type pairs are consistent
            % with available support
            if strcmp( typeOptions.ModelType, 'SUMO') && ...
                    ~ismember(typeOptions.ActionType,{'Discrete-MetaAction', 'Discrete'})
                error("'SUMO' Model type supports only 'Discrete-MetaAction' and 'Discrete' ActionType")
            elseif strcmp( typeOptions.ModelType, 'Bicycle') && ...
                    ~ismember(typeOptions.ActionType,{'Continuous', 'Discrete'})
                error("'Bicycle' Model type supports only 'Continuous' and 'Discrete' ActionType")
            end
            % Propagate initialization
            obj.ActionType = typeOptions.ActionType;
            obj.ModelType = typeOptions.ModelType;
            % change ego status from super class
            obj.IsEgo = true;
            if strcmp(obj.ModelType, 'Bicycle')
                obj.IsEgoControlled = true;
            end
            % Propagate Spawn Options
            obj.SpawnOptions = spawnOptions;
            % Compute time parameters
            obj.SampleTime = obj.Scenario.SampleTime;
        end % constructor
        
        %% Spawn/Despawn Options
        function spawnedVehicle = spawn_vehicle(obj)
            % adds a vehicle to simulation by inserting the vehicle on SUMO
            % simulation, and then insertinv vehicle to driving scenario.
            % -------------------------------------------------------------
            % Gather route options
            routeList = traci.route.getIDList;
            % Check if Route is Random
            if strcmp(obj.SpawnOptions.route,'random')
                % Gather route options
                actorRoute = routeList{randi(length(routeList),1,1)};
            else
                actorRoute = obj.SpawnOptions.route;
            end
            % Validate actor route
            assert(ismember(actorRoute,routeList),'Invalid Route for Ego')
            % Copy struct
            spawnOptions = obj.SpawnOptions;
            % Remove route field
            spawnOptions = rmfield(spawnOptions,'route');
            % Convert structure to name=value paris
            spawnArgs = namedargs2cell(spawnOptions);
            % Spawn Vehicle
            spawnedVehicle = spawn_vehicle@TrafficVehicle...
                (obj, actorRoute, spawnArgs{:});
        end
        function hasDespawned = despawn_actor(obj)
            % destroy_actor() despawns vehicle from SUMO simulation and
            % from DSD. For DSD, takes vehicle's exit time and sets it to
            % current time
            % -------------------------------------------------------------
            % Run superclass method
            hasDespawned = despawn_actor@TrafficVehicle(obj);
            % update first run to true
            if hasDespawned
                obj.firstSync = true;
            end
            % Reset Observations
            obj.TargetPoses = []; % Target vehicles in default range of 250 m around ego vehicle
            obj.Leader = [];
            obj.TimeToCollisionLeader = []; % Time To COllision with leader
            if obj.HasCamera
                obj.VisionDets = struct('ActorDets',{},...
                    'LaneDets',{});
            end
            if obj.HasLidar
                obj.LidarDets = struct('PointCloud',[],...
                    'IsValidTime',[],'Clusters',[]);
            end
            if obj.HasRadar
                obj.RadarsDets = struct('Detections',[],...
                    'NumberDetections',[],'IsValidTime',[]);
            end
            if obj.HasGrid
                setOccupancy(obj.EgoMap, zeros(obj.EgoMap.GridSize));
            end
            obj.EgoMap
        end % despawn_actor
        
        %% Ego Utils
        function isEgoSpawned = check_on_ego(obj)
            % Checks that ego is on DSD and SUMO simulation. Should be used
            % as a sanity check for possible dispawn of vehicle on SUMO sim
            % -------------------------------------------------------------
            try
                isOnSumo = ismember(objVehID,traci.vehicle.getIDList);
            catch err
                warning("could not check on %s because of error:",obj.VehID,err.message)
                isEgoSpawned = false;
                return
            end
            isOnDSD = obj.check_if_exists_on_dsd();
            isEgoSpawned =  isOnSumo && isOnDSD;
        end %check on ego
        
        function isRunning = synchronize(obj, sumoVehicleList)
            % synchronizes states between SUMO and DSD for vehicle.
            % sumoVehicleList is a cell list that contains the names of the
            % vehicles that have been spawned in SUMO
            % The following actions are performed:
            % * The state of the vehicle is modified to match its state at the
            % current time step. This includes states specified by sumo, and states
            % explicitly defined by DSD, e.g. "position".
            % * If vehicle exit the network, its exitTime on DSD is
            % updated to be the curent time. check if vehicle has been
            % spawned on sumo first
            % -------------------------------------------------------------
            
            % If ego vehicle is of sumo model type, just perform
            % synchronization as original implemented
            if (strcmp(obj.ModelType,'SUMO') || obj.firstSync)
                isRunning = synchronize@TrafficVehicle(obj,sumoVehicleList);
                % update first sync
                obj.firstSync = false;
                % update observations (ideal for now)
                if ismember(obj.VehID,sumoVehicleList)
                    obj.update_observations();
                end
                return
            end
            
            % create container map for sumo check
            isOnSumo = obj.check_if_exists_on_sumo(sumoVehicleList);
            isOnDSD = obj.check_if_exists_on_dsd();
            obj.HasBeenCreated =  isOnSumo && isOnDSD;
            
            % Check if vehicle is on DSD, if it is not, return with warning
            if ~ isOnDSD
                isRunning = false;
                warning('vehicle could not be synchronized')
                return
            end
            % Check if has already been subscribed to sumo
            if isOnSumo && ~obj.HasAlreadySubscribed
                obj.HasAlreadySubscribed = obj.subscribe_to_sumo_vehicle();
            end
            % Syncronize if object has been created, has subscribed to
            % traci and it is not an ego controlled type of traffic actor
            if obj.HasBeenCreated && obj.HasAlreadySubscribed
                % update vehicle on dsd
                %obj.update_dsd_vehicle_states();
                % Update metadata states
                obj.update_metadata();
                % update vehicle current lane on DSD
                obj.CurrLaneDsd = obj.Vehicle.currentLane;
                % Syncronize states from dsd to sumo
                % transform states to sumo
                states = obj.dsd2sumo_transform();
                % update states on sumo
                isRunning = obj.update_sumo_states(states);
                % update mesh pose
                obj.update_collisionMesh_pose();
                % update observations
                if ismember(obj.VehID,sumoVehicleList)
                    obj.update_observations();
                end
            else
                % fully despawn actor from sumo and dsd
                if ismember(obj.VehID,traci.vehicle.getIDList)
                    obj.despawn_actor();
                    obj.HasAlreadySubscribed = false;
                else
                    % Otherwise, despawn actor only from dsd
                    hasDespawned = obj.reset_vehicle_dsd();
                    % Update has arrived status
                    obj.HasArrived = hasDespawned;
                    obj.HasAlreadySubscribed = false;
                end
            end %if
        end %synchronize
        
        %% Sensor Creation
        function [camera, numCameras]= create_camera_sensor(obj, varargin)
            % Create camera sensor
            %--------------------------------------------------------------
            % Compute current vision sensor index
            index = length(obj.VisionSensors)+1;
            % Populate vision sensors array with new sensors
            obj.VisionSensors{index} = visionDetectionGenerator;
            if nargin > 1
                args = cellfun(@check_arrays,varargin,'UniformOutput',false);
                setProperties(obj.VisionSensors{index},nargin-1,args{:});
            end
            obj.VisionSensors{index}.DetectorOutput = 'Lanes and objects';
            obj.HasCamera = true;
            camera = obj.VisionSensors;
            numCameras = index;
            % Make sure vectors are row vectors for compatibility
            function value = check_arrays(value)
                if ~isrow(value)
                    value = value';
                end
            end
        end % create_camera_sensor
        
        function [radar, numRadars] =  create_radar_sensor(obj, varargin)
            % Create radar sensor
            %--------------------------------------------------------------
            % Compute current radar sensor index
            index = length(obj.RadarSensors)+1;
            % Populate radar sensors with new sensor
            obj.RadarSensors{index} = drivingRadarDataGenerator;
            if nargin > 1
                args = cellfun(@check_arrays,varargin,'UniformOutput',false);
                setProperties(obj.RadarSensors{index},nargin-1,args{:});
            end
            radar = obj.RadarSensors;
            numRadars = index;
            % Update hasRadar boolean
            obj.HasRadar = true;
            % Make sure vectors are row vectors for compatibility
            function value = check_arrays(value)
                if ~isrow(value)
                    value = value';
                end
            end
        end %create_radar_sensor
        
        function [lidar, numLidars] = create_lidar_sensor(obj, varargin)
            % Create lidar sensor
            %--------------------------------------------------------------
            % Compute current vision sensor index
            index = length(obj.LidarSensors)+1;
            % Populate vision sensors array with new sensors
            obj.LidarSensors{index} = lidarPointCloudGenerator;
            if nargin > 1
                args = cellfun(@check_arrays,varargin,'UniformOutput',false);
                setProperties(obj.LidarSensors{index},nargin-1,args{:});
            end
            obj.HasLidar = true;
            lidar = obj.LidarSensors;
            numLidars = index;
            % Make sure vectors are row vectors for compatibility
            function value = check_arrays(value)
                if ~isrow(value)
                    value = value';
                end
            end
        end %create_lidar_sensor
        
        function egoMap = create_binary_grid(obj, occupancyOptions)
            % gridSensor = create_binary_grid
            % Creates a occupancy grid representation of vehicles
            % surrounding the ego vehicle. This occupancy grid is based on
            % ideal observations from surrounding vehicles in the vecinity
            % of the ego vehicles
            % Input:
            % - xSize (double) = grid size on x direction in meters
            % (optional)(default = 100m)
            % - ySize (double) = grid size on y direction in meters
            % (optional)(default = 100)
            % - resolution (double) = grid resolution of cells per meters
            % (optional)(default = 2 cells/m)
            % - plot (bool) = create a plot for visualization with ego
            %   vehicle chase plot (optional)(default = false)
            % - LaneDetection (bool) = include road boundaries as part of
            %   unnocupied space (optional) (default = true)
            % -------------------------------------------------------------
            arguments
                obj
                occupancyOptions.xSize = 100; %m
                occupancyOptions.ySize = 100; %m
                occupancyOptions.resolution = 2; %cells per meter
                occupancyOptions.plot = false;
                occupancyOptions.LaneDetection = false;
            end
            % Create Ego Map
            if ~isempty(obj.EgoMap) && obj.HasGrid
                warning('Occupancy grid sensor has already been created')
                egoMap = obj.EgoMap;
                return
            end
            obj.EgoMap = binaryOccupancyMap( occupancyOptions.xSize, ... %m
                occupancyOptions.ySize, ... %m
                occupancyOptions.resolution);%m
            % Initiate occupancy to fully occupied
            setOccupancy(obj.EgoMap,zeros(obj.EgoMap.GridSize));
            % By default, the map origin is at bottom-left. Move the egoMap
            % origin to the center of the occupancy map. This converts the
            % occupancy map to an egocentric occupancy map
            obj.EgoMap.GridOriginInLocal = [-obj.EgoMap.XLocalLimits(2)/2, ...
                -obj.EgoMap.YLocalLimits(2)/2];
            egoMap = obj.EgoMap;
            obj.HasGrid = true;
            obj.GenerateGridPlot = occupancyOptions.plot;
            obj.GenerateGridLaneDetection = occupancyOptions.LaneDetection;
        end %create_binary_grid
    end
    %% Protected Methods
    methods (Access = protected)
        %% Step methods
        function success = stepImpl(obj, action)
            % (Computation of action space)
            % -------------------------------------------------------------
            switch obj.ModelType
                case 'SUMO'
                    % Provide step action using meta action space
                    success = obj.step_sumo_meta_action(action);
                case 'Bicycle'
                    % Provide step action using discrete or continuoues
                    % action space
                    success = obj.step_dynamic_model(action);
                otherwise
                    error('Model not defined ot supported')
            end
        end % stepImpl
        
        function success = step_sumo_meta_action(obj,action)
            arguments
                obj
                action (1,1) {mustBeNumeric, mustBeNonempty}
            end
            isOnSumo = ismember(obj.VehID,traci.vehicle.getIDList);
            isOnDSD = obj.check_if_exists_on_dsd();
            obj.HasBeenCreated =  isOnSumo && isOnDSD;
            % Check if vehicle is on DSD, if it is not, return with warning
            if ~obj.HasBeenCreated
                success = false;
                warning('vehicle %s could not be controlled',obj.VehID)
                return
            end
            
            % Check if safety checks should be disabled
            if ~obj.disable_safety_checks_sumo()
                warning('vehicle %s could not disable SafetyChecks',obj.VehID)
            end
            
            
            % Extract action value to perform command
            %             MetaActions = {...
            %               1: 'LANE_LEFT', ...
            %               2: 'LANE_RIGHT', ...
            %               3: 'ACCELERATE', ...
            %               4: 'DECELERATE',...
            %               5: 'KEEP_SPEED'}
            try
                switch obj.MetaActions{action}
                    case 'LANE_LEFT' % Lane Left
                        % Get Maximum allowed lane
                        maxNumLanes = check_available_lanes(obj.VehID);
                        %  Get current lane
                        currLane = obj.CurrLane;
                        % check if maximum left lane has been reached
                        if currLane+1<=maxNumLanes
                            traci.vehicle.changeLane(obj.VehID,currLane+1,1e15);
                        end
                    case 'LANE_RIGHT' % Lane right
                        %  Get current lane
                        currLane = obj.CurrLane;
                        if currLane-1 >=0
                            traci.vehicle.changeLane(obj.VehID,currLane-1,1e15);
                        end
                    case 'ACCELERATE' % Accelerate
                        % get current Speed
                        currSpeed = sqrt(sum(obj.Velocity.^2));
                        % compute discrete speed
                        speedCmd = currSpeed + obj.AccelIncrement*obj.SampleTime;
                        % Command speed change on sumo
                        traci.vehicle.setSpeed(obj.VehID,speedCmd);
                    case 'DECELERATE' % Decelerate
                        % get current Speed
                        currSpeed = sqrt(sum(obj.Velocity.^2));
                        % compute discrete speed
                        speedCmd = currSpeed - obj.AccelIncrement*obj.SampleTime;
                        if speedCmd <0
                            speedCmd = 0;
                        end
                        traci.vehicle.setSpeed(obj.VehID,speedCmd);
                    otherwise
                        % Maintain speed
                end
                success = true;
            catch err
                warning('vehicle %s, could not perform command %s',obj.VehID, obj.MetaActions{action})
                warning(err.message)
                success = false;
            end
            
            function maxNumLanes =  check_available_lanes(VehID)
                % Check lanes available given current state
                res = traci.vehicle.getSubscriptionResults(VehID);
                currEdge = res(traci.constants.VAR_ROAD_ID);
                if ~isempty(currEdge)
                    maxNumLanes = traci.edge.getLaneNumber(currEdge);
                else
                    maxNumLanes = 1; % Don't change lane;
                end
                maxNumLanes = maxNumLanes -1;

            end
            
        end % step_sumo_meta_action
        
        function success = step_dynamic_model(obj,action)
            arguments
                obj
                action (2,1) % Action commands [cmdSpeed (m/s) cmdSteeringAngle(rad)]]
            end
            isOnSumo = ismember(obj.VehID,traci.vehicle.getIDList);
            isOnDSD = obj.check_if_exists_on_dsd();
            obj.HasBeenCreated =  isOnSumo && isOnDSD;
            % Check if vehicle is on DSD, if it is not, return with warning
            if ~obj.HasBeenCreated
                success = false;
                warning('vehicle %s could not be controlled',obj.VehID)
                return
            end
            
            % Define vehicle model
            if isempty(obj.Model)
                obj.Model = bicycleKinematics(...
                    'WheelBase',obj.Vehicle.Wheelbase, ...
                    'VehicleSpeedRange', [obj.MinSpeed,obj.MaxSpeed],...
                    'MaxSteeringAngle', obj.MaxSteeringAnge,...
                    'VehicleInputs', 'VehicleSpeedSteeringAngle');
            else
                obj.Model.WheelBase = obj.Vehicle.Wheelbase;
            end
            
            % Extract initial conditions
            % Extract Current Vehicle State
            initState = [obj.states.Position
                obj.states.Heading];
            % Applies control input to the specified model dynamics
            y_dot = derivative(obj.Model,initState,action);
            % Update current state
            y_der = initState + y_dot*obj.Scenario.SampleTime; % TODO Include current time and delta T to ego class properties
            
            tspan = [obj.Scenario.SimulationTime, ...
                obj.Scenario.SimulationTime+obj.Scenario.SampleTime];
            [~,y] = ode45(@(t,y)derivative(obj.Model,y,action),tspan,initState);
            % Extract X(tk)
            currBicycleState = y(end, :);
            % Update state Structure
            obj.update_bicycle_states(currBicycleState, y_der(1));
            % Update_dsd_vehicle_states
            success = obj.update_dsd_vehicle_states_no_sumo();
        end % step_dynamic_model
        
        %% State update for Ego
        function hasBeenUpdated = update_bicycle_states(obj, currBicycleState, speed)
            try
                % Decompose states
                obj.Position = currBicycleState(1:2);
                obj.Heading = wrapToPi(currBicycleState(3));
                obj.Velocity = [cos(obj.Heading)*speed, sin(obj.Heading)*speed]';
                %NOTE ACCELERATION UPDATE STIL MISSING
                % Update state structure
                obj.states = struct('Position',obj.Position,...
                    'Velocity',obj.Velocity,...
                    'Heading',obj.Heading,...
                    'Acceleration', obj.Acceleration);
                hasBeenUpdated = true;
            catch err
                error(err)
            end
        end % update_bicycle_states
        
        function hasBeenUpdated = update_sumo_states(obj, states)
            % Updates vehicle states computed on DSD and comands them to
            % sumo using traci. Additionally, in order to compute the
            % correct command for traci, a logic to determine current edge
            % and lane index is performed
            % -------------------------------------------------------------
            try
                % Check if safety checks should be disabled
                if ~obj.disable_safety_checks_sumo()
                    warning('vehicle %s could not disable SafetyChecks',obj.VehID)
                end
                % update vehicle metadata
                obj.update_metadata();
                % Check vehicle current lane
                currLane = obj.Vehicle.currentLane;
                prevLane = obj.CurrLaneDsd;
                if currLane < prevLane % left lane change
                    %  Get current lane
                    currLaneSumo = obj.CurrLane;
                    targetLane = currLaneSumo+1;
                    traci.vehicle.moveToXY(obj.VehID,obj.CurrEdge,targetLane,...
                        states.position(1), states.position(2),... %x y positions
                        states.angle,2); % heading, route mode
                elseif currLane > prevLane
                    %  Get current lane
                    currLaneSumo = obj.CurrLane;
                    targetLane = currLaneSumo-1;
                    traci.vehicle.moveToXY(obj.VehID,obj.CurrEdge,targetLane,...
                        states.position(1), states.position(2),... %x y positions
                        states.angle,2); % heading, route mode
                else
                    currLaneSumo = obj.CurrLane;
                    traci.vehicle.moveToXY(obj.VehID,obj.CurrEdge,currLaneSumo,...
                        states.position(1), states.position(2),... %x y positions
                        states.angle,2); % heading, route mode
                end
                % check if vehicle is on current lane
                hasBeenUpdated = true;
                
            catch err
                disp(err)
                error(err.message)
            end
        end % update_sumo_states
        
        function hasBeenUpdated = update_dsd_vehicle_states_no_sumo(obj)
            %reimplementation of update_dsd_vehicle_states for custom
            %model(no SUMO) since for sumo model, states are extracted from
            %sumo using traci.
            % -------------------------------------------------------------
            try
                % Make sure exist time is still in infiniti
                obj.Vehicle.ExitTime = inf;
                % Update states from vehicle on scenario
                obj.Vehicle.Position(1:2) = obj.states.Position';
                obj.Vehicle.Velocity(1:2) = obj.states.Velocity';
                obj.Vehicle.Yaw = wrapTo180(obj.states.Heading*180/pi);
                hasBeenUpdated = true;
            catch err
                hasBeenUpdated = false;
                disp(err)
                error(err.message)
            end
            
        end % update_dsd_vehicle_states_no_sumo
        
        function states = dsd2sumo_transform(obj)
            % transforms coordinate frame from DSD to sumo
            % -------------------------------------------------------------
            sumo_heading = wrapTo360(-obj.Vehicle.Yaw+90); %deg
            center_offset = obj.Vehicle.Length-obj.Vehicle.RearOverhang; %m
            x_sumo = obj.Vehicle.Position(1) + cos(obj.Vehicle.Yaw*pi/180)*center_offset; %m
            y_sumo = obj.Vehicle.Position(2) + sin(obj.Vehicle.Yaw*pi/180)*center_offset; %m
            
            states.position = [x_sumo, y_sumo];
            states.angle = sumo_heading; %deg
        end
        
        function hasDisabled = disable_safety_checks_sumo(obj)
            try
                if ~obj.HasDisabledSafetyChecks || ...
                        traci.vehicle.getSpeedMode(obj.VehID)~=0
                    % disable speed checks
                    traci.vehicle.setSpeedMode(obj.VehID,0);
                    % Disable lane change checks
                    traci.vehicle.setLaneChangeMode(obj.VehID,0);
                    obj.HasDisabledSafetyChecks = true;
                end
                hasDisabled = true;
            catch err
                warning(err.message)
                hasDisabled = false;
            end
        end
        
        %% Observation Updates
        function hasUpdatedObservations = update_observations(obj)
            % updates observations from ego vehicle by providing target
            % poses, time to collision, and distance to leader, and its
            % id
            %--------------------------------------------------------------
            %              try
            % Populate Leader and ideal observations
            [obj.Leader, obj.TargetPoses, obj.CurrentLane] = obj.compute_leader();
            if ~isempty(obj.Leader)
                obj.TimeToCollisionLeader = obj.Leader.TimeToCollision;
            end
            % Populate Vision Observations
            if obj.HasCamera
                obj.VisionDets = obj.update_vision();
            end
            % Populate Lidar Observations
            if obj.HasLidar
                %                     obj.LidarDets = obj.update_lidar();
            end
            % Populate Radar Observations
            if obj.HasRadar
                obj.RadarsDets = obj.update_radar();
            end
            % Update grid Observations
            if obj.HasGrid
                obj.EgoMap = obj.update_occupancy_grid();
            end
            hasUpdatedObservations = true;
            %              catch err
            %                 warning("Could not update observations. Reason: \n %s", err.message) %#ok<MEXCEP>
            %                 hasUpdatedObservations = false;
            %             end
            
        end % update observations
        
        function [Leader, TargetPoses, CurrentLane] = compute_leader(obj)
            try
                % Gather leader information
                [leaderID, ~] = traci.vehicle.getLeader(obj.VehID);
                % Actor poses relative to ego vehicle
                actorPoses = targetPoses(obj.Vehicle,obj.LookAroundDistance);
                % Add Time to Collision Parameter
                actorPoses(1).TimeToCollision = [];
                % Retrieve actors classes from scenario (world coordinates)
                if ~isempty([actorPoses.ActorID])
                    % Add TTC parameter to vehicles
                    for i=1:length(actorPoses)
                        % Extract Relative Distance
                        ttc = actorPoses(i).Position(1)/-actorPoses(i).Velocity(1);
                        if ttc < 0
                            ttc = inf;
                        end
                        actorPoses(i).TimeToCollision = ttc;
                    end
                    actorVehicles = obj.Scenario.Actors([actorPoses.ActorID]);
                    leaderIndx = find(strcmp(leaderID,[actorVehicles.Name]));
                    if isempty(leaderIndx)
                        leaderPose = [];
                    else
                        leader = actorVehicles(leaderIndx);
                        leaderInxPoses = [actorPoses.ActorID] ==leader.ActorID;
                        leaderPose = actorPoses(leaderInxPoses);
                    end
                else
                    leaderPose = [];
                end
                leaderPose.Name = leaderID;
                % Populate values
                Leader = leaderPose;
                if ~isfield(Leader,'TimeToCollision')
                    Leader.TimeToCollision = inf;
                end
                TargetPoses = actorPoses;
                CurrentLane = obj.Vehicle.currentLane;
            catch err
                warning('vehicle %s, could not retrieve observations due to error:\n %s',obj.VehID, err.message)
                Leader = [];
            end
        end %compute_leader
        
        
        %% Sensor Update
        % Vision Detection Updates
        function visionDets = update_vision(obj)
            % Updates vision sensor given the configuration provided by
            % user
            % -------------------------------------------------------------
            % Check that vision object sensor exists
            if isempty(obj.VisionSensors)
                error('vision sensor needs to be created first by calling "create_vision_sensor"')
            end
            % Extract target vehicles poses relative to ego
            tgtPoses = targetPoses(obj.Vehicle);
            % Lookahead distance (detault 60 m)
            lookaheadDistance = 0:0.5:60;
            % Compute lane boundaries
            laneBnds = laneBoundaries(obj.Vehicle, 'XDistance',...
                lookaheadDistance, 'LocationType','inner');
            % Create array structure for output
            visionDets = struct('ActorDets',{},...
                'LaneDets',{});
            % Compute Detections using sensor
            for i=1:length(obj.VisionSensors)
                [actorsDets,numValActorDets,isValidActorTime,...
                    laneDets,numValLaneDets,isValidLaneTime] = ...
                    obj.VisionSensors{i}(tgtPoses, laneBnds, ...
                    obj.Scenario.SimulationTime);
                % Create Observation structure
                % Actor detections
                visionDets(i).ActorDets.Dets = actorsDets;
                visionDets(i).ActorDets.NumValDets = numValActorDets;
                visionDets(i).ActorDets.IsValidTime = isValidActorTime;
                % Lane Boundaries Detections
                visionDets(i).LaneDets.Dets = laneDets;
                visionDets(i).LaneDets.NumValDets = numValLaneDets;
                visionDets(i).LaneDets.IsValidTime = isValidLaneTime;
            end
        end %update_vision
        
        function lidarDets = update_lidar(obj)
            % Check that vision object sensor exists
            if isempty(obj.LidarSensors)
                error('lidar sensor needs to be created first by calling "create_lidar_sensor"')
            end
            % Create actor profiles
            actorProf = actorProfiles(obj.Scenario);
            % Create target poses
            tgtPoses = targetPoses(obj.Vehicle);
            % Create road mesh
            rdmsh = roadMesh(obj.Vehicle);
            % Create lidar structure for output
            lidarDets = struct('PointCloud',{},...
                'IsValidTime',{},...
                'Clusters',{});
            for i = 1:length(obj.LidarSensors)
                % Add actor profiles and the ego vehicle actor ID from the
                % driving scenario to the System object.
                obj.LidarSensors{i}.ActorProfiles = actorProf;
                obj.LidarSensors{i}.EgoVehicleActorID = obj.Vehicle.ActorID;
                % Generate point cloud
                [ptCloud, isValidTime, clusters] = obj.LidarSensors{i}(tgtPoses,rdmsh, ...
                    obj.Scenario.SimulationTime);
                % Create Observation structure
                % Actor detections
                lidarDets(i).PointCloud = ptCloud;
                lidarDets(i).IsValidTime = isValidTime;
                lidarDets(i).Clusters = clusters;
                % Release sensor in case of despawn of actor profiles
                release(obj.LidarSensors{i})
            end
        end %update_lidar
        
        function radarDets = update_radar(obj)
            % Check that vision object sensor exists
            if isempty(obj.RadarSensors)
                error('radar sensor needs to be created first by calling "create_radar_sensor" for index')
            end
            % Create actor profiles
            actorProf = actorProfiles(obj.Scenario);
            % Create radar detections
            simTime = obj.Scenario.SimulationTime;
            targets = targetPoses(obj.Vehicle);
            radarDets = struct('Detections',{},...
                'NumberDetections',{},...
                'IsValidTime',{});
            for i = 1:length(obj.RadarSensors)
                % Add actor profiles and the ego vehicle actor ID from the
                % driving scenario to the System object.
                obj.RadarSensors{i}.Profiles = actorProf;
                % Create radar detections
                [dets,numDets,isValidTime] = obj.RadarSensors{i}(targets,simTime);
                % Create Observation structure
                % Actor detections
                radarDets(i).Detections = dets;
                radarDets(i).NumberDetections = numDets;
                radarDets(i).IsValidTime = isValidTime;
                release(obj.RadarSensors{i});
            end
        end %update_radar
        
        
        function occupancyGrid = update_occupancy_grid(obj)
            % Extract ego Pose
            egoPose = obj.Vehicle.Position;
            egoYaw = deg2rad(obj.Vehicle.Yaw);
            
            % Move grid origin to the face of the ego Vehicle
            move(obj.EgoMap, [egoPose(1), egoPose(2)]);
            
            % Reset the egoMap before updating with obstacle information
            setOccupancy(obj.EgoMap, zeros(obj.EgoMap.GridSize));
            
            % Extract data from scenario
            [obstacleInfo,obstacleID,roadBorders] = ...
                obj.extract_ideal_observations();
            
            % Filter occupancy grid data
            [obstaclePnts, freeSpace] = obj.filter_obstacles_binary_grid(...
                obstacleInfo,obstacleID,roadBorders);
            % Set the occupancy of free space to 0
            if ~isempty(freeSpace)
                setOccupancy(obj.EgoMap, freeSpace, 1);
            end
            % Set the occupancy of occupied space to 1
            if ~isempty(obstaclePnts)
                setOccupancy(obj.EgoMap, obstaclePnts, 1);
            end
            occupancyGrid = obj.EgoMap;
            if obj.GenerateGridPlot
                % check if axis has been generated already
                if isempty(obj.GridPlotAxis)
                    % Create a handle for figure function
                    hFigure = figure('units', 'normalized',...
                        'Name',obj.VehID,'outerposition', [0 0 1 1]);
                    
                    % Create sub-panel1 to show Ego Centric Occupancy Map
                    hPanel1 = uipanel(hFigure, 'Units', 'Normalized', 'Position',...
                        [1/2 0 1/2 1], 'Title', ...
                        ['EgoCentricOccupancyMap','_',obj.VehID]);
                    
                    % Create sub-panel2 to show Driving Scenario
                    hPanel2 = uipanel(hFigure, 'Units', 'Normalized', 'Position',...
                        [0 0 1/2 1], 'Title', 'DrivingScenario');
                    
                    % Create a graphics handle for Panel2
                    hAxes1 = axes('Parent', hPanel2);
                    
                    % Create a graphics handle for Panel1
                    obj.GridPlotAxis = axes('Parent', hPanel1);
                    
                    % Ploting the driving scenario in Panel1
                    chasePlot(obj.Vehicle, 'Parent', hAxes1, 'Meshes','on');
                    
                    % Update grid Visualization
                    obj.update_grid_visualization(obj.GridPlotAxis,...
                        obj.Vehicle, egoPose, egoYaw, obj.EgoMap);
                else
                    % Update grid Visualization
                    obj.update_grid_visualization(obj.GridPlotAxis,...
                        obj.Vehicle, egoPose, egoYaw, obj.EgoMap);
                end
            end
        end %update_occupancy_grid(obj)
        
        
        
        function [obstacleInfo, obstaclesID, roadBorders] = extract_ideal_observations(obj)
            % Extracts ideal observations from scenario and creates an
            % array with obstacle poses and road borders
            % -------------------------------------------------------------
            % Initialize vectors for obstacle processing
            roadBorders = [];           
            % Extract surrounding vehicles targetPoses
            radius = sqrt(2*(max([abs(obj.EgoMap.XLocalLimits),...
                abs(obj.EgoMap.YLocalLimits)])^2));
            targetVehiclesPosesEgoCoords = targetPoses(obj.Vehicle, radius);
            % Convert target poses to world coordinates
            targetVehiclePosesScenarioCoords = ...
                driving.scenario.targetsToScenario(...
                targetVehiclesPosesEgoCoords, obj.Vehicle);
            % Populate obstacle information
            obstacleInfo = zeros(length(targetVehiclePosesScenarioCoords),4);
            obstaclesID = zeros(length(targetVehiclePosesScenarioCoords),1);
            for i=1:length(targetVehiclePosesScenarioCoords)
                obstacleInfo(i,:) = ...
                    [targetVehiclePosesScenarioCoords(i).Position,1];
                obstaclesID(i) = targetVehiclePosesScenarioCoords(i).ActorID;
            end
            % Populate road boundary information
            rbs = roadBoundaries(obj.Scenario);
            if obj.GenerateGridLaneDetection
                for index =1:length(rbs)
                    boundary = rbs{index};
                    roadBorders = cat(1,roadBorders, boundary(:, [1, 2]));
                end
            end
        end % extract_ideal_observations(obj)
        
        function [obstaclePnts, unoccupiedSpace] = filter_obstacles_binary_grid...
                (obj, obstacleInfo,obstacleID,laneBorders)
            % Processes obstale informations and obtains free spaces based
            % on grid map.
            % -------------------------------------------------------------
            % make sure that obstacleinfo and id are same size
            assert(size(obstacleInfo,1)==size(obstacleID,1), ...
                'Size mistmatch on vehicle info and vehicle id arrays')
            % Initializing the output arrays as empty
            obstaclePnts = [];
            obstacleData = [];
            unoccupiedSpace = [];
            % If there are obstacles detected, then check for obstacle
            % points which are falling inside the ego centric occupancy map
            % from the vehicle location
            if ~isempty(obstacleInfo)
                % if obstacle has valid detections
                for j=1:size(obstacleInfo,1)
                    % obstacleInfo will have only one point for each
                    % detected vehicle and it is needed to construct
                    % vehicle polygon using the vehicle center info.
                    vehicleCntr = [obstacleInfo(j, 1), obstacleInfo(j, 2)];
                    obstaclePolygon = repmat(vehicleCntr, 4, 1)' + ...
                        obj.vehiclePolygonFun(obj.Scenario.Actors(obstacleID(j)));
                    obstacleData = cat(1, obstacleData, [obstaclePolygon, ...
                        obstaclePolygon(:, 1),[NaN; NaN]]);
                end % for
                if(~isempty(obstacleData))
                    % Find bounds of egoMap
                    xGrid = linspace(obj.EgoMap.XWorldLimits(1),...
                        obj.EgoMap.XWorldLimits(2), ...
                        obj.EgoMap.GridSize(1));
                    yGrid = linspace(obj.EgoMap.YWorldLimits(1),...
                        obj.EgoMap.YWorldLimits(2), ...
                        obj.EgoMap.GridSize(2));
                    [xPoints , yPoints] = meshgrid(xGrid,yGrid);
                    % Filter the detections which are fall inside the
                    % egoMap bounds which are calculated in above step
                    xPoints = xPoints(:);
                    yPoints = yPoints(:);
                    [inPol, onPol] = inpoly2([xPoints,yPoints],...
                        [reshape(obstacleData(1:2:end, :).',1,[])', ...
                        reshape(obstacleData(2:2:end, :).',1,[])']);
                    % Populate obstacle points
                    obstaclePnts = [obstaclePnts; ...
                        xPoints(inPol), yPoints(inPol); ...
                        xPoints(onPol), yPoints(onPol)];
                    % Filter points
                    obstaclePnts = obstaclePnts(...
                        obstaclePnts(:, 1) < obj.EgoMap.XWorldLimits(2)  & ...
                        obstaclePnts(:, 1) > obj.EgoMap.XWorldLimits(1) & ...
                        obstaclePnts(:, 2) < obj.EgoMap.YWorldLimits(2)  & ...
                        obstaclePnts(:, 2) > obj.EgoMap.YWorldLimits(1), :);
                end %if isempty(obstacleData)
                
            end % If ~isempty(obstacleInfo)
            
            % Find road boundaries that fall inside egomap
            if ~isempty(laneBorders) && obj.GenerateGridLaneDetection
                % Find bounds of egoMap
                xGrid = linspace(obj.EgoMap.XWorldLimits(1),...
                    obj.EgoMap.XWorldLimits(2), ...
                    obj.EgoMap.GridSize(1));
                yGrid = linspace(obj.EgoMap.YWorldLimits(1),...
                    obj.EgoMap.YWorldLimits(2), ...
                    obj.EgoMap.GridSize(2));
                [xPoints , yPoints] = meshgrid(xGrid,yGrid);
                xPointsLane = xPoints(:)';
                yPointsLane = yPoints(:)';
                % Using inpolygon function will get the points inside road
                % boundaries
                % This will form the road region
                % Find unoccupied space using egoMap bounds
                % new poly2
                inLane = inpoly2([xPointsLane', yPointsLane'],laneBorders);
                % Find unoccupied space using egoMap bounds
                unoccupiedSpace = [xPointsLane(~inLane')',...
                    yPointsLane(~inLane')'];          
                unoccupiedSpace = unoccupiedSpace(...
                    unoccupiedSpace(:, 1) < obj.EgoMap.XWorldLimits(2) & ...
                    unoccupiedSpace(:, 1) > obj.EgoMap.XWorldLimits(1) & ...
                    unoccupiedSpace(:, 2) < obj.EgoMap.YWorldLimits(2) & ...
                    unoccupiedSpace(:, 2) > obj.EgoMap.YWorldLimits(1), :);
            end % if ~isempty(laneBorders)
        end % filter_obstacles_binary_grid
        
    end % private Methods
    % Setters and Getters
    methods
        % Vehicle
        function set.HasCollided(obj, value)
            obj.HasCollided = value;
        end
 
    end
    methods(Access = protected, Static)
        function update_grid_visualization(axis, egoVehicle, egoPose, ...
                egoYaw, egoMap)
            % Updates grid visualization of occupancy grid
            % -------------------------------------------------------------
            
            % Show the updated ego centric occupancy map
            show(egoMap, 'Parent', axis);
            
            % hold the shown output until placing the ego vehicle on to
            % the map
            hold on;
            
            % Create a variable to hold vehicle polygon dimensions
            vehiclePolygon = [egoVehicle.Length, egoVehicle.Width/2; ...
                egoVehicle.Length, -egoVehicle.Width/2; ...
                0, -egoVehicle.Width/2; ...
                0, egoVehicle.Width/2]';
            
            % Create a variable to hold current vehicle center point
            vehicleCenter = [egoPose(1), egoPose(2)];
            
            % Replicate current vehicle center values to the size equals to
            % vehiclePolygon
            pointPose = repmat(vehicleCenter, 4, 1)';
            
            % Create a ego vehicle polygon and move it to current ego
            % vehicle pose
            egoPolygon = pointPose + vehiclePolygon;
            
            % Create a rotation matrix R from the current ego vehicle yaw
            R = [cos(egoYaw), -sin(egoYaw); sin(egoYaw), cos(egoYaw)];
            
            % Rotate the ego polygon with rotation matrix R
            egoPolygon = (R * (egoPolygon - pointPose)) + pointPose;
            
            % Create a polygon of egoPolygon size and place it onto above
            % shown image
            patch(egoPolygon(1, :), egoPolygon(2, :), 'b', 'Parent', axis);
            
            % Set the orientation of output to upside
            axis.CameraUpVector = [1 0 0];
            
        end % update_grid_visualization
        
        function vehiclePolygon = vehiclePolygonFun (vehicle)
            % Create a variable to hold vehicle dimensions. Vehicle
            % dimensions are extracted from vehicle scenario directly
            % Function handle creation
            % -------------------------------------------------------------
            vehiclePolygon = [vehicle.Length, vehicle.Width/2; ...
                vehicle.Length, -vehicle.Width/2; ...
                0, -vehicle.Width/2; ...
                0, vehicle.Width/2]';
        end % vehiclePolygonFun
    end
end

