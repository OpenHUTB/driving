% Create hierarchical structure for JSON file creation (Sample Template)
clear all
clc
%%
% *%% Ego Vehicle Parameters*
EgoConfig = struct();
EgoConfig.NumberEgos = 2;
%%
% _Ego1_
EgoConfig.Ego(1).Name = 'ego01';                                            %(required)
EgoConfig.Ego(1).ModelType = 'SUMO';                                     %(optional) Options: 'Bicycle', 'SUMO' Default: SUMO
EgoConfig.Ego(1).ActionType = 'Discrete-MetaAction';                                 %(optional) Options: 'Discrete-MetaAction', 'Discrete', 'Continuous' Default: 'Discrete-MetaAction'
EgoConfig.Ego(1).VehicleType = 'DEFAULT_VEHTYPE';                           %(required) Options: 'DEFAULT_VEHTYPE', Sumo defaults (https://sumo.dlr.de/docs/Vehicle_Type_Parameter_Defaults.html)
EgoConfig.Ego(1).Route = 'random';                                          %(required) Options:'random', routeid 
EgoConfig.Ego(1).Color = [0 1 0];                                           %(optional) Default: [0 1 0] (Green) 

% _SPAWN_OPTIONS
EgoConfig.Ego(1).SpawnOptions = struct();                                   %(required) if empty defaults will be used
% To understand options for spawnoptions, please refer to 
% <https://sumo.dlr.de/docs/Definition_of_Vehicles%2C_Vehicle_Types%2C_and_Routes.html#departlane>
EgoConfig.Ego(1).SpawnOptions.departLane = 'random';                        % (Optional) Options: {≥0, 'random', 'free', 'allowed', 'best', 'first'} Default = 'random' 
EgoConfig.Ego(1).SpawnOptions.departPos = 'random_free';                    % (Optional) Options: {≥0, 'random', 'free', 'random_free', 'base', 'last', 'stop'} Default = 'random' 
EgoConfig.Ego(1).SpawnOptions.departSpeed = 'random';                       % (Optional) Options: {≥0, 'random', 'free', 'max', 'desired', 'speedLimit'} Default = 'random' 
EgoConfig.Ego(1).SpawnOptions.arrivalLane = 'random';                       % (Optional) Options: {≥0, 'random', 'current', 'first'} Default = 'random'
EgoConfig.Ego(1).SpawnOptions.arrivalPos  = 'max';                          % (Optional) Options: {<FLOAT>, 'random', 'max'} Default = 'random'
EgoConfig.Ego(1).SpawnOptions.arrivalSpeed = 'random';                      % (Optional) Options: {≥0, 'current', 'max', 'random'} Default = 'random'

% _SENSORS_
% Add two lidars
% EgoConfig.Ego(1).Lidar = struct();                                          %(optional)
%     % Add Lidar 1
%     EgoConfig.Ego(1).Lidar(1).config = struct();                            % If empty, default options will be applied
%     % Add Lidar 2
%     EgoConfig.Ego(1).Lidar(2).config = struct();                          
%     EgoConfig.Ego(1).Lidar(2).config.SensorIndex = 3;                     
%     EgoConfig.Ego(1).Lidar(2).config.SensorLocation = [0 0];              
%     EgoConfig.Ego(1).Lidar(2).config.Height = 0;                          
%     EgoConfig.Ego(1).Lidar(2).config.HasEgoVehicle = false;               
%     %%
%     % Note: Refer to 
%     % <Documentation https://www.mathworks.com/help/driving/ref/lidarpointcloudgenerator-system-object.html>
%     % for more (Name, Value) options for lidar creation
% % Add two Vision Sensors
% EgoConfig.Ego(1).Vision = struct();                                         %(optional)
%     % Add Vision Sensor 1
%     EgoConfig.Ego(1).Vision(1).config = struct();                           % If empty, default options will be applied
%     EgoConfig.Ego(1).Vision(1).config.SensorIndex = 4;                      %(optional) 
%     EgoConfig.Ego(1).Vision(1).config.SensorLocation = [1.35, 0];            %(optional
%     EgoConfig.Ego(1).Vision(1).config.Height = 1.1;                         %(optional
%     % Add Vision Sensor 2
%     EgoConfig.Ego(1).Vision(2).config.SensorIndex = 5;                      %(optional)
%     EgoConfig.Ego(1).Vision(2).config.SensorLocation = [0.36, 0];            %(optional
%     EgoConfig.Ego(1).Vision(2).config.Yaw = 180;                            %(optional)
%     EgoConfig.Ego(1).Vision(2).config.Height = 1.1;                         %(optional)
%     %%
%     % Note: Refer to 
%     % <Documentation https://www.mathworks.com/help/driving/ref/visiondetectiongenerator-system-object.html>
%     % for more (Name, Value) options for vision creation
% % Add 4 Radar Sensors
% EgoConfig.Ego(1).Radar = struct();                                          %(optional)
%     % Add Radar Sensor 1
%     % Front-facing long-range radar sensor at the center of the front 
%     % bumper of the car
%     EgoConfig.Ego(1).Radar(1).config = struct();                            % If empty, default options will be applied
%     EgoConfig.Ego(1).Radar(1).config.SensorIndex = 6;                       %(optional) 
%     EgoConfig.Ego(1).Radar(1).config.RangeLimits = [0, 174];
%     EgoConfig.Ego(1).Radar(1).config.MountingLocation = [3.4, 0, 0.2];
%     EgoConfig.Ego(1).Radar(1).config.FieldOfView = [20,5];
%     % Add Radar sensor 2
%     % Rear-facing long-range radar sensor at the center of the rear bumper 
%     % of the car.
%     EgoConfig.Ego(1).Radar(2).config = struct();                            % If empty, default options will be applied
%     EgoConfig.Ego(1).Radar(2).config.SensorIndex = 7;                       %(optional) 
%     EgoConfig.Ego(1).Radar(2).config.RangeLimits = [0 30];
%     EgoConfig.Ego(1).Radar(2).config.MountingLocation = [-1, 0, 0.2];
%     EgoConfig.Ego(1).Radar(2).config.FieldOfView = [90,5];
%     EgoConfig.Ego(1).Radar(2).config.MountingAngles = [180 0 0];
%     % Add Radar sensor 3
%     % Rear-left-facing short-range radar sensor at the left rear wheel well
%     % of the car.
%     EgoConfig.Ego(1).Radar(3).config = struct();                            % If empty, default options will be applied
%     EgoConfig.Ego(1).Radar(3).config.SensorIndex = 7;                       %(optional) 
%     EgoConfig.Ego(1).Radar(3).config.RangeLimits = [0 30];
%     EgoConfig.Ego(1).Radar(3).config.MountingLocation = [0, 0.9, 0.2];
%     EgoConfig.Ego(1).Radar(3).config.FieldOfView = [90,5];
%     EgoConfig.Ego(1).Radar(3).config.ReferenceRange = 50;
%     EgoConfig.Ego(1).Radar(3).config.MountingAngles = [120 0 0];            %(optional)
%     EgoConfig.Ego(1).Radar(3).config.AzimuthResolution = 10;                %(optional)
%     EgoConfig.Ego(1).Radar(3).config.RangeResolution = 1.25;                %(optional)
%     % Add Radar sensor 4
%     % Rear-right-facing short-range radar sensor at the right rear wheel 
%     % well of the car.
%     EgoConfig.Ego(1).Radar(4).config = struct();                            % If empty, default options will be applied
%     EgoConfig.Ego(1).Radar(4).config.SensorIndex = 8;                       % (optional) 
%     EgoConfig.Ego(1).Radar(4).config.RangeLimits = [0 30];                  % (optional)
%     EgoConfig.Ego(1).Radar(4).config.MountingLocation = [0, -0.9, 0.2];     % (optional)
%     EgoConfig.Ego(1).Radar(4).config.FieldOfView = [90,5];                  % (optional)
%     EgoConfig.Ego(1).Radar(4).config.ReferenceRange = 50;                   % (optional)
%     EgoConfig.Ego(1).Radar(4).config.MountingAngles = [-120 0 0];           % (optional)
%     EgoConfig.Ego(1).Radar(4).config.AzimuthResolution = 10;                % (optional)
%     EgoConfig.Ego(1).Radar(4).config.RangeResolution = 1.25;                % (optional)
    %%
    % Note: Refer to 
    % <Documentation https://www.mathworks.com/help/driving/ref/drivingradardatagenerator-system-object.html>
    % for more (Name, Value) options for vision creation
% Add BInary Occupancy Grid Observation (Ideal)
% EgoConfig.Ego(1).OccupancyGrid = struct();                                  % (optional) Default = none
%     EgoConfig.Ego(1).OccupancyGrid.xSize = 100;                             % (optional) Default = 100 m
%     EgoConfig.Ego(1).OccupancyGrid.ySize = 100;                             % (optional) Default = 100 m   
%     EgoConfig.Ego(1).OccupancyGrid.resolution = 2;                          % (optional) Default = 2  cells per m
%     EgoConfig.Ego(1).OccupancyGrid.plot = true;                            % (optional) Default = false 
%     EgoConfig.Ego(1).OccupancyGrid.LaneDetection = true;                   %(optional) Default = false
%%
% _Ego2_
EgoConfig.Ego(2).Name = 'ego02';
EgoConfig.Ego(2).ModelType = 'SUMO';                                        %(optional) Options: 'Bicycle', 'SUMO' Default: SUMO
EgoConfig.Ego(2).ActionType = 'Discrete-MetaAction';                        %(optional) Options: 'Discrete-MetaAction', 'Discrete', 'Continuous' Default: 'Discrete-MetaAction'
EgoConfig.Ego(2).VehicleType = 'DEFAULT_VEHTYPE';                           % (required) Options: 'DEFAULT_VEHTYPE', Sumo defaults (https://sumo.dlr.de/docs/Vehicle_Type_Parameter_Defaults.html)
EgoConfig.Ego(2).Route = 'random';                                          % (required) Options:'random', routeid 
EgoConfig.Ego(2).Color = [1 0 0];                                           % (optional) Default: [0 1 0] (Green) 
% EgoConfig.Ego(2).OccupancyGrid = struct();

EgoConfig.Ego(2).SpawnOptions = struct();                                   % (required) if empty defaults will be used
EgoConfig.Ego(2).SpawnOptions.departLane = 'random';                        % (Optional) Options: {≥0, 'random', 'free', 'allowed', 'best', 'first'} Default = 'random' 
EgoConfig.Ego(2).SpawnOptions.departPos = 'random_free';                    % (Optional) Options: {≥0, 'random', 'free', 'random_free', 'base', 'last', 'stop'} Default = 'random' 
EgoConfig.Ego(2).SpawnOptions.departSpeed = 'random';                       % (Optional) Options: {≥0, 'random', 'free', 'max', 'desired', 'speedLimit'} Default = 'random' 
EgoConfig.Ego(2).SpawnOptions.arrivalLane = 'random';                       % (Optional) Options: {≥0, 'random', 'current', 'first'} Default = 'random'
EgoConfig.Ego(2).SpawnOptions.arrivalPos  = 'max';                          % (Optional) Options: {<FLOAT>, 'random', 'max'} Default = 'random'
EgoConfig.Ego(2).SpawnOptions.arrivalSpeed = 'random';                      % (Optional) Options: {≥0, 'current', 'max', 'random'} Default = 'random'


%% Generate  Ego Configuration

jsonStr = jsonencode(EgoConfig,'PrettyPrint',true);
DF = 'egoConfig.json';
fid = fopen(DF, 'w');
if fid == -1, error('Cannot create JSON file'); end
fwrite(fid, jsonStr, 'char');
fclose(fid);

fid = fopen(DF);
raw = fread(fid,inf);
strConfig = char(raw');
EgoConfigJsonRead = jsondecode(strConfig);