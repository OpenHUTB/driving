clear
close all
clc

%% Parameter Setup
% Specify input network file (open drive .xodr file)
scenario_fldr = '../env/merge/';
opendrive_file = 'scenario.xodr';
opendrivePath = [scenario_fldr, opendrive_file];
% Specify network file
net_file = [ scenario_fldr,'network.net.xml'];

%% Generate network file using netedit
fprintf("Generating Network files ... \n")
% Define netconvert arguments
NET_ARGS = strcat(" --opendrive ",opendrivePath," -o ",net_file, " --offset.disable-normalization true --ramps.guess true");
% call netconvert
command = strcat('netconvert' ,NET_ARGS);
status = system(command,'-echo');

%% Open NETEDIT for network route creation
fprintf("Opening Netedit for demand configuration ... \n")
fprintf("Please create a route demand, this can be done using netedit, or manually. Please refer to SUMO documentation \n")
command = strcat("netedit " ,net_file);
% open netedit
status = system(command,'-echo');
% check if route file has been created
cd(scenario_fldr)
if isempty(dir('*.rou.xml'))
   error('Route file with extension .rou.xml has not been found, please create route file.') 
else
    fprintf("Success \n")
end