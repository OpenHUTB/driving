function helperPlotAEBResults(logsout, scenarioFcnName)
%helperPlotAEBResults A helper function for plotting the results of the AEB
% example
%   This is a helper function for example purposes and may be removed or
%   modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing several signals.

% Copyright 2018-2022 The MathWorks, Inc.

if nargin < 2
    scenarioFcnName = '';
end


%% Get the data from simulation
ttc = logsout.getElement('TTC'); % TTC : time-to-collision
FCWtime = logsout.getElement('FCWstoppingTime'); % stopping times
PB1time = logsout.getElement('PB1stoppingTime');
PB2time = logsout.getElement('PB2stoppingTime');
FBtime  = logsout.getElement('FBstoppingTime');


FCWactivate = logsout.getElement('fcw_activate'); % AEB status flags
AEBstatus = logsout.getElement('aeb_status');
collision = logsout.getElement('collision');
egoCarStop = logsout.getElement('ego_car_stop');

longitudinalAcceleration = logsout.getElement('<ax>');  % longitudinal acceleration of ego car
lateralAcceleration = logsout.getElement('<ay>');  % lateral acceleration of ego car

yaw = logsout.getElement('yaw'); % ego yaw rate
yawRate = logsout.getElement('yaw_rate'); % ego yaw rate

ego_velocity = logsout.getElement('ego_velocity'); % velocity of ego car
driver_set_velocity = logsout.getElement('driver_set_velocity'); % driver-set velocity

headway = logsout.getElement('headway'); % headway between ego car and MIO

collisionMitigation = logsout.getElement('collisionMitigation'); % collision mitigation

TTC = ttc.Values.Data;
TTC(TTC>1000) = inf;
tTTC = ttc.Values.time;

HW = headway.Values.Data;
HW(HW>=490) = inf;
tHW = headway.Values.time;

%% Plot the results
figure('position',[100 100 720 600]);
set(gcf,'Numbertitle','off');
set(gcf,'Name','AEB Simulation Result');

% TTC vs. stopping times
ax(1) = subplot(6,1,1);
hold on;
plot(FCWtime.Values.time,FCWtime.Values.Data,'c');
plot(PB1time.Values.time,PB1time.Values.Data,'g');
plot(PB2time.Values.time,PB2time.Values.Data,'m');
plot(FBtime.Values.time, FBtime.Values.Data, 'r');
plot(tTTC,TTC,'b','LineWidth',2);
tmax = round(max(FCWtime.Values.Data))+0.5;
ylim([0,tmax]);
xlim([0, ttc.Values.time(end)]);
legend({'FCWStoptime','PB1Stoptime','PB2Stoptime','FBStoptime','TTC'},...
    'Location','northwest',...
    'FontName','Arial',...
    'FontSize',6);
msg = sprintf('%s (Collision Mitigation: %.1f%%)\nTTC vs. Stopping Time', scenarioFcnName,collisionMitigation.Values.Data(end));
title(msg,'Interpreter','none')
ylabel('sec')
grid on;

% AEBstatus flags
ax(2) = subplot(6,1,2);
hold on;
stairs(FCWactivate.Values.time,FCWactivate.Values.Data,'m','LineWidth',1.5);
stairs(AEBstatus.Values.time,AEBstatus.Values.Data,'b','LineWidth',2);
stairs(collision.Values.time,collision.Values.Data,'r');
stairs(egoCarStop.Values.time,egoCarStop.Values.Data,'g');
legend({'FCWactivate','AEBstatus','collision','egoCarStop'},...
    'Location','northwest',...
    'FontName','Arial',...    
    'FontSize',6);
xlim([0, egoCarStop.Values.time(end)]);
title('FCW and AEB Status (0:NoAEB, 1:PB1, 2:PB2, 3:FB)')
ylabel('Status')
grid on;

% longitudinal and lateral acceleration
ax(3) = subplot(6,1,3);
hold on;
plot(longitudinalAcceleration.Values.time,longitudinalAcceleration.Values.Data,'b','LineWidth',2);
plot(lateralAcceleration.Values.time,lateralAcceleration.Values.Data, 'm' , 'LineWidth', 2);
xlim([0, longitudinalAcceleration.Values.time(end)]);
legend({'Longitudinal Acceleration','Lateral Acceleration'},...
    'Location','northwest',...
    'FontName','Arial',...    
    'FontSize',6);
title('Ego Car Acceleration');
ylabel('g');
grid on;

% yaw and yaw rate
ax(3) = subplot(6,1,4);
hold on;
plot(yaw.Values.time,yaw.Values.Data,'m','LineWidth',2);
plot(yawRate.Values.time,yawRate.Values.Data,'b','LineWidth',2);
legend({'Yaw','Yaw Rate'},...
    'Location','northwest',...
    'FontName','Arial',...    
    'FontSize',6);

xlim([0, yawRate.Values.time(end)]);
title('Ego Car Yaw and Yaw Rate');
ylabel('deg');
grid on;

% ego velocity
ax(4) = subplot(6,1,5);
hold on;
plot(ego_velocity.Values.time,ego_velocity.Values.Data,'b','LineWidth',2);
plot(ego_velocity.Values.time,ones(size(ego_velocity.Values.time)) * driver_set_velocity.Values.Data(1), 'r--');
ylim([0, inf]);
xlim([0, ego_velocity.Values.time(end)]);
legend({'ego velocity','set velocity'},...
    'Location','best',...
    'FontName','Arial',...    
    'FontSize',6);
title('Ego Car Velocity')
ylabel('m/s')
grid on;

% headway
ax(5) = subplot(6,1,6);
hold on;
plot(tHW,HW,'b','LineWidth',2);
ylim([0,inf]);
xlim([0, headway.Values.time(end)]);
title('Headway')
xlabel('time (sec)')
ylabel('meter')
grid on;

linkaxes(ax,'x');
