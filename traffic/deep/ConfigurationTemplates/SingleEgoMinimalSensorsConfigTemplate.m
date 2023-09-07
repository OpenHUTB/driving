% Create hierarchical structure for JSON file creation (Sample Template)
clear all
clc
%%
% *%% Ego Vehicle Parameters*
EgoConfig = struct();
EgoConfig.NumberEgos = 1;
%%
% _Ego1_
EgoConfig.Ego(1).Name = 'ego01';                                           %(required)
EgoConfig.Ego(1).ModelType = 'SUMO';                                    %(optional) Options: 'Bicycle', 'SUMO' Default: SUMO
EgoConfig.Ego(1).ActionType = 'Discrete-MetaAction';                                %(optional) Options: 'Discrete-MetaAction', 'Discrete', 'Continuous' Default: 'Discrete-MetaAction'
EgoConfig.Ego(1).VehicleType = 'DEFAULT_VEHTYPE';                          %(required) Options: 'DEFAULT_VEHTYPE', Sumo defaults (https://sumo.dlr.de/docs/Vehicle_Type_Parameter_Defaults.html)
EgoConfig.Ego(1).Route = 'random';                                         %(required) Options:'random', routeid 
EgoConfig.Ego(1).Color = [0 1 0];                                          %(optional) Default: [0 1 0] (Green)


% _SPAWN_OPTIONS
EgoConfig.Ego(1).SpawnOptions = struct();                                  %(required) if empty defaults will be used
% To understand options for spawnoptions, please refer to 
% <https://sumo.dlr.de/docs/Definition_of_Vehicles%2C_Vehicle_Types%2C_and_Routes.html#departlane>
EgoConfig.Ego(1).SpawnOptions.departLane = 'random';                       %(Optional) Options: {≥0, 'random', 'free', 'allowed', 'best', 'first'} Default = 'random' 
EgoConfig.Ego(1).SpawnOptions.departPos = 'random_free';                   %(Optional) Options: {≥0, 'random', 'free', 'random_free', 'base', 'last', 'stop'} Default = 'random' 
EgoConfig.Ego(1).SpawnOptions.departSpeed = 'random';                      %(Optional) Options: {≥0, 'random', 'free', 'max', 'desired', 'speedLimit'} Default = 'random' 
EgoConfig.Ego(1).SpawnOptions.arrivalLane = 'random';                      %(Optional) Options: {≥0, 'random', 'current', 'first'} Default = 'random'
EgoConfig.Ego(1).SpawnOptions.arrivalPos  = 'max';                         %(Optional) Options: {<FLOAT>, 'random', 'max'} Default = 'random'
EgoConfig.Ego(1).SpawnOptions.arrivalSpeed = 'random';                     %(Optional) Options: {≥0, 'current', 'max', 'random'} Default = 'random'

% _SENSORS_
% Add Binary Occupancy Grid Observation (Ideal)
EgoConfig.Ego(1).OccupancyGrid = struct();                                 %(optional) Default = none
    EgoConfig.Ego(1).OccupancyGrid.xSize = 100;                            %(optional) Default = 100 m
    EgoConfig.Ego(1).OccupancyGrid.ySize = 100;                            %(optional) Default = 100 m   
    EgoConfig.Ego(1).OccupancyGrid.resolution = 1;                         %(optional) Default = 2  cells per m
    EgoConfig.Ego(1).OccupancyGrid.plot = true;                            %(optional) Default = false  
    EgoConfig.Ego(1).OccupancyGrid.LaneDetection = false;                   %(optional) Default = false

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
Ego_config = jsondecode(strConfig);