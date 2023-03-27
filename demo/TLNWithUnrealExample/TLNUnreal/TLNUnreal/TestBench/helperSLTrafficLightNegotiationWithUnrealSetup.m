function helperSLTrafficLightNegotiationWithUnrealSetup(varargin)
%helperSLTrafficLightNegotiationWithUnrealSetup creates data for Traffic
%Light Negotiation with Unreal Engine Visualization Example.
%
%   helperSLTrafficLightNegotiationWithUnrealSetup PostLoadFcn callback for
%   TLNWithUnrealTestBench.slx.
%   helperSLTrafficLightNegotiationWithUnrealSetup(scenarioFcnName) initializes
%   model configuration parameters, workspace variables and Simulink bus
%   objects for
%   TLNWithUnrealTestBench.slx model for
%   the test scenario defined by "scenarioFcnName".
%
%   scenarioFcnName: - Name of function which returns scenario which is
%                      compatible with
%                      TLNWithUnrealTestBench.slx
%                      - Valid values are:
%                          "scenario_01_TLN_left_redToGreen_with_lead_vehicle"
%                          "scenario_02_TLN_straight_greenToRed" 
%                          "scenario_03_TLN_straight_greenToRed_with_lead_vehicle" [Default]
%                          "scenario_04_TLN_straight_redToGreen_with_cross_vehicle"

%
%   Examples of calling this function:
%   -----------------------------------
%
%   helperSLTrafficLightNegotiationWithUnrealSetup("scenario_01_TLN_left_redToGreen_with_lead_vehicle");
%   helperSLTrafficLightNegotiationWithUnrealSetup("scenario_02_TLN_straight_greenToRed");
%   helperSLTrafficLightNegotiationWithUnrealSetup("scenario_03_TLN_straight_greenToRed_with_lead_vehicle");
%   helperSLTrafficLightNegotiationWithUnrealSetup("scenario_04_TLN_straight_redToGreen_with_cross_vehicle");

%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2020-2021 The MathWorks, Inc.

%% Inputs

% Scenario function name
defaultScenarioFcnName = "scenario_03_TLN_straight_greenToRed_with_lead_vehicle";

% Load the Simulink model
modelName = 'TLNWithUnrealTestBench';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end

% List of valid scenario function names
validScenarioFcnNames = [...
    "scenario_01_TLN_left_redToGreen_with_lead_vehicle", ...
    "scenario_02_TLN_straight_greenToRed", ...
    "scenario_03_TLN_straight_greenToRed_with_lead_vehicle", ...
    "scenario_04_TLN_straight_redToGreen_with_cross_vehicle"
    ];
checkScenarioFncName = @(x) any(strcmp(x,validScenarioFcnNames));

% Parse inputs
p = inputParser;
addOptional(p,'ScenarioFcnName',defaultScenarioFcnName,checkScenarioFncName);
parse(p,varargin{:});
scenarioFcnName = p.Results.ScenarioFcnName;

% Distance from ego vehicle at which vehicle should fall back to
% reference path near intersection.
referencePathSwitchThreshold = 20;
assignin('base','referencePathSwitchThreshold',referencePathSwitchThreshold);

% Maximum distance for a track to be selected as a "most important track".
maxMIOLeadDistance = 40;
assignin('base','maxMIOLeadDistance',maxMIOLeadDistance);

%% Scenario parameters
% Set random seed to ensure reproducibility.
rng(0);

% Call scenario function
scenarioFcnHandle = str2func(scenarioFcnName);
[scenario, egoVehicle, referencePathInfo, intersectionInfo, trafficLightConfig] = scenarioFcnHandle();

%% Scenario parameters
% Driving scenario
assignin('base', 'scenario', scenario); 
assignin('base', 'egoVehicle', egoVehicle);
assignin('base', 'egoActorID', egoVehicle.ActorID);

