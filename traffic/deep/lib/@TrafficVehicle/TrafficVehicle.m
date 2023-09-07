classdef TrafficVehicle < handle
    %TrafficVehicle creates a handle instance of a traffic vehicle/actor on
    %SUMO and DSD. It defines the vehicle properties and it is in charge of
    %modifying and syncronizing the vehicles from DSD with SUMO
    %co-simulator
    
    properties(SetAccess = 'protected', GetAccess = 'public')
        % driving Scenario
        Scenario
        % Vehicle ID
        VehID
        % Vehicle from Driving Scenario
        Vehicle  %{mustBeUnderlyingType(Vehicle, "Vehicle")}
        % Vehicle physical parameters
        TypeID (1,:) char {mustBeNonzeroLengthText, mustBeText} = 'passenger' % Vehicle Type
        Length (1,1) double {mustBePositive, mustBeNumeric} = 4.3 % Vehicle length
        Width  (1,1) double {mustBePositive, mustBeNumeric} = 1.8 % Vehicle width
        Height (1,1) double {mustBePositive, mustBeNumeric} = 1.5 % Vehicle height
        Color (1,3) double {mustBeNumeric} = [0 0 1] % Vehicle Color
        % Vehicle States
        states = struct('Position',[],...
            'Velocity',[],...
            'Heading',[],...
            'Acceleration',[]);
        % Status (Spawned or Unsuccessful Spawn)
        Status (1,:) char %{mustBeMember(Status,{'Success', 'Failed'})}
        % Collision Mesh Object
        CollisionMesh % Vehicle collision mesh object
        IsEgo logical {mustBeNumericOrLogical} = false;
        % observation relevant  objects
        DistanceTravelled = 0;
        % Has Arrived
        HasArrived = false; % Described if vehicle has arrived to destination (or if has been despawned)
    end
    properties (SetAccess = protected, GetAccess = protected)
        % Vehicle actor index
        HasBeenCreated (1,1) logical {mustBeNumericOrLogical};
        % Vehicle States
        Position(2,1) double {mustBeReal, mustBeFinite};
        Velocity(2,1) double {mustBeReal, mustBeFinite};
        Acceleration (2,1) double {mustBeReal, mustBeFinite};
        Heading (1,1) double {mustBeReal, mustBeFinite};
        
        %TTC (1,1) = inf;
        RouteEdges = {};
        CurrEdge = {};
        CurrLane = -1;
        % Ego vehicle helper variables
        IsEgoControlled = false;
        CurrLaneDsd = -1;
        
    end
    properties (SetAccess = protected, GetAccess = protected)
        ActorIndex (1,1) int16 {mustBeInteger, mustBeNumeric} = NaN % Index of vehicle on simulation envrionment
        ActorMap                % Container map with current actors on simulation
        SubsStatesCnsts = struct('Position',traci.constants.VAR_POSITION,... % Constants for vehicle subscription
            'Speed',traci.constants.VAR_SPEED,...
            'LatSpeed',traci.constants.VAR_LATERAL_SPEED,...
            'Heading',traci.constants.VAR_ANGLE,...
            'Accel',traci.constants.VAR_ACCELERATION,...
            'Leader',traci.constants.VAR_LEADER,...
            'Edge',traci.constants.VAR_ROAD_ID);
        HasAlreadySubscribed logical =false; % Variable to determine if has already been subscribed to sumo
        
    end
    %% Setters and Getters
    methods
        % Vehicle
        function set.Vehicle(obj, VehicleObj)
            obj.Vehicle = VehicleObj;
        end
        function veh = get.Vehicle(obj)
            veh = obj.Vehicle;
        end
    end
    
    methods (Access = 'public')
        %% Constructor
        function obj = TrafficVehicle(vehicleID, Scenario, options)
            % Constructor that initializes class. During this construction
            % all the parameters relevant to vehicle is generated
            
            % Validate arguments
            arguments
                vehicleID
                Scenario
                options.TypeID  = 'DEFAULT_VEHTYPE'
                options.Length = 4.3 % Vehicle length
                options.Width   = 1.8 % Vehicle width
                options.Height  = 1.5 % Vehicle height
                options.Color = [0 0 1] % Vehicle Color
            end
            % Initialize vehicle class
            % Propagate conditions
            obj.Scenario = Scenario;
            obj.VehID = vehicleID;
            % Propagate optional arguments
            obj.TypeID = options.TypeID;
            obj.Length = options.Length;
            obj.Width = options.Width;
            obj.Height = options.Height;
            obj.Color = options.Color;
            % Initialize map container
            obj.ActorMap = containers.Map();
        end
    end
    methods (Access = 'public')
        %% Public Access Methods
        function spawnedVehicle = spawn_vehicle(obj, route, spawnOptions)
            % add_vehicle(route, options) adds a vehicle to simulation by
            % inserting the vehicle on to SUMO simulation, and then
            % insertting vehicle to driving scenario.
            % Inputs:
            %   route: (char) route name id
            %   options: Value Named options
            %       - departLane = 'random'
            %       - departPos = 'random'
            %       - departSpeed = 'random'
            %       - arrivalLane = 'random'
            %       - arrivalPos char = 'max'
            %       - arrivalSpeed = 'random'
            % Outputs:
            % spawnedVehicle: Vehicle instance from DSD with specified
            %   parameters
            % -------------------------------------------------------------
            arguments
                obj
                route char {mustBeNonzeroLengthText, mustBeText}
            end
            arguments
                spawnOptions.departLane = 'random'
                spawnOptions.departPos = 'random_free'
                spawnOptions.departSpeed = 'random'
                spawnOptions.arrivalLane = 'random'
                spawnOptions.arrivalPos  = 'max'
                spawnOptions.arrivalSpeed = 'max'
            end
            
            % Insert vehicle to SUMO simulation
            try
                traci.vehicle.add(obj.VehID, route,...
                    'typeID', obj.TypeID,...
                    'departLane', spawnOptions.departLane,...
                    'departPos',spawnOptions.departPos,...
                    'departSpeed',spawnOptions.departSpeed,...
                    'arrivalLane',spawnOptions.arrivalLane,...
                    'arrivalPos',spawnOptions.arrivalPos);
                
                % Determine class ID
                
                obj.TypeID = traci.vehicle.getTypeID(obj.VehID);
                % Verify Vehicle type
                switch obj.TypeID
                    case 'passenger'
                        classID = 1; % Car
                        vehMesh = driving.scenario.carMesh;
                    case 'truck'
                        classID = 2; % truck
                        vehMesh = driving.scenario.truckMesh;
                    case 'Bicycle'
                        classID = 3; % bicycle
                        vehMesh = driving.scenario.bicycleMesh;
                    otherwise
                        classID = 1; % Car
                        vehMesh = driving.scenario.carMesh;
                end
                
                % Set vehicle color
                if classID ==2
                    obj.Color = [1 0 0];
                end
                color = [round(obj.Color.*255), 255];
                traci.vehicle.setColor(obj.VehID, color)
                % Extract physical properties
                obj.Height = traci.vehicle.getHeight(obj.VehID);
                obj.Length = traci.vehicle.getLength(obj.VehID);
                obj.Width = traci.vehicle.getWidth(obj.VehID);
            catch err
                disp(err)
                warning('Vehicle %s could not be spawned',obj.VehID);
                return
            end
            
            % Add vehicle to driving scenario designer
            
            % Check if need to add another vehicle or if just an update is
            % okay
            if ~obj.check_if_exists_on_dsd()
                spawnedVehicle = vehicle(obj.Scenario, ...
                    'Length', obj.Length,...
                    'Width', obj.Width, ...
                    'Height', obj.Height,...
                    'ClassID', classID,...
                    'PlotColor', obj.Color,...
                    'Name',obj.VehID,...
                    'Mesh',vehMesh);
                obj.Vehicle = spawnedVehicle;
                % Update container map
                obj.ActorMap(spawnedVehicle.Name) = spawnedVehicle.ActorID;
                % Create object mesh
                obj.CollisionMesh = collisionMesh(vehMesh.Vertices);
            else
                %Update pyshical properties
                obj.Vehicle.Length = obj.Length;
                obj.Vehicle.Width = obj.Width;
                obj.Vehicle.Height = obj.Height;
                obj.Vehicle.ClassID = classID;
                obj.Vehicle.PlotColor = obj.Color;
                obj.Vehicle.Mesh = vehMesh;
                % Update Collision Mesh properties
                obj.CollisionMesh = collisionMesh(vehMesh.Vertices);
                spawnedVehicle = obj.Vehicle;
            end
            
            % update has arrived status
            obj.HasArrived = false;
            
        end
        
        
        function hasDespawned = despawn_actor(obj)
            % destroy_actor() despawns vehicle from SUMO simulation and
            % from DSD. For DSD, takes vehicle's exit time and sets it to
            % current time
            % -------------------------------------------------------------
            
            % remove vehicle from SUMO simulation
            try
                traci.vehicle.remove(obj.VehID)
            catch err
                warning('Vehicle %s could not be removed.\n Error: %s \n',obj.VehID, err)
                hasDespawned = false;
                return
            end
            % Despawn vehicle
            hasDespawned = obj.reset_vehicle_dsd();
            % Update has arrived status
            obj.HasArrived = hasDespawned;
            % Reset Subscription Logic Variable
            obj.HasAlreadySubscribed = false;
        end
        
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
                % If vehicle is present on SUMO and DSD
                obj.update_dsd_vehicle_states();
                obj.CurrLaneDsd = obj.Vehicle.currentLane;
                % update mesh pose
                obj.update_collisionMesh_pose();
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
            isRunning = true;
        end %synchronize
        
    end
    %% Private Access methods (UTILS)
    methods (Access = 'protected')
        function hasBeenCreated = check_if_exists_on_dsd(obj)
            % Checks if vehicle has been created as part of scenario
            % Check if vehicle has been spawned already (sanity check)
            
            % Locate vehicle (if exists)
            hasBeenCreated = ismember(obj.VehID,[obj.Scenario.Actors.Name]);
            
        end
        function hasBeenCreated = check_if_exists_on_sumo(obj, sumoVehicleList)
            % Checks if vehicle has been spawned on the SUMO simulation
            % Takes sumoVehicleMap as a container map that includes vehicle
            % index on SUMOVehicle list extracted from
            % traci.vehicle.getIDlist
            arguments
                obj
                sumoVehicleList {mustBeUnderlyingType(sumoVehicleList,'cell')}
            end
            hasBeenCreated = ismember(obj.VehID,sumoVehicleList);
        end
        function states = extract_sumo_vehicle_states2D(obj)
            % Extracts vehicle states from sumo using traci and performs
            % coordinate transformation to DSD coordinate frame
             try
                % Extract Vehicle Subscriptions
                res = traci.vehicle.getSubscriptionResults(obj.VehID);
                
                % Position is references with respec to front bumper
                position_sumo = res(obj.SubsStatesCnsts.Position);
                speed_sumo = res(obj.SubsStatesCnsts.Speed);
                lat_speed_sumo = res(obj.SubsStatesCnsts.LatSpeed);
                heading_sumo = res(obj.SubsStatesCnsts.Heading);
                accel_sumo = res(obj.SubsStatesCnsts.Accel);
                % Update metadata
                obj.update_metadata(); 
                
                % Compute offset center for vehicle on DSD
                heading_angle_dsd= (-heading_sumo+90)*pi/180;
                %heading_angle_dsd= heading_sumo*pi/180-pi/2;
                center_offset = obj.Vehicle.Length-obj.Vehicle.RearOverhang;
                x_dsd = position_sumo(1) - cos(heading_angle_dsd)*center_offset;
                y_dsd = position_sumo(2) - sin(heading_angle_dsd)*center_offset;
                % Perform coordinate transformation
                % Position on DSD is with respect to rear axle
                obj.Heading = heading_angle_dsd; % rad
                obj.Position = [x_dsd, y_dsd];

                %obj.Velocity = [speed_sumo*cos(obj.Heading), speed_sumo*sin(obj.Heading)];
                obj.Velocity =  [speed_sumo, -lat_speed_sumo];
                obj.Acceleration = [accel_sumo, accel_sumo*sin(obj.Heading)];
                
            catch err
                disp(err)
                warning('states could not be retrieved for vehicle %s',obj.VehID)

             end
            % Update state structure
            states = struct('Position',obj.Position,...
                'Velocity',obj.Velocity,...
                'Heading',obj.Heading,...
            'Acceleration', obj.Acceleration);
        end
        
        function hasBeenUpdated = update_dsd_vehicle_states(obj)
            %Updates states on dsd scenario by retrieving states from SUMO
            %and then forcing output on DSD scenario
            % -------------------------------------------------------------
