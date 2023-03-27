function hFigure = helperPlotTrafficLightControlAndNegotiationResults(logsout, stateChangeDistance)
% helperPlotTrafficLightControlAndNegotiationResults A helper function for
% plotting the results of the traffic light negotiation  with Unreal Engine
% Visualization demo.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the following elements to be plotted:
% 1. ego_velocity
% 2. distance_to_stop_line
% 3. upcoming_traffic_light
% 4. mio_relative_distance
% 5. ego_acceleration

% Copyright 2020 The MathWorks, Inc.

%% Get the data from simulation

% longitudinal velocity of ego car
ego_long_velocity = logsout.getElement('ego_velocity');                                 

% Distance between ego vehicle and stop line of upcoming traffic light
distance_to_stop_line = logsout.getElement('distance_to_stop_line');   

% upcomingTrafficLight state
upcomingTrafficLight = logsout.getElement('upcoming_traffic_light');

% relative distance to mio (tracker)
relative_distance = logsout.getElement('mio_relative_distance');                        

% ego_acceleration
ego_acceleration = logsout.getElement('ego_acceleration');

% simulation time
tmax = ego_long_velocity.Values.time(end);                                              

%% Plot the spacing control results
hFigure = figure('Name','Spacing Control Performance','position',[100 100 720 600]);

%% Plot the states of upcoming traffic light for ego vehicle.
%
% Red state of upcoming traffic light for ego vehicle is represented by
% value 0. Yellow state is represented by value 1. Green state is
% represented by value 2. Black represents that there are no valid states
% from upcoming traffic light.
subplot(5,1,1)
for i=1:size(upcomingTrafficLight.Values.time)    
    switch upcomingTrafficLight.Values.Data(i)
        case 0 
            % Set the marker color to red.
            markerColor = 'r';    
        case 1
            % Set the marker color to yellow.
            markerColor = 'y';
        case 2
            % Set the marker color to green.
            markerColor = 'g';
        otherwise
            % Set the marker color to black.
            markerColor = 'k';
    end
    scatter(upcomingTrafficLight.Values.time(i), upcomingTrafficLight.Values.Data(i),markerColor);
    hold on;
end
grid on
xlim([0,tmax])
ylim([-0.2 2.2])
title('Traffic light state')
xlabel('time (sec)')

%% Plot the distance to traffic light stop line.
subplot(5,1,2)
plot(distance_to_stop_line.Values.time,distance_to_stop_line.Values.Data,'b')
hold on
yline(stateChangeDistance, 'r');
grid on
xlim([0,tmax])
ylim(ylim + [0 10])
yticks([10 30 60]);
legend('distance to traffic light stop line','state change distance','location','NorthEast')
title('Distance to traffic light stop line')
xlabel('time (sec)')
ylabel('$meters$','Interpreter','latex')

%% Relative longitudinal distance
subplot(5,1,3)
plot(relative_distance.Values.time,relative_distance.Values.Data,'b')
grid on
xlim([0,tmax])
ylim(ylim + [0 10])
yticks([10 30 60]);
title('Relative longitudinal distance (between ego and MIO)')
xlabel('time (sec)')
ylabel('$meters$','Interpreter','latex')

%% Ego acceleration
subplot(5,1,4)
plot(ego_acceleration.Values.time,ego_acceleration.Values.Data,'b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 2])
title('Ego acceleration')
xlabel('time (sec)')
ylabel('$m/s^2$','Interpreter','latex')

%% Ego velocity
subplot(5,1,5)
plot(ego_long_velocity.Values.time,ego_long_velocity.Values.Data,'b')
grid on
xlim([0,tmax])
ylim(ylim + [-2 10])
title('Ego Velocity')
xlabel('time (sec)')
ylabel('$m/s$','Interpreter','latex')
end