% Reference path information
assignin('base', 'referencePathInfo', referencePathInfo);
% Intersection information
assignin('base', 'intersectionInfo', intersectionInfo);
% traffic light information
assignin('base', 'trafficLightConfig', trafficLightConfig);


%% Vehicle parameters
egoVehDyn = egoVehicleDynamicsParams(egoVehicle);
assignin('base', 'egoVehDyn', egoVehDyn);
assignin('base', 'vehSim3D',  vehicleSim3DParams(scenario));
assignin('base','vehicleLength',egoVehicle.Length);

%% General model parameters

% Algorithm sample time  (s)
assignin('base', 'Ts', 0.1);
% Set velocity (m/s)
assignin('base', 'setVelocity', egoVehDyn.VLong0);

%% Path following controller parameters

% Time constant for longitudinal dynamics 1/s/(tau*s+1)
assignin('base', 'tau', 0.05);
% Longitudinal time constant (brake)             (N/A)
assignin('base', 'tau2', 0.07);
% Time gap               (s)
assignin('base', 'time_gap', 1.5);
% Default spacing        (m)
assignin('base', 'default_spacing', 10);
% Maximum acceleration   (m/s^2)
assignin('base', 'max_ac', 2);
% Maximum deceleration   (m/s^2)
assignin('base', 'max_dc', -10);
% Minimum acceleration   (m/s^2)
assignin('base', 'min_ac', -3);
% Maximum steering       (rad)
assignin('base', 'max_steer', 0.79);
% Minimum steering       (rad)
assignin('base', 'min_steer', -0.79);
% Prediction horizon
assignin('base', 'PredictionHorizon', 30);
% Control horizon
assignin('base', 'ControlHorizon', 2);
% Initial longitudinal velocity (m/s)
assignin('base', 'v0_ego', egoVehDyn.VLong0);

%% Watchdog Braking controller parameters
% 1st stage Partial Braking deceleration (m/s^2)
assignin('base', 'PB1_decel',       3.8);
% 2nd stage Partial Braking deceleration (m/s^2)
assignin('base', 'PB2_decel',       5.3);
% full Braking deceleration              (m/s^2)
assignin('base', 'FB_decel',        9.8);
% headway offset                         (m)
assignin('base', 'headwayOffset',   3.7);
% time Margin                            (sec)
assignin('base', 'timeMargin',      0);
% driver reaction time                   (sec)
assignin('base', 'timeToReact',     1.2);
% driver braking deceleration            (m/s^2)
assignin('base', 'driver_decel',    4.0);
% Default deceleration                  (m/s^2)
assignin('base','Default_decel', 0);          
% Time factor                           (sec)
assignin('base','TimeFactor', 1.2);            
% Velocity threshold for stopping ego vehicle (m/s)
assignin('base','stopVelThreshold', 0.1);      

%% Tracking and sensor fusion parameters

% Tracker assignment threshold          (N/A)
assignin('base','assigThresh',  50);
% Tracker M value for M-out-of-N logic  (N/A)
assignin('base','M',            2);
% Tracker N value for M-out-of-N logic  (N/A)
assignin('base','N',            3);
% Maximum number of tracks              (N/A)
assignin('base','numTracks',    100);
% Maximum number of sensors             (N/A)
assignin('base','numSensors',   2);

% Position and velocity selectors from track state
% The filter initialization function used in this example is initcvekf that
% defines a state that is: [x;vx;y;vy;z;vz].
assignin('base','posSelector', [1,0,0,0,0,0; 0,0,1,0,0,0]); % Position selector   (N/A)
assignin('base','velSelector', [0,1,0,0,0,0; 0,0,0,1,0,0]); % Velocity selector   (N/A)

%% Dynamics modeling parameters