%             try
                %update time
                %                 currTime = obj.Scenario.SimulationTime;
                obj.Vehicle.ExitTime = inf;
                % Retrieve states from sumo
                obj.states = obj.extract_sumo_vehicle_states2D();
                % Update states from vehicle on scenario
                obj.Vehicle.Position(1:2) = obj.states.Position;
                obj.Vehicle.Velocity(1:2) = obj.states.Velocity;
                obj.Vehicle.Yaw = wrapTo180  (obj.states.Heading*180/pi);
                hasBeenUpdated = true;
%             catch err
%                 warning(err.message)
%                 hasBeenUpdated = false;
%             end
        end
        function hasUpdated = update_metadata(obj)
            % Update metadata
            try
                res = traci.vehicle.getSubscriptionResults(obj.VehID);
                obj.CurrLane = res(traci.constants.VAR_LANE_INDEX);
                obj.RouteEdges = res(traci.constants.VAR_EDGES);
                routeIndx = res(traci.constants.VAR_ROUTE_INDEX)+1;
                if ~isempty(obj.RouteEdges)
                    obj.CurrEdge = obj.RouteEdges{routeIndx};
                end
                hasUpdated =true;
            catch err
                warning(err.message)
                hasUpdated = false;
            end
        end
        
        function hasBeenUpdated = update_collisionMesh_pose(obj)
            % Updates collision mesh object pose. This object is used to
            % determine collisions on DSD
            % -------------------------------------------------------------
            try
                % Extract collision mesh 
                pose = obj.CollisionMesh.Pose;
                % Create rotation matrix from 2d yaw  (no pith or roll
                % assumption)
                eul = [0 0 obj.Heading];
                rotm = eul2rotm(eul,'XYZ');
                pose(1:3,1:3) = rotm;
                % Extract translations
                transvect = [obj.Position', 0]';
                pose(1:3,4) = transvect;
                % update pose on collision object
                obj.CollisionMesh.Pose = pose;
                hasBeenUpdated = true;
            catch err
                warning(err.message);
                hasBeenUpdated = false;
            end
        end
        
        function hasBeenReset = reset_vehicle_dsd(obj)
            % resets vehicle with exit time of inf and entry time of 10e10,
            % it also sets vehicle states to 0
            % -------------------------------------------------------------
            try
                % Despawn vehile con dsd by setting entry times and exit
                % times for current time
                currTime = obj.Scenario.SimulationTime;
                if currTime == 0
                    currTime = currTime +obj.Scenario.SampleTime;
                end
                if currTime>=obj.Vehicle.ExitTime
                    hasBeenReset = true;
                    return
                end
                obj.Vehicle.EntryTime = 0;
                obj.Vehicle.ExitTime = currTime;
                % Reset vehicle position to 0
                obj.Vehicle.Position(1:2) = [-10000 -10000];
                obj.Vehicle.Velocity(1:2) = [0 0];
                obj.Vehicle.Yaw = 0;
                hasBeenReset = true;
                % Reset object vehicle mesh
                obj.CollisionMesh.Pose = eye(4);
                obj.CollisionMesh.Pose(4,1:3)= [-10000; -10000; 0];
            catch err
                warning(err.message)
            end
        end
        
        function hasSubscribed = subscribe_to_sumo_vehicle(obj)
            % subscribes to a sumo vehicle to perform vehicle update.
            % Creates a constant subscription service through tcp to a sumo
            % vehicle instance and retrieves the specified values using
            % constants messages defined by traci.constants. TODO: include
            % support to subscription filters
            
            try
                % Extract subscription constants
                cnsts = {obj.SubsStatesCnsts.Position, ...
                    obj.SubsStatesCnsts.Speed,...
                    obj.SubsStatesCnsts.LatSpeed,...
                    obj.SubsStatesCnsts.Accel,...
                    obj.SubsStatesCnsts.Heading,...
                    traci.constants.VAR_ROUTE_INDEX,...
                    traci.constants.VAR_EDGES,...
                    traci.constants.VAR_LANE_INDEX,...
                    traci.constants.VAR_ROAD_ID};
                traci.vehicle.subscribe(obj.VehID,cnsts);
                hasSubscribed = true;
                
            catch err
                warning(err.identifier,'%s', err.message)
                hasSubscribed = false;
            end
        end
    end % methods private
    methods (Access = protected)
    end
end



