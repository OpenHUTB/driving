function hFigure = helperPlotForwardVehicleSensorFusionResults(logsout)
% helperPlotForwardVehicleSensorFusionResults A helper function for
% plotting the results of the forward vehicle sensor fusion demo.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the following elements to be plotted.

% Copyright 2020 The MathWorks, Inc.

%% Get the data from simulation

% GOSPA
GOSPA = logsout.getElement('gospa');                                 

% falseTrack
falseTrack = logsout.getElement('false_tracks_error');                        

% localization
localization = logsout.getElement('localization_error');

% missTarget
missTarget = logsout.getElement('miss_target_error');

% simulation time
tmax = GOSPA.Values.time(end);                                              

%% Plot the results
hFigure = figure('Name','Forward Vehicle Sensor Fusion Metrics','position',[100 100 720 600]);

%% GOSPA metric
subplot(4,1,1)
plot(GOSPA.Values.time, GOSPA.Values.Data(:,:)','b');
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('GOSPA')
xlabel('time (sec)')
ylabel('$value$','Interpreter','latex')

%% falseTrack 
subplot(4,1,2)
plot(falseTrack.Values.time,falseTrack.Values.Data(:,:)','b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('falseTrack')
xlabel('time (sec)')
ylabel('$value$','Interpreter','latex')

%% localization
subplot(4,1,3)
plot(localization.Values.time,localization.Values.Data(:,:)','b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('localization')
xlabel('time (sec)')
ylabel('$value$','Interpreter','latex')

%% missTarget
subplot(4,1,4)
plot(missTarget.Values.time,missTarget.Values.Data(:,:)','b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('missTarget')
xlabel('time (sec)')
ylabel('$value$','Interpreter','latex')
end
