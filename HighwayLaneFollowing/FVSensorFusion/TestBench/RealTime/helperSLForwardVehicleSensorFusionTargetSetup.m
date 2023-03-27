function helperSLForwardVehicleSensorFusionTargetSetup
%helperSLForwardVehicleSensorFusionTargetSetup creates data required for
% the RTForwardVehicleSensorFusionTarget.slx model

%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2021 The MathWorks, Inc.

%% Tracking and sensor fusion parameters
assignin('base', 'Epsilon',        2.5);      % Distance for clustering
assignin('base', 'MinNumPoints',   2);        % Minimum number of points required for clustering
assignin('base', 'assigThresh',  400);        % Tracker assignment threshold
assignin('base', 'M',              3);        % Tracker M value for M-out-of-N logic
assignin('base', 'N',              4);        % Tracker N value for M-out-of-N logic
assignin('base', 'P',              4);        % Tracker P value for P-out-of-R logic
assignin('base', 'R',              5);        % Tracker R value for P-out-of-R logic
assignin('base', 'numTracks',    100);        % Maximum number of tracks
assignin('base', 'numSensors',     2);        % Maximum number of sensors

%% General model parameters
assignin('base','Ts',0.1);                   % Algorithm sample time  (s)

%% Bus creation
evalin('base','helperCreateFVSFTargetBusObjects');

%% UDP interface params
try
    [~] = evalin('base', 'maxNumVisionDets');
catch
    assignin('base', 'maxNumVisionDets', 20);
end
try
    [~] = evalin('base', 'maxNumRadarDets');
catch
    assignin('base', 'maxNumRadarDets', 50);
end
try
    [~] = evalin('base', 'maxNumTracks');
catch
    assignin('base', 'maxNumTracks', 20);
end

%% Real-Time configuration parameter
cfgObj = load('RTConfigSet.mat');
assignin('base', 'RTConfig', cfgObj.RTConfig);

end