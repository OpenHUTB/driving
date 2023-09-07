%% Setup
clear all
close all
format shortG  %smaller line spacing in Command Window
clc %clears the Command Window
[scenarioPath,~,~] = fileparts(which(mfilename));
cd ../..
% Add library to path
addpath(genpath('./lib'))
addpath(genpath('./env'))
javaaddpath('./lib/External/traci4matlab/traci4matlab.jar')
% Define a random number with different seeds
rng('shuffle')
% Define sumo configuration file
egoConfigFile = [scenarioPath filesep 'egoConfig.json'];
trafficConfigFile = [scenarioPath filesep 'trafficConfig.json'];
sumoConfigFile = '.\highwayConfiguration.sumocfg';
% Define if gui
display = true;
% Define Simulation parameters
SampleTime = 0.01;
StopTime = SampleTime*5000;

%% Initialization
% Load Highway Scenario environment
scenario = HighwayStraight();
% Initialize traffic environmenttraci.
highwayEnv = TrafficEnvironment(scenario, ...
    sumoConfigFile, ...
    egoConfigFile,...
    trafficConfigFile,...
    StopTime,...
    'SampleTime', SampleTime,...
    'SumoVisualization', true);

% Create Traffic on traffic environment
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic();

%% Create top view Visualization
if display
    highwayEnv.create_chase_visualization('ego01')
    traci.gui.trackVehicle('View #0', 'ego01')
    traci.gui.setZoom('View #0', 2200)
end

%% Test Commands
isRunning = true;
tic
           
% MetaActions = {...
%   1: 'LANE_LEFT', ...
%   2: 'LANE_RIGHT', ...
%   3: 'ACCELERATE', ...
%   4: 'DECELERATE',...
%   5: 'KEEP_SPEED'}
% -------------------------------------------------------------------------
% Accelerate
% -------------------------------------------------------------------------
cmd = 3;
% Extract current speed
vel_k_1 = egos{1}.states.Velocity;
% send command
for i = 1:2000
    egos{1}.step(cmd);
    % Advance simulation
    highwayEnv.step;
    vel_k = egos{1}.states.Velocity;
    % Perform check
    assert(vel_k(1)>vel_k_1(1),'Vehicle has not increased speed')
    % advance one step
    veh_k_1 = vel_k;
end
disp('Acceleration check... pass')
% -------------------------------------------------------------------------
% decelerate
% -------------------------------------------------------------------------
cmd = 4;
% Extract current speed
vel_k_1 = egos{1}.states.Velocity;
% send command
for i = 1:200
    egos{1}.step(cmd);
    % Advance simulation
    highwayEnv.step;
    % Extract current velocity
    vel_k = egos{1}.states.Velocity;
    % Perform check
    assert(vel_k(1)<vel_k_1(1),'Vehicle has not decreased speed')
    % advance one step
    veh_k_1 = vel_k;
end

assert(vel_k(1)<vel_k_1(1),'Vehicle has not decreased speed')
disp('Deceleration check... pass')
% -------------------------------------------------------------------------
% Change left lane
% -------------------------------------------------------------------------
cmd = 1;
% Extract current speed
lane_k_1 = egos{1}.CurrentLane;
% send command
for i = 1:300
    egos{1}.step(cmd);
    % Advance simulation
    highwayEnv.step;
end
lane_k = egos{1}.CurrentLane;

assert(lane_k<=lane_k_1,'Vehicle has not changed lanes left')
disp('Left lane change check... pass')

% -------------------------------------------------------------------------
% Change right lane
% -------------------------------------------------------------------------
cmd = 2;
% Extract current speed
lane_k_1 = egos{1}.CurrentLane;
% send command
for i = 1:300
    egos{1}.step(cmd);
    % Advance simulation
    highwayEnv.step;
end
lane_k = egos{1}.CurrentLane;

assert(lane_k>=lane_k_1,'Vehicle has not changed lanes right')
disp('Right lane change check... pass')
traci.close