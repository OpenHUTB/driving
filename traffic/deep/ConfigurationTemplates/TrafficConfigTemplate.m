% Create hierarchical structure for JSON file creation (Sample Template)
clear all
clc
%%
% *%% Traffic Vehicle Parameters*
TrafficConfig = struct();
TrafficConfig.VehicleType = 'DEFAULT_VEHTYPE';                             % (required) Options: 'DEFAULT_VEHTYPE', Sumo defaults (https://sumo.dlr.de/docs/Vehicle_Type_Parameter_Defaults.html)
TrafficConfig.NumberVehicles = 10;                                         % (Required if RandomTraffic = false) Integer greater than 0
TrafficConfig.RandomTraffic = true;                                       % (Required) Default = false
TrafficConfig.BoundsRandomTraffic = [1 15];                               % (required if RandomTraffic True) Default: [1 200]
% Spawn options for traffic vehicles
TrafficConfig.SpawnOptions = struct();                                     % (Required)
%% 
% To understand options for spawnoptions, please refer to 
% <https://sumo.dlr.de/docs/Definition_of_Vehicles%2C_Vehicle_Types%2C_and_Routes.html#departlane>
TrafficConfig.SpawnOptions.departLane = 'random';                          % (Optional) Options: {≥0, 'random', 'free', 'allowed', 'best', 'first'} Default = 'random' 
TrafficConfig.SpawnOptions.departPos = 'random_free';                      % (Optional) Options: {≥0, 'random', 'free', 'random_free', 'base', 'last', 'stop'} Default = 'random' 
TrafficConfig.SpawnOptions.departSpeed = 'random';                         % (Optional) Options: {≥0, 'random', 'free', 'max', 'desired', 'speedLimit'} Default = 'random' 
TrafficConfig.SpawnOptions.arrivalLane = 'random';                         % (Optional) Options: {≥0, 'random', 'current', 'first'} Default = 'random'
TrafficConfig.SpawnOptions.arrivalPos  = 'max';                            % (Optional) Options: {<FLOAT>, 'random', 'max'} Default = 'random'
TrafficConfig.SpawnOptions.arrivalSpeed = 'random';                        % (Optional) Options: {≥0, 'current', 'max', 'random'} Default = 'random'

%% Generate  Ego Configuration

jsonStr = jsonencode(TrafficConfig,'PrettyPrint',true);
DF = 'trafficConfig.json';
fid = fopen(DF, 'w');
if fid == -1, error('Cannot create JSON file'); end
fwrite(fid, jsonStr, 'char');
fclose(fid);

fid = fopen(DF);
raw = fread(fid,inf);
strConfig = char(raw');
traffic_config = jsondecode(strConfig);