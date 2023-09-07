classdef TrafficEnvironment < handle & matlab.System
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    % TODO: -
    % - Detect vehicle collisions
    % - Create Visualization options (birds eye view) (ScenarioViz)
    % - Create Action control for ego vehicles (use Flow project as
    % reference)
    % - create ego vehicle action
    % - Create logic for current actor list
    % Create visualization chase plot on every traffic actor, instead of
    % defining general class in here
    
    properties (SetAccess='private', GetAccess = 'public')
        % DSD Road Scenario
        Scenario
        SumoConfigFile (1,:) char {mustBeText} = ''
        % simulation configuration parameters
        SumoViz (1,1) logical {mustBeNumericOrLogical} = false; %SUMO gui visualization
        ScenarioViz (1,1) logical {mustBeNumericOrLogical} = true; %DSD visualization
        % simulation parameters
        SampleTime (1,1) double {mustBeReal, mustBeFinite, mustBePositive} = 0.01 %simulation step time
        CurrentTime (1,1) double {mustBeReal, mustBeFinite} = 0; %simulation current Time
        StopTime (1,1) double {mustBeReal, mustBePositive} = inf; %simulation end Time
        IsRunning (1,1) logical {mustBeNumericOrLogical} = false; %Is simulation running
        % Traffic Creation Parameters
        %NumTrafficActors (1,1) int16 {mustBeNumeric, mustBeFinite, mustBeNonnegative, mustBeGreaterThanOrEqual(NumTrafficActors, 0)} = 1 % Number of traffic vehicles
        NumTrafficActors   % Number of traffic vehicles
        RandomTraffic  (1,1) logical {mustBeNumericOrLogical} %If traffic should be randomized
        BoundsRandomTraffic (2,1) int16 {mustBeFinite, mustBeGreaterThanOrEqual(BoundsRandomTraffic, 0), mustBeLessThanOrEqual(BoundsRandomTraffic,500)} = [1 200];
        % Ego Vehicles
        NumEgoVehicles (1,1) int16 {mustBeNumeric, mustBeFinite, mustBeGreaterThanOrEqual(NumEgoVehicles, 0)} = 0 % Number of controlled Vehicles     
        % Simulation Parameters
        hasCollidedSumo logical {mustBeNumericOrLogical} = false;
    end
    properties (SetAccess = protected, GetAccess = public)
        % Current Traffic Parameters
        CurrentActorsNumber (1,1) int16 %{mustBeNumeric, mustBeFinite, mustBePositive, mustBeGreaterThanOrEqual(CurrentActorsNumber, 1)}  % Number of current spawned vehicles on current episode
        CollisionsNumber (1,1) int16 %{mustBeNumeric, mustBeInteger, mustBePositive}  % Number of collisions on simulation
        CollisionIDs cell % Cell containing ids of colliding vehicles
        VehicleEnvList cell = {};% Current Spawned Vehicle on Environment (sumo and dsd)
        % Ego Parameters
        egoActionSpace = [];
        egoModelType = [];
        EgoEnvList cell = {};% Current Spawned Vehicle on Environment (sumo and dsd)
    end
    properties (SetAccess = private, GetAccess = private)
        % Sumo parameters
        SUMOVehiclesList cell % Current Spawned Vehicle Names (on SUMO)
        NumVehiclesWaiting int16 = 0;% Number of vehicles waiting to spawn (NOT CURRENTLY USED)
        HasSumoStarted logical = false; %has traci been able to stablish connection with SUMO
        HasSpawnedTraffic logical = false; % Has Traffic been created
        % Container map of traffic vehicles
        TrafficVehMap % Container map that stores index location of trafficVehicle on VehicleEnvList
        EgoVehMap % Container map that stores index location of egoVehicle on EgoEnvList
        % Subscriptions for Collisions
        NumberCollisionsEnv {mustBeNumeric} = 0; % Number of collisions that have occurred on environment
        HasSubscribedToCollisions logical {mustBeNumericOrLogical} = false; % Boolean to determine if traci has subscribed to collisions
        CollisionsConstSubs = struct('CollisionID',traci.constants.VAR_COLLIDING_VEHICLES_IDS, ... % Constants defined by traci to subscribe to simulation variables
            'CollisionNum', traci.constants.VAR_COLLIDING_VEHICLES_NUMBER)
        % Traffic Configuration
        SumoSpawnConfig = struct(...
            departLane = 'random', ...
            departPos = 'random', ...
            departSpeed = 'random', ...
            arrivalLane = 'random', ...
            arrivalPos  = 'max', ...
            arrivalSpeed = 'random');
        TrafficConfig = struct(...
            VehicleType = 'DEFAULT_VEHTYPE',...
            NumTrafficActors = 1,... % Number of traffic vehicles
            RandomTraffic = false, ...
            BoundsRandomTraffic = [1 200])
        % Collisions obstacle list
        ObstacleList = [];
    end
    %% Constructor
    methods
        function [obj, success] = TrafficEnvironment(scenario, sumoCfg, ...
                EgoCfg, TrafficCfg,stopTime, simOptions)%egoOptions
            %Initializes traffic environment class and stablishes
            %connection with sumo
            % -------------------------------------------------------------
            arguments
                scenario {mustBeUnderlyingType(scenario, 'drivingScenario')}
                sumoCfg (1,:) char {mustBeText, mustBeNonzeroLengthText}
                EgoCfg (1,:) char {mustBeText, mustBeNonzeroLengthText}
                TrafficCfg (1,:) char {mustBeText, mustBeNonzeroLengthText}
                stopTime (1,1) double {mustBeReal, mustBePositive} = 0; %simulation end Time
            end
            arguments
                % simulation configuration parameters
                simOptions.SumoVisualization (1,1) logical {mustBeNumericOrLogical} = false; %SUMO gui visualization
                simOptions.ScenarioVisualization (1,1) logical {mustBeNumericOrLogical} = true; %DSD visualization
                % simulation parameters
                simOptions.SampleTime (1,1) double {mustBeReal, mustBeFinite, mustBePositive} = 0.01 %simulation step time
                simOptions.LaneChangeType char {mustBeMember(simOptions.LaneChangeType, {'Duration', 'Resolution'})}= 'Duration'; %simulation lane change type (specified by duration or resolution of lane change
                simOptions.LateralDuration (1,1) double {mustBeReal, mustBeFinite, mustBePositive} = 4; %simulation lateral time duration for lane change
                simOptions.LateralResolution  (1,1) double {mustBeReal, mustBeFinite, mustBePositive} = 0.25; %simulation lateral resolution for lane change
                simOptions.InitSimSteps (1,1) double {mustBeReal, mustBeFinite, mustBePositive} = 4;
            end
            
            % Initialize class
            obj.Scenario = scenario;
            obj.StopTime = stopTime;
            obj.SumoConfigFile = sumoCfg;
            % Optional Configurations
            obj.SumoViz = simOptions.SumoVisualization;
            obj.ScenarioViz = simOptions.ScenarioVisualization;
            obj.SampleTime = simOptions.SampleTime; %simulation step time
            % Update SampleTime on scenario
            obj.Scenario.SampleTime = obj.SampleTime;
            % Link times between scenario and environment
            obj.CurrentTime = obj.Scenario.SimulationTime; %simulation current Time
            % Initialize private variables
            obj.TrafficVehMap = containers.Map();
            obj.EgoVehMap = containers.Map();
            
            switch simOptions.LaneChangeType
                case 'Duration'
                    laneCmd = [' --lanechange.duration ', num2str(simOptions.LateralDuration)];
                case 'Resolution'
                    laneCmd = [' --lateral-resolution ', num2str(simOptions.LateralResolution)];
                otherwise
                    laneCmd = [' --lanechange.duration ', num2str(simOptions.LateralDuration)];
            end
            
            % Stablish connection with SUMO
            try
                if obj.SumoViz
                    sumoCmd = 'sumo-gui -c ';
                else
                    sumoCmd = 'sumo -c ';
                end
                % Form command to stablish connection with SUMO
                command = [sumoCmd, obj.SumoConfigFile,...
                    ' --step-length ', num2str(obj.SampleTime),...
                    laneCmd, ...
                    ' --collision.check-junctions ',...
                    '--start'];
                traci.start(command);
                % Create Stablished Connection Flag
                success = true;
            catch err
                error('Failure when opening configuration file with error: %s\n', err.message);
            end
            % If connection has been stablished, configure egos and traffic
            obj.configure_traffic(EgoCfg, TrafficCfg);
            obj.HasSumoStarted = true;
            % Initialize obstacle list
            obj.ObstacleList = dynamicCapsuleList;
            obj.ObstacleList.MaxNumSteps = 1;
        end
        
    end
    %% Public methods
    methods(Access=public)
        function flag = close_connection(obj)
            % Closes connection and deletes DSD environment
            % -------------------------------------------------------------
            try
                % Close conection with Traci
                traci.close();
                % Create Stablished Connection Flag
                flag = true;
            catch err
                warning('Failure when closing connection with traci \n');
                disp(err);
                flag = false;
                return
            end
            delete(obj.Scenario)
        end
        
        function [hasBeenCreated, numberOfTrafficActors,EgoList]= deploy_traffic(obj)
            % Reset environment 
            % Delete All traffic
            obj.reset_environment();
            % decompose traffic Options
            trafficArgs = namedargs2cell(obj.TrafficConfig);
            spawnArgs = namedargs2cell(obj.SumoSpawnConfig);
            % create_traffic
            [hasBeenCreated, numberOfTrafficActors, EgoList] =...
                obj.create_traffic(trafficArgs{:}, spawnArgs{:});
        end
        
        function axis = create_chase_visualization(obj, actorID, visualizationOptions)
            % axis = create_chase_visualization(actorID, visualizationOptions)
            % Creates a chase plot around actor of type TrafficVehicle. It
            % returns chase plot axis
            % Inputs:
            % actorID (String): Actor ID of vehicle that the chase
            %       visualization should create around (Required)
            % ViewLocation (Double) (2,1): An array containing camera
            %       position with respect to ego vehicle (x,y) coord
            %       (optional name value pair)
            %       default = [-14 0]
            % Axes (Axes): Axis to plot vehicle, used for whenever a multi 
            %   axes plot is required (optional name value
            %   pair)(default=none)
            % ViewHeight (double): Camera height (optional name value pair)
            %       default = 10 m
            % ViewPitch (double): Camera pitch (optional name value pair)
            %       default = 20 deg
            % -------------------------------------------------------------
            arguments
                obj
                actorID
                visualizationOptions.Axes = [];
                visualizationOptions.ViewLocation double {mustBeNumeric} = -[4.7*3 0];
                visualizationOptions.ViewHeight double {mustBeNumeric} = 10;
                visualizationOptions.ViewPitch double {mustBeNumeric} = 20;
            end
            % Propagate variables
            ViewLocation = visualizationOptions.ViewLocation;
            ViewHeight = visualizationOptions.ViewHeight;
            ViewPitch = visualizationOptions.ViewPitch;
            % Create chase plot
            % Check vehicle on Ego or traffic actors
            if obj.TrafficVehMap.isKey(actorID)
                car = obj.VehicleEnvList{obj.TrafficVehMap(actorID)}.Vehicle;
            elseif obj.EgoVehMap.isKey(actorID)
                car = obj.EgoEnvList{obj.EgoVehMap(actorID)}.Vehicle;
            else
                error('Vehicle with name %s, not found on environment list',actorID)
            end
            if isempty(visualizationOptions.Axes)
                chasePlot(car,'ViewLocation',ViewLocation,...
                    'ViewHeight',ViewHeight,'ViewPitch',ViewPitch,...
                    'Meshes','on','Waypoints','on');
            else
                chasePlot(car,'ViewLocation',ViewLocation,...
                    'ViewHeight',ViewHeight,'ViewPitch',ViewPitch,...
                    'Parent',visualizationOptions.Axes,'Meshes','on',...
                    'Waypoints','on');
            end
            % Create a pop-out figure and display the current scene.
            f = gcf;
            f.Visible = 'on';
            axis = findobj(f,'Type','Axes');
            axis.ZLim = [-100 100];
        end
        
        function axis = create_random_visualization(obj,visualizationOptions)
            % Creates a chase plot around actor of type TrafficVehicle. It
            % returns chase plot axis
            % Inputs:
            % ViewLocation (Double) (2,1): An array containing camera
            %       position with respect to ego vehicle (x,y) coord
            %       (optional name value pair)
            %       default = [-14 0]
            % Axes (Axes): Axis to plot vehicle, used for whenever a multi 
            %   axes plot is required (optional name value
            %   pair)(default=none)
            % ViewHeight (double): Camera height (optional name value pair)
            %       default = 10 m
            % ViewPitch (double): Camera pitch (optional name value pair)
            %       default = 20 deg
            % -------------------------------------------------------------
            % -------------------------------------------------------------
            arguments
                obj
                visualizationOptions.Axes = [];
                visualizationOptions.ViewLocation double {mustBeNumeric} = -[4.7*3 0];
                visualizationOptions.ViewHeight double {mustBeNumeric} = 10;
                visualizationOptions.ViewPitch double {mustBeNumeric} = 20;
            end
            
            idList = obj.SUMOVehiclesList;
            while true
                actorID = idList{randi(length(idList))};
                if obj.TrafficVehMap.isKey(actorID)
                    % Select random actor
                    actor = obj.VehicleEnvList{obj.TrafficVehMap(actorID)};
                    break
                end
            end
            
            % Propagate variables
            ViewLocation = visualizationOptions.ViewLocation;
            ViewHeight = visualizationOptions.ViewHeight;
            ViewPitch = visualizationOptions.ViewPitch;
            % Create chase plot
            if isempty(visualizationOptions.Axes)
                chasePlot(actor.Vehicle,'ViewLocation',ViewLocation,...
                    'ViewHeight',ViewHeight,'ViewPitch',ViewPitch,...
                    'Meshes','on','Waypoints','on');
            else
                chasePlot(actor.Vehicle,'ViewLocation',ViewLocation,...
                    'ViewHeight',ViewHeight,'ViewPitch',ViewPitch,...
                    'Parent',visualizationOptions.Axes,'Meshes','on',...
                    'Waypoints','on');
            end
            % Create a pop-out figure and display the current scene.
            f = gcf;
            f.Visible = 'on';
            axis = findobj(f,'Type','Axes');
            axis.ZLim = [-100 100];
        end
        function [hasCollided, collisionIDs] = get_collisions(obj, actorID)
            % Determines if vehicle with id defined by actorID has collided
            % on the simulation using SUMO. Additionally, the function
            % returns the id of the vehicles that the vehicle has collided
            % with
            % -------------------------------------------------------------
            % Check if there is a sumo connection Stablished
            if ~obj.HasSumoStarted
                error('Connection to SUMO needs to be stablished first')
            end
            % Check if actor is in Simulation
            if ~obj.TrafficVehMap.isKey(actorID)
                warning('vehicle with name %s is not present on simulation',actorID)
                hasCollided = false;
                collisionIDs ={};
                return
            end
            % Determine if subscription to collisions has been already
            % stablished
            if ~obj.HasSubscribedToCollisions
                % stablish subscription connection if simulation has not
                % subscribed
                obj.HasSubscribedToCollisions= obj.subscribe_to_collisions();
            end
            % Extract collisions
            
            sumoCollRes = traci.simulation.getSubscriptionResults();
            
            % If there are no collisions it is not worth keep checking
            numCollisions = sumoCollRes(obj.CollisionsConstSubs.CollisionNum);
            if numCollisions
                hasCollided = false;
                collisionIDs ={};
                return
            end
            
            % Find if vehicle has collided by searching through the
            % collision IDs
            collisionIDs = sumoCollRes(obj.CollisionsConstSubs.CollisionID); 
            
            % if vehcle has collided, should be a key on container map
            if ismember(actorID,collisionIDs)
                hasCollided = true;
            end
            
        end
        
        function collisionMap = check_ego_collisions(obj, showCollisions)
            % Checks if ego vehicles have collided with any of the
            % obstacles on the environment (traffic vehicles),
            % additionally, the user can use showCollisions to indicate if
            % dynamic capsule list should show generate a plot when
            % collisions occur
            % Input:
            % - showCollisions: (Optional) (logical) if figure should be
            %   created showing the capsule collisions (default = false)
            % Output:
            % - collisionMap: Container map with vehicle id as key and a
            % boolean as a value identifying if vehicle has collided.
            % EGO ID are specyfied by ego JSON configuration file. 
            % -------------------------------------------------------------
            arguments
                obj
                showCollisions (1,1) {mustBeNumericOrLogical} = false;
            end
            % Check Collsitions
            collisionList = obj.ObstacleList.checkCollision();
            % Check Ids of vehicles that have collided
            collisionMap = containers.Map();
            for i = 1:size(obj.EgoEnvList,1)
                egoName = obj.EgoEnvList{i}.VehID;
                index = obj.EgoVehMap(egoName);
                collisionMap(egoName) = collisionList(index); 
                obj.EgoEnvList{i}.HasCollided = collisionList(index);
            end
            % If option for show collisions
            if showCollisions && any(collisionList)
                figure('units', 'normalized',...
                    'Name','Dynamic Collisions Capsules',...
                    'outerposition', [0 0 1 1]);
                obj.ObstacleList.show('ShowCollisions',true);
            end
            
        end
        
        function hasDeletedTraffic = reset_environment (obj)
            % Deletes all trffic from sumo and from simulation environment
            % -------------------------------------------------------------
            try
                if obj.HasSpawnedTraffic && obj.HasSumoStarted
                    % update sumovehicles list
                    obj.SUMOVehiclesList = traci.vehicle.getIDList();
                    
                    % Start Despawning Vehicles
                    for i = 1:length(obj.SUMOVehiclesList)
                        % Despawn Traffic vehicles
                        if obj.TrafficVehMap.isKey(obj.SUMOVehiclesList{i})
                            % Find vehicle index
                            index = obj.TrafficVehMap(obj.SUMOVehiclesList{i});
                            % Despawn actor
                            obj.VehicleEnvList{index}.despawn_actor();
                            % Remove Obstacles from capsule list
                            removeObstacle(obj.ObstacleList,index);
                        % Despawn ego vehicles
                        elseif obj.EgoVehMap.isKey(obj.SUMOVehiclesList{i})
                            % Find vehicle index
                            index = obj.EgoVehMap(obj.SUMOVehiclesList{i});
                            % Despawn ego vehicle
                            obj.EgoEnvList{index}.despawn_actor();
                            % remove ego from obstacle list
                            removeEgo(obj.ObstacleList, index);
                        end
                    end
                    
                    % Remove all remaining vehicles (if any)
                    remainingVehicles = traci.vehicle.getIDList();
                    if ~isempty(remainingVehicles)
                        for i = 1:length(remainingVehicles)
                            traci.vehicle.remove(remainingVehicles{i});    
                        end
                    end
                    % Reset environment
                    obj.Scenario.restart;
                    % Reset Time
                    obj.CurrentTime = obj.Scenario.SimulationTime;
                    % Perform simulation step on sumo to update changes
                    traci.simulation.step;
                    hasDeletedTraffic = true;
                else
                    hasDeletedTraffic = false;
                end
            catch err
                warning(err.message)
                hasDeletedTraffic = false;
            end
            
        end
        
    end
    %% Setters and getters
    methods
        function set.StopTime(obj,stopTime)
            obj.StopTime = stopTime;
        end
        function numCollisions = get.CollisionsNumber(obj)
            numCollisions = obj.CollisionsNumber;
        end
    end
    
    methods (Access=protected)
        function isRunning = stepImpl(obj)
            %STEP Performs a one step advance on the simulation (SUMO and
            %DSD. Outputs whether the simulation is still running. The
            %method will stop whenever simulation time reaches specified
            %end time
            % -------------------------------------------------------------
            
            if obj.CurrentTime <= obj.StopTime
                % Advance sumo
                traci.simulation.step();
                % synchronize Vehicles
                obj.update_all_vehicles();
                % Advance DSD
                advance(obj.Scenario);
                obj.IsRunning = true;
                isRunning = obj.IsRunning;
                % update CurrentTime
                obj.CurrentTime = obj.Scenario.SimulationTime;
            else
                isRunning = false;
                warning('Simulation has reached defined final time')
            end
        end
    end
    %% Static Methods
    methods (Static)
        function success = stop_simulation()
            % Closes traci connection and stops simulation
            % -------------------------------------------------------------
            success = traci.close();
        end
    end
    
    %% Private Methods
    methods (Access = private)
        function sumoList = reset_sumoVehicle_list(obj)
            % Resets vehicles from list
            % -------------------------------------------------------------
            obj.SUMOVehiclesList = {};
            sumoList = obj.SUMOVehiclesList;
        end
        function hasUpdatedVehicles = update_all_vehicles(obj)
            if obj.HasSpawnedTraffic && obj.HasSumoStarted
                % update sumovehicles list
                obj.SUMOVehiclesList = traci.vehicle.getIDList();
                % Update current number of vehicles on simulation
                obj.CurrentActorsNumber = length(obj.SUMOVehiclesList);
                % Start spawning Vehicles
                for i = 1:length(obj.VehicleEnvList)
                    obj.VehicleEnvList{i}.synchronize(obj.SUMOVehiclesList);
                    % Update collision capsule pose
                    obsCar = obj.VehicleEnvList{i}.Vehicle; 
                    pos = obsCar.Position(1:2);
                    angle = obsCar.Yaw*pi/180;
                    obsState.States = [pos,angle];
                    % Extract Obstacle Pose
                    updateObstaclePose(obj.ObstacleList,i,obsState);
                end
                for j = 1:length(obj.EgoEnvList)
                    % synchronize vehicle
                    obj.EgoEnvList{j}.synchronize(obj.SUMOVehiclesList);
                    % Update ego capsule pose
                    egoCar = obj.EgoEnvList{j}.Vehicle; 
                    pos = egoCar.Position(1:2);
                    angle = egoCar.Yaw*pi/180;
                    egoState.States = [pos,angle];
                    updateEgoPose(obj.ObstacleList,j,egoState);
                end
                hasUpdatedVehicles = true;
            else
                hasUpdatedVehicles = false;
            end
        end
        
        function hasSubscribedToCollisions = subscribe_to_collisions(obj)
            % Method to subscribe to variable collisions and collision IDs
            % -------------------------------------------------------------
            try
                % Create cell for collisions retrieval as per traci4matlab
                % requirements
                subsID = {obj.CollisionsConstSubs.CollisionID, ...
                    obj.CollisionsConstSubs.CollisionNum};
                % Subscribe to collisions
                traci.simulation.subscribe(subsID);
                hasSubscribedToCollisions = true;
            catch err
                warning(err.identifier,'%s', err.message)
                hasSubscribedToCollisions = false;
            end
        end
               
        function egoVeh = create_ego_vehicle(obj,EgoConfigs, SpawnOptions, SensorConfigs)
            % Initializes an ego vehicle using ego configs. Additionally,
            % uses sensor configs to create sensors from EgoConfigs
            % -------------------------------------------------------------
            % Create name-value pairs for ego vehicle
            typeArgs = namedargs2cell(rmfield(EgoConfigs,'vehicleID'));
            spawnArgs = namedargs2cell(SpawnOptions);
            % Create vehicle constructor
            egoVeh = EgoVehicle(EgoConfigs.vehicleID,obj.Scenario,...
                typeArgs{:},spawnArgs{:});
            % Create Sensors if they exist
            % Extract Sensor Names
            sensors = SensorConfigs.Names;
            if isempty(sensors)
                return
            end
            %else
            for i = 1:length(sensors)
                switch sensors{i}
                    case 'Lidar'
                        % Iterate through lidar elements
                        numLidars = 0;
                        for j = 1:length(SensorConfigs.Lidar)
                            lidarArgs = namedargs2cell(...
                                SensorConfigs.Lidar(j).config);
                            [~,numLidars] = egoVeh.create_lidar_sensor(...
                                lidarArgs{:});
                        end
                        % Verify that number of lidars created is the same
                        % as requested
                        assert(numLidars == length(SensorConfigs.Lidar),...
                            'number of lidars created does not match the number requested')
                    case 'Radar'
                        numRadars = 0;
                        for j = 1:length(SensorConfigs.Radar)
                            radarArgs = namedargs2cell(...
                                SensorConfigs.Radar(j).config);
                            [~,numRadars] = egoVeh.create_radar_sensor(...
                                radarArgs{:});
                        end
                        % Verify that number of Radars created is the same
                        % as requested
                        assert(numRadars == length(SensorConfigs.Radar),...
                            'number of Radars created does not match the number requested')
                    case 'Vision'
                        numCams = 0;
                        % Iterate through lidar elements
                        for j = 1:length(SensorConfigs.Vision)
                            visionArgs = namedargs2cell(...
                                SensorConfigs.Vision(j).config);
                            [~,numCams] = egoVeh.create_camera_sensor(...
                                visionArgs{:});
                        end
                        % Verify that number of lidars created is the same
                        % as requested
                        assert(numCams == length(SensorConfigs.Vision),...
                            'number of cameras created does not match the number requested')
                    case 'OccupancyGrid'
                       occupancyArgs = namedargs2cell(...
                           SensorConfigs.OccupancyGrid);
                       egoVeh.create_binary_grid(occupancyArgs{:});
                end
            end
        end % create_ego_vehicle
        
        function [egoMap, egoList, numEgos] = configure_ego_vehicles(obj,egoJson)
            % Configures egos and creates an egoMap and Ego List
            % -------------------------------------------------------------
            % Read Ego Configuration
            egoConfigStruct = obj.read_json_config(egoJson);
            % Extract number of Ego Vehicles
            numEgos = egoConfigStruct.NumberEgos;
            % Create ego Vehicle Map 
            egoMap = containers.Map();
            % Create an empty cell array to contain ego vehicles
            egoList = cell(numEgos,1);
            for i=1:numEgos
                % Extract configurations for ego i
                [egoConfig, spawnOptions, sensorConfig] = ...
                    obj.read_ego_configuration(egoConfigStruct.Ego(i));
                % Check if id is repeated
                if egoMap.isKey(egoConfig.vehicleID)
                    error('repeated vehicleID %s',EgoConfigs.vehicleID);
                else
                    % Append egoMap
                    egoMap(egoConfig.vehicleID) = i;
                    % Create ego
                    egoList{i} = obj.create_ego_vehicle(...
                        egoConfig,spawnOptions,sensorConfig);
                end %if
            end %for
        end % configure_ego_vehicles
        %% Traffic Configuration
        function configure_traffic(obj, EgoConfigPath, TrafficConfigPath)  
            % Creates traffic configuration for every loop.
            % EgoConfiguration should be of type json, and should contain
            % the configurations regarding the creation of each ego with
            % its corresponding sensors. Similarly, TrafficConfig
            % configures Traffic. Must be of type JSON
            % Input:
            % EgoConfig: (char) Ego Configuration File Location. Must be 
            %       of type .json
            % TrafficConfig: (char) Traffic Configuration file location.
            %       Must be of type .json
            % Output:
            % hasConfiguredTraffic: (bool) If configure_traffic has
            %   succeeded configuring traffic
            % -------------------------------------------------------------
            
            % Configure Egos
            [obj.EgoVehMap, obj.EgoEnvList, obj.NumEgoVehicles] =...
                obj.configure_ego_vehicles(EgoConfigPath);

            % Read Traffic Configuration File
            trafConfigStruct = obj.read_json_config(TrafficConfigPath);
            % Configure Traffic
            [obj.TrafficConfig, obj.SumoSpawnConfig]=...
                obj.read_traffic_configuration(trafConfigStruct);         
        end
        
        function [hasBeenCreated, numberOfTrafficActors,EgoList] = create_traffic(obj,trafficOptions, sumoOptions)
            % Creates traffic on environment based on the number of traffic
            % actors defined during function call. Optionally, one can
            % specity the RandomTraffic = true, and BoundsRandomTraffic to
            % define bounds of random number generator [min max]
            % -------------------------------------------------------------
            arguments
                obj               
                % Environment traffic options
                trafficOptions.VehicleType (1,:) char {mustBeText} = 'DEFAULT_VEHTYPE'
                trafficOptions.NumberVehicles = 1; % Number of traffic vehicles
                trafficOptions.RandomTraffic  (1,1) logical {mustBeNumericOrLogical} = false %If traffic should be randomized
                trafficOptions.BoundsRandomTraffic (2,1) int16 {mustBeFinite,mustBeGreaterThanOrEqual(trafficOptions.BoundsRandomTraffic, 0), mustBeLessThanOrEqual(trafficOptions.BoundsRandomTraffic,500)} = [1 200];
                % sumo traffic options
                sumoOptions.departLane = 'random'
                sumoOptions.departPos = 'random'
                sumoOptions.departSpeed = 'random'
                sumoOptions.arrivalLane = 'random'
                sumoOptions.arrivalPos  = 'max'
                sumoOptions.arrivalSpeed = 'random'
            end
            % Propagate option value pairs
            vehType = trafficOptions.VehicleType;
            obj.NumTrafficActors = trafficOptions.NumberVehicles;
            obj.RandomTraffic = trafficOptions.RandomTraffic;
            obj.BoundsRandomTraffic = trafficOptions.BoundsRandomTraffic;
            
            % Determine number of required traffic actors
            if obj.RandomTraffic
                NumVehicles = double(randi(obj.BoundsRandomTraffic,1,1)+obj.NumEgoVehicles);
            else
                NumVehicles = double(obj.NumTrafficActors+obj.NumEgoVehicles);
            end
            % Dretermine random index for ego vehicles insertion            
            egoIndx = randperm(NumVehicles,obj.NumEgoVehicles);
            % Get the available route list
            routeList = traci.route.getIDList;
            % util variables
            egoCounter = 0;
            trafficCounter = 0;
            %% Create Vehicles and Spawn them
            for i = 1:NumVehicles
                % Generate vehicle id by adding leading zeros to number
                if ismember(i,egoIndx)
                    egoCounter = egoCounter+1;
                    vehID = obj.EgoEnvList{egoCounter}.VehID;                    
                else 
                    trafficCounter = trafficCounter +1;
                    vehID = ['veh0', num2str(trafficCounter,['%0' num2str(ceil(log10(NumVehicles))) '.f'])];
                end
                % Check if vehicle has already been created
                % Find vehicle index              
                if obj.TrafficVehMap.isKey(vehID) 
                    % If vehicle exists on simulation
                    actorMapIndex = obj.TrafficVehMap(vehID);              
                elseif obj.EgoVehMap.isKey(vehID)
                    egoMapIndex = obj.EgoVehMap(vehID);
                else
                    % If it does not exist, create and add vehicle to list
                    % by initializing TrafficVehicle class
                    obj.VehicleEnvList{length(obj.VehicleEnvList)+1}=...
                        TrafficVehicle(vehID, obj.Scenario,...
                        'TypeID', vehType);
                    % Select index to be last concatenated vehicle
                    actorMapIndex = length(obj.VehicleEnvList);
                    % Add vehicle and index to dictionary
                    obj.TrafficVehMap(vehID) = actorMapIndex;
                end               
                %% Add Actors
                if obj.TrafficVehMap.isKey(vehID)
                    % Select a route
                    while true
                        actorRoute = routeList{randi(length(routeList),1,1)};
                        if ~strcmp(actorRoute,'ego_route')
                            break
                        end
                    end
                    % Spawn vehicle
                    obj.VehicleEnvList{actorMapIndex}.spawn_vehicle(actorRoute,...
                        departLane = sumoOptions.departLane, ...
                        departPos = sumoOptions.departPos, ...
                        departSpeed = sumoOptions.departSpeed, ...
                        arrivalLane = sumoOptions.arrivalLane, ...
                        arrivalPos  = sumoOptions.arrivalPos, ...
                        arrivalSpeed = sumoOptions.arrivalSpeed);
                    % Deploy vehicle
                    traci.simulationStep(traci.simulation.getTime+0.3);
                    obj.SUMOVehiclesList = traci.vehicle.getIDList();
                    % Add vehicle to obstacle list
                    % Extract States
                    obsCar = obj.VehicleEnvList{actorMapIndex}.Vehicle; 
                    pos = obsCar.Position(1:2);
                    angle = obsCar.Yaw*pi/180;
                    obsState = [pos,angle];
                    % Extract Geometry
                    geom = struct("Length",obsCar.Length,"Radius",...
                        obsCar.Width/2,"FixedTransform",eye(3));   
                    geom.FixedTransform(1,end) = -obsCar.Length*0.25;
                    obsCapsuleStruct = struct('ID',actorMapIndex,...
                            'States',obsState,...
                            'Geometry',geom);
                    % Add obstacle
                    addObstacle(obj.ObstacleList,obsCapsuleStruct);
                %% Add EGOs
                elseif obj.EgoVehMap.isKey(vehID)
                    % Spawn vehicle
                    obj.EgoEnvList{egoMapIndex}.spawn_vehicle();
                    % Deploy vehicle
                    traci.simulationStep(traci.simulation.getTime+0.3);
                    obj.SUMOVehiclesList = traci.vehicle.getIDList();
                     % Add vehicle to obstacle list
                    % Extract States
                    egoCar = obj.EgoEnvList{egoMapIndex}.Vehicle; 
                    pos = egoCar.Position(1:2);
                    angle = egoCar.Yaw*pi/180;
                    egoState = [pos,angle];
                    % Extract Geometry
                    geom = struct("Length",egoCar.Length,"Radius",...
                        egoCar.Width/2,"FixedTransform",eye(3)); 
                    geom.FixedTransform(1,end) = -egoCar.Length*0.25;
                    egoCapsuleStruct = struct('ID',egoMapIndex,...
                            'States',egoState,...
                            'Geometry',geom);
                    % Add obstacle
                    addEgo(obj.ObstacleList,egoCapsuleStruct);
                end
            end % for
            % Update Sumo Vehicles List
            obj.SUMOVehiclesList = traci.vehicle.getIDList();
            % Update CurrentActorsNumber
            obj.CurrentActorsNumber = length(obj.SUMOVehiclesList);
            % Create outputs
            obj.HasSpawnedTraffic = true;
            hasBeenCreated = obj.HasSpawnedTraffic;
            numberOfTrafficActors = obj.CurrentActorsNumber;
            % Check if number of traffic actors is the same as the number
            % of actors waiting to spawn
            minExpected = traci.simulation.getMinExpectedNumber();
            if numberOfTrafficActors ~= minExpected
                warning('number of traffic actors does not match number of vehicles waiting to spawn on simulation');
            end
            
            % Update all vehicles as sanity check
            % Deploy ego list
            EgoList = obj.EgoEnvList;
            % Update All Vehicles Position
            obj.update_all_vehicles;
            obj.Scenario.updatePlots;
        end
        
    end
    
    methods (Access=private, Static)
                %% Utils
        function configStruct = read_json_config(configPath)
            % Reads configuration json file and outputs a decoded structure
            % array with the parameters from json file
            % -------------------------------------------------------------
            % Validdate input
            [~,~,ext] = fileparts(configPath);
            message = sprintf('%s file needs to be of type json',configPath);
            assert(strcmp(ext,'.json'),message);
            % Open configuration file
            fid = fopen(configPath);
            if fid == -1, error('Cannot open JSON file'); end
            % Decode json 
            raw = fread(fid,inf);
            strRaw = char(raw');
            configStruct = jsondecode(strRaw);
            % close configuration file
            fclose(fid);
        end
        %% Ego Vehicle Configuration
        function [EgoConfigs, SpawnOptions, EgoSensors]= read_ego_configuration(cfgStruct)
            % Method to read ego configuration file for single vehicle,
            % outputs an structure containing name value pairs for ego
            % creation, additionally, contains sensor configurations
            % -------------------------------------------------------------
            % Extract fields
            % Ego Configuration
            EgoConfigs.vehicleID = cfgStruct.Name;
            EgoConfigs.TypeID = cfgStruct.VehicleType;
            
            if isfield(cfgStruct,'Color')
                EgoConfigs.Color = cfgStruct.Color;
            end
            % Extract Model Space
            if isfield(cfgStruct, 'ModelType')
                EgoConfigs.ModelType = cfgStruct.ModelType;
            else
                EgoConfigs.ModelType = 'SUMO';
               
            end
            % Validate Action Space
            if isfield(cfgStruct,'ActionType')
                if (strcmp(EgoConfigs.ModelType,'SUMO') &&...
                  ~strcmp(cfgStruct.ActionType,'Discrete-MetaAction'))||...
                    (strcmp(EgoConfigs.ModelType,'Bicycle')&& ...
                    strcmp(cfgStruct.ActionType,'Discrete-MetaAction'))
                    error('Incompatible Modeltype and ActionType')
                else
                    EgoConfigs.ActionType = cfgStruct.ActionType;
                end
            else
                 EgoConfigs.ActionType = 'Discrete-MetaAction';
            end
            
            % Extract Spawning Options
            assert(isfield(cfgStruct,'SpawnOptions'),'SpawnOptions structure not found');
            SpawnOptions = cfgStruct.SpawnOptions;
            SpawnOptions.Route = cfgStruct.Route;
            % Lidar
            EgoSensors.Names = {};
            if isfield(cfgStruct,'Lidar')
                EgoSensors.Names = cat(1, EgoSensors.Names, 'Lidar');
                EgoSensors.Lidar = cfgStruct.Lidar;           
            end
            % Vision
            if isfield(cfgStruct,'Vision')
                EgoSensors.Names = cat(1, EgoSensors.Names, 'Vision');
                EgoSensors.Vision = cfgStruct.Vision;
            end
            % Radar
            if isfield(cfgStruct,'Radar')
                EgoSensors.Names = cat(1, EgoSensors.Names, 'Radar');
                EgoSensors.Radar = cfgStruct.Radar;
            end
            % OccupancyGrid
            if isfield(cfgStruct,'OccupancyGrid')
                EgoSensors.Names = cat(1, EgoSensors.Names, 'OccupancyGrid');
                EgoSensors.OccupancyGrid = cfgStruct.OccupancyGrid;
            end      
        end % read_ego_configuration
        function [TrafficConfigs, SpawnOptions]= read_traffic_configuration(cfgStruct)
            % Method to read traffic configuration file for single vehicle,
            % outputs an structure containing name value pairs for ego
            % creation, additionally, contains sensor configurations
            % -------------------------------------------------------------
            % Extract fields          
            if cfgStruct.RandomTraffic && ~isfield(cfgStruct,'BoundsRandomTraffic')
                error('if RandomTraffic is true, field with BoundsRandomTraffic must be specified')
            elseif ~cfgStruct.RandomTraffic
                TrafficConfigs.VehicleType = cfgStruct.VehicleType;
                TrafficConfigs.NumberVehicles = cfgStruct.NumberVehicles;                                         
                TrafficConfigs.RandomTraffic = false;     % dummy placeholder                       
                TrafficConfigs.BoundsRandomTraffic = ...
                    [cfgStruct.NumberVehicles, cfgStruct.NumberVehicles]; % dummy placeholder
            else
                TrafficConfigs.VehicleType = cfgStruct.VehicleType;
                TrafficConfigs.NumberVehicles = 'random'; % dummy placeholder    
                TrafficConfigs.RandomTraffic = cfgStruct.RandomTraffic;        
                TrafficConfigs.BoundsRandomTraffic = cfgStruct.BoundsRandomTraffic;
            end
            % Traffic Configuration
            SpawnOptions = cfgStruct.SpawnOptions;          
        end
    end
end

