function hFigure = helperPlotLFLateralResults(logsout)
% helperPlotLFLateralResults A helper function for plotting the lateral results
% of the lane following demo.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the elements to be plotted.

% Copyright 2018 The MathWorks, Inc.

%% Get the data from simulation
% If controller model is in SIL mode, the below signals may not be logged
% during simulation. If so, set them to empty so they will not be plotted.
[~,logsoutIndex] = find(logsout,'Name','lateral_deviation');
if isempty(logsoutIndex)
    lateral_deviation = [];
    relative_yaw_angle = [];
else
    lateral_deviation = logsout.getElement('lateral_deviation');           % lateral deviation
    relative_yaw_angle = logsout.getElement('relative_yaw_angle');         % relative yaw angle
end
steering_angle = logsout.getElement('steering_angle');                     % steering angle
left_offset = getLaneOffset(logsout.get('lane_detections').Values.Left);   % lateral offset for left lane from lane detection
right_offset = getLaneOffset(logsout.get('lane_detections').Values.Right); % lateral offset for right lane from lane detection
tmax = steering_angle.Values.time(end);                                    % simulation time

%% Plot the lane following results
hFigure = figure('Name','Lateral Control Performance','position',[835 100 720 600]);

% lane boundary
subplot(4,1,1)
plot(left_offset.Time,left_offset.Data(:),'r')
grid on
hold on
plot(right_offset.Time,right_offset.Data(:),'g')
xlim([0,tmax])
legend('detected left offset','detected right offset','location','NorthEast')
title('Detected lane boundary lateral offsets')
xlabel('time (sec)')
ylabel('lateral offset (m)')

% lateral deviation
subplot(4,1,2)
if ~isempty(lateral_deviation)
    plot(lateral_deviation.Values,'b')
    legend('lateral deviation','location','NorthEast')
    title('Lateral deviation')
else
    title('Lateral deviation (not logged)')
end
grid on
xlim([0,tmax])
ylim([-0.5,0.5])
xlabel('time (sec)')
ylabel('lateral deviation (m)')

% relative yaw angle
subplot(4,1,3)
if ~isempty(relative_yaw_angle)
    plot(relative_yaw_angle.Values,'b')
    legend('relative yaw angle','location','NorthEast')
    title('Relative yaw angle')
else
    title('Relative yaw angle (not logged)')
end
grid on
xlim([0,tmax])
ylim([-0.25,0.25])
xlabel('time (sec)')
ylabel('relative yaw angle (rad)')

% steering angle
subplot(4,1,4)
plot(steering_angle.Values.time,steering_angle.Values.Data,'b')
grid on
xlim([0,tmax])
ylim([-0.05,0.05])
legend('steering angle','location','NorthEast')
title('Steering angle')
xlabel('time (sec)')
ylabel('steering angle (rad)')

end

function offset = getLaneOffset(lane_detections)
offset = lane_detections.LateralOffset;
for n = 1:numel(offset.Time)
    % Remove offsets for undetected (zero strength) lanes
    if lane_detections.Strength.Data(n) <= 0
        offset.Data(n) = nan;
    end
end
end
