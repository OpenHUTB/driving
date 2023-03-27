function hFigure = helperPlotLFLongitudinalResults(logsout,time_gap,default_spacing)
% plotLFLongitudinalResults A helper function for plotting the longitudinal
% results of the lane following demo.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the following elements to be plotted.

% Copyright 2018-2021 The MathWorks, Inc.

%% Get the data from simulation
ego_long_velocity = logsout.getElement('ego_velocity');                             % longitudinal velocity of ego car
relative_distance = logsout.getElement('relative_distance');                        % relative distance to mio (tracker)
relative_distance.Values.Data(relative_distance.Values.Data == 10000) = inf;        % handle invalid case
relative_distance_truth = logsout.getElement('mio_relative_long_distance_truth');   % relative distance to mio (truth)
safe_distance = (ego_long_velocity.Values.Data*time_gap) + default_spacing;         % safe_distance to mio

relative_velocity = logsout.getElement('relative_velocity');                        % relative mio velocity measurement (tracker)
relative_velocity.Values.data(relative_velocity.Values.data == 10000) = inf;        % handle invalid case
relative_velocity_truth = logsout.getElement('mio_relative_long_velocity_truth');   % relative mio velocity measurement (truth)

ego_long_acceleration = logsout.getElement('ego_acceleration');                     % longitudinal acceleration of ego car (controller)
ego_long_acceleration_truth = logsout.getElement('longitudinal_acceleration');      % longitudinal acceleration of ego car (truth)

set_velocity = logsout.getElement('set_velocity');                                  % driver-set velocity
[mio_abs_velocity,mio_velocity_time] = mioAbsoluteVelocity(...                      % velocity of mio
    logsout.getElement('target_vehicle_poses'),...
    logsout.getElement('mio_index_truth'));

tmax = ego_long_velocity.Values.time(end);                                          % simulation time

%% Plot the spacing control results
hFigure = figure('Name','Spacing Control Performance','position',[100 100 720 600]);


% relative distance
subplot(4,1,1)
plot(relative_distance.Values.time,relative_distance.Values.Data,'b')
hold on
plot(relative_distance_truth.Values.time,relative_distance_truth.Values.data,'b--')
hold on
plot(ego_long_velocity.Values.time,safe_distance,'r')
grid on
xlim([0,tmax])
legend('tracker','truth','safe distance','location','SouthWest')
title('Relative longitudinal distance (between ego and MIO)')
xlabel('time (sec)')
ylabel('m')

% relative velocity
subplot(4,1,2)
plot(relative_velocity.Values.time,relative_velocity.Values.data,'b')
hold on
plot(relative_velocity_truth.Values.time,relative_velocity_truth.Values.data,'b--')
xlim([0,tmax])
grid on
legend('tracker','truth','location','SouthWest')
title('Relative longitudinal velocity (between ego and MIO)')
xlabel('time (sec)')
ylabel('m/s')

% ego acceleration
subplot(4,1,3)
plot(ego_long_acceleration.Values.time,ego_long_acceleration.Values.Data,'r')
hold on
plot(ego_long_acceleration_truth.Values.time,ego_long_acceleration_truth.Values.Data,'r--')
hold on
grid on
xlim([0,tmax])
ylim([-3.5,2.2])
legend('ego acceleration','ego truth','location','SouthWest')
title('Absolute acceleration')
xlabel('time (sec)')
ylabel('$m/s^2$','Interpreter','latex')

% ego velocity
subplot(4,1,4)
plot(set_velocity.Values.time,set_velocity.Values.Data,'k--')
hold on
plot(ego_long_velocity.Values.time,ego_long_velocity.Values.Data,'r')
hold on
plot(mio_velocity_time,mio_abs_velocity,'b');
xlim([0,tmax])
ylim(ylim + [-2 2])
grid on
legend('ego set velocity','ego truth','mio truth','location','SouthWest')
title('Absolute velocity')
xlabel('time (sec)')
ylabel('m/s')
end

function [mioVel,time] = mioAbsoluteVelocity(target_vehicle_pose,mio_index_truth)
    time = target_vehicle_pose.Values.Actors(1).Velocity.Time;
    mioVel = nan(size(time));
    for n = 1:numel(time)
        mioIndex = mio_index_truth.Values.Data(n,1);
        if ~isnan(mioIndex)
            mioVel(n) = hypot(...
                target_vehicle_pose.Values.Actors(mioIndex).Velocity.Data(:,1,n),...
                target_vehicle_pose.Values.Actors(mioIndex).Velocity.Data(:,2,n));
        end
    end
end

