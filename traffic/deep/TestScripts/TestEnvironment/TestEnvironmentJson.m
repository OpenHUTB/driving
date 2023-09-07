%% Setup
clear all
close all
format shortG  %smaller line spacing in Command Window
import traci.constants
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
SampleTime = 0.2;
StopTime = SampleTime*100;


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

% highwayEnv.close_connection;
% Create Traffic on traffic environment
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic()


if display
    figure
    plot(scenario)
    
    highwayEnv.create_chase_visualization('ego01');
    highwayEnv.create_chase_visualization('ego02');

    traci.gui.trackVehicle('View #0', 'ego01')
    traci.gui.setZoom('View #0', 1000)
end


%% Update Environment
isRunning = true;
tic
while isRunning && ~egos{1}.HasArrived
    % Make simulation seem smoother
    dt = toc;
    isRunning = highwayEnv.step;
    if highwayEnv.Scenario.SampleTime-dt > 0 && display
        pause(highwayEnv.SampleTime-dt);
    end
end

% Create Traffic on traffic environment
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic();

%% Update Environment
isRunning = true;
tic
while isRunning && ~egos{1}.HasArrived
    % Make simulation seem smoother
    dt = toc;
    isRunning = highwayEnv.step;

    if highwayEnv.Scenario.SampleTime-dt > 0 && display
        pause(highwayEnv.SampleTime-dt);
    end
    
end

% Create Traffic on traffic environment
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic();

%% Update Environment
isRunning = true;
tic
while isRunning && ~egos{1}.HasArrived
    % Make simulation seem smoother
    dt = toc;
    isRunning = highwayEnv.step;

    if highwayEnv.Scenario.SampleTime-dt > 0 && display
        pause(highwayEnv.SampleTime-dt);
    end
    
end
highwayEnv.close_connection;