% Moves required files to fix issues with add function from traci4matlab

% Check if submodules exist inside lib/External folder
if not(isfolder("../lib/External/traci4matlab"))
    error('traci4matlab submodule does not exist, please run "git submodule init"')
end

% modify add file on traci4matlab vehicle package
if ~copyfile('../lib/add.m',...
        '../lib/External/traci4matlab/+traci/+vehicle/','f')
    error('could not move file to destination folder')
else
    disp('Successfully moved function to destination folder')
end

if ~copyfile('../lib/changeLane.m',...
        '../lib/External/traci4matlab/+traci/+vehicle/','f')
    error('could not move file to destination folder')
else
    disp('Successfully moved function to destination folder')
end

if ~copyfile('../lib/add.m',...
        '../lib/External/traci4matlab/+traci/+vehicle/','f')
    error('could not move file to destination folder')
else
    disp('Successfully moved function to destination folder')
end

% Add all libraries to path
cd ../
% Add library to path
addpath(genpath('./lib'))
addpath(genpath('./env'))
javaaddpath('./lib/External/traci4matlab/traci4matlab.jar')
disp('done')