% Total mass of vehicle                          (kg)
assignin('base','m',  1575);
% Yaw moment of inertia of vehicle               (m*N*s^2)
assignin('base','Iz', 2875);
% Cornering stiffness of front tires             (N/rad)
assignin('base','Cf', 19000);
% Cornering stiffness of rear tires              (N/rad)
assignin('base','Cr', 33000);
% Longitudinal distance from c.g. to front tires (m)
assignin('base','lf', egoVehDyn.CGToFrontAxle);
% Longitudinal distance from c.g. to rear tires  (m)
assignin('base','lr', egoVehDyn.CGToRearAxle);

%% Bus Creation
evalin('base','helperSLCreateTLNWithUnrealUtilityBus');

% Create bus for multi-object tracker
blk = [modelName,'/Sensors and Environment/Tracking and Sensor Fusion/Multi-Object Tracker'];
multiObjectTracker.createBus(blk);

end

function egoVehDyn = egoVehicleDynamicsParams(ego)
%Update the initial vehicle parameters for the vehicle dynamics block.

% Get the ego actor from the scenario. The ego actor ID is 67 in this
% scenario.
% Translate to SAE J670E (North-East-Down)
% Adjust sign of y position
egoVehDyn.X0  =  ego.Position(1); % (m)
egoVehDyn.Y0  = -ego.Position(2); % (m)
egoVehDyn.VX0 =  ego.Velocity(1); % (m)
egoVehDyn.VY0 = -ego.Velocity(2); % (m)

% Adjust sign and unit of yaw
egoVehDyn.Yaw0 = -deg2rad(ego.Yaw); % (rad)

% Longitudinal velocity
egoVehDyn.VLong0 = hypot(egoVehDyn.VX0,egoVehDyn.VY0); % (m/sec)

% Distance from center of gravity to axles
egoVehDyn.CGToFrontAxle = ego.Length/2 - ego.FrontOverhang;
egoVehDyn.CGToRearAxle  = ego.Length/2 - ego.RearOverhang;

end

function vehSim3D = vehicleSim3DParams(scenario)
% VehicleSim3DParams vehicle parameters used by Sim 3D

% To know number of vehicle actors in the scenario, loop over each actor
% and check if it belongs to vehicle class.

% Get num of actors in the scenario.
numActors = numel(scenario.Actors);
% initialize the numVehicles to zero.
numVehicles = 0;
% Initialize the vehicleActors with zero.
vehicleActors = zeros(1);
% Initialize the vehicle actor IDs with 1
vehicleActorIDs = 1;
% Loop through each actor to find if it is a vehicle.
for i = 1:numActors
    % Check if each actor belongs to vehicle class.
    if(class(scenario.Actors(i)) == "driving.scenario.Vehicle")
        % Increment the numVehicle
        numVehicles = numVehicles + 1;
        % Store the actor index in vehicle actors array.
        vehicleActors(vehicleActorIDs) = i;
        % Increment the vehicleActorIDs variable.
        vehicleActorIDs = vehicleActorIDs +1;
    end
end

% Preallocate struct
vehSim3D = repmat(...
    struct(...
    'Length', 0,...
    'InitialPos',[0 0 0],... 
    'InitialRot',[0 0 0]),...
    numVehicles,1);

for n = 1:numVehicles
    % Vehicle information from driving scenario
    veh = scenario.Actors(vehicleActors(n));
    
    % Translate from rear axle (driving scenario) to vehicle center (Sim3D)
    % - Offset position along its orientation by -rearOverhang + length/2.
    positionVehicleCenter = driving.scenario.internal.Utilities.translateVehiclePosition(...
        veh.Position,...     % Position with respect to rear axle (m)
        0,...                % veh.RearOverhang,... % (m)
        veh.Length,...       % (m)
        veh.Roll,...         % (deg)
        veh.Pitch,...        % (deg)
        veh.Yaw);            % (deg)
    
    % Update struct elements
    vehSim3D(n).Length = veh.Length;
    vehSim3D(n).RearOverhang = 0 ;
    vehSim3D(n).InitialPos = positionVehicleCenter;
    vehSim3D(n).InitialRot = [veh.Roll veh.Pitch veh.Yaw];
end
end
