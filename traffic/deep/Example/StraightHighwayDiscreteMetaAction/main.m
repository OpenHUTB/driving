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
% Define a random number for reproducibility
rng(104294)
% Define sumo configuration file
egoConfigFile = [scenarioPath filesep 'egoConfig.json'];
trafficConfigFile = [scenarioPath filesep 'trafficConfig.json'];
sumoConfigFile = '.\highwayConfiguration.sumocfg';

cd(scenarioPath)
% Open Scenario
sc = HighwayCurved;
%% Call Environment
env = DiscreteHighwayEnvironment(sc, sumoConfigFile,egoConfigFile,trafficConfigFile, true);

%% Create Network
lgraph = create_critic_network;

%% Create DQN Agent
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
% Specify the options for the critic representation
criticOpts = rlRepresentationOptions('LearnRate',1e-03,...
    'GradientThreshold',1,...
    'UseDevice','cpu');
% Create critic representation using dnn
critic = rlQValueRepresentation(lgraph,obsInfo,actInfo,...
    'Observation',{'OccupancyGrid','VehicleStates','CurrentLane'},...
    'Action',{'VehicleDiscreteMetaAction'},criticOpts);

% Create critic representation using the specified dnn and options
agentOpts = rlDQNAgentOptions(...
    'UseDoubleDQN',false, ...    
    'TargetUpdateMethod',"periodic", ...
    'TargetUpdateFrequency',4, ...   
    'ExperienceBufferLength',1000000, ...
    'DiscountFactor',0.99, ...
    'MiniBatchSize',256,...
    'SampleTime',env.Ts);
agentOpts.EpsilonGreedyExploration.EpsilonDecay = 1e-5;

agent = rlDQNAgent(critic,agentOpts);

%% Train Agent
% Speciify training options
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',1000,...
    'MaxStepsPerEpisode',200,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeCount',...
    'StopTrainingValue',1000);

doTraining = true;

if doTraining
    % Train agent
    trainingStats = train(agent,env,trainOpts);
    % Save Agent
    save("HighwayStraightDiscreteMetaDQN.mat","agent")
else
    % Load pretrained agent
    load('HighwayStraightDiscreteMetaDQN.mat','agent')
end

% Run environment
simOptions = rlSimulationOptions('MaxSteps',300);
experience = sim(env,agent,simOptions);

traci.close