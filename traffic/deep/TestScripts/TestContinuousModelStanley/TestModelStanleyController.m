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
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic();

%% Create top view Visualization
if display
    close all
    highwayEnv.create_chase_visualization('ego01')
    traci.gui.trackVehicle('View #0', 'ego01')
    traci.gui.setZoom('View #0', 2200)
end
%% Add continuous controller test
% Add vehicle motion
% include waypoints
refPose = [1500 -2.5 0];
currVelocity = 20;
% Initialize variables
egoInitialLocation = egos{1}.states.Position';
initialOrientation = egos{1}.states.Heading;
currPose = [egoInitialLocation, initialOrientation*180/pi];

%% Update Environment
isRunning = true;
tic
count = 1;
while (isRunning)   
    % Conpute Ego Current Pose
    steerCmd = lateralControllerStanley(refPose,currPose,currVelocity,'Direction',1);
    
    % Command steering angle
    egos{1}.step([currVelocity, steerCmd*pi/180]);   
    % Advance simulation
    isRunning = highwayEnv.step;
    % Perform pose update
    egoInitialLocation = egos{1}.states.Position';
    initialOrientation = egos{1}.states.Heading;
    currPose = [egoInitialLocation, initialOrientation*180/pi];
    % Make simulation seem smoother
    dt = toc;
    if highwayEnv.Scenario.SampleTime-dt > 0 && display
        pause(highwayEnv.SampleTime-dt);
    end
    count = count+1;
    tic
end

traci.close