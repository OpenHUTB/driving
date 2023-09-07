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
SampleTime = 0.05;
StopTime = SampleTime*2000;

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
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic()

if display
    close all
    highwayEnv.create_chase_visualization('ego01')
    highwayEnv.create_random_visualization(ViewHeight=500,ViewPitch=90);

    traci.gui.trackVehicle('View #0', 'ego01')
    traci.gui.setZoom('View #0', 2200)
end

%% Add continuous controller test
% Add vehicle motion
% include waypoints
waypoints = [500 0;
               750 6;
               1000 -6
               2000 4];
speed = 30;
% Initialize variables
egoInitialLocation = egos{1}.states.Position';
waypoints(1,:) = egoInitialLocation;
egoGoal = waypoints(end,:);
initialOrientation = egos{1}.states.Heading;
egoCurrentPose = [egoInitialLocation, initialOrientation]';

% Define a smooth trajectory
smoothTrajectory( egos{1}.Vehicle, waypoints, speed);

%% Update Environment
isRunning = true;
tic
count = 1;
while (isRunning)   
    % Display orientation
    % fprintf('Heading:\t %d \t Position: %d \t %d \n',egos{1}.states.Heading, egos{1}.states.Position(1), egos{1}.states.Position(2))
    % Advance simulation
    isRunning = highwayEnv.step;
    % Make simulation seem smoother
    dt = toc;
    if highwayEnv.Scenario.SampleTime-dt > 0 && display
        pause(highwayEnv.SampleTime-dt);
    end
    count = count+1;
    tic
end

traci.close