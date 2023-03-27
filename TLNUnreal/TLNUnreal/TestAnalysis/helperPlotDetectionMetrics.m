function hFigure = helperPlotDetectionMetrics(detectorName, logsout)
% helperPlotDetectionMetrics A helper function for plotting the vehicle
% detector metrics computed from VisionVehicleDetectorTestBench.slx.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the elements to be plotted.

% Copyright 2020-2021 The MathWorks, Inc.

%% Get the data from simulation
% Get ground truth information 
hTruth = logsout.get('vehicle_boxes_truth');

% True positives
hTruePositives = logsout.get('True Positives Boxes');

% False Negatives
hFalseNegatives = logsout.get('False Negatives Boxes');

% False positives
hFalsePositives = logsout.get('False Positives Boxes');

tmax = hTruth.Values.Time(end);

figName = strcat(detectorName, ' Vehicle Detector Metrics'); 

%% Plot vehicle detection metrics
hFigure = figure('Name', figName, 'position', [835 100 720 600]);

%% Plot the number of vehicles in ground truth
subplot(4, 1, 1)
for i=1:size(hTruth.Values.Data,3)
    currBBox = hTruth.Values.Data(:, :, i);
    currBBox = currBBox(any(currBBox,2),:);
    numVehicles(i) = size(currBBox,1);
end
stairs(hTruth.Values.Time, numVehicles);
grid on
xlim([0,tmax])
ylim([-1,6])
title('Number of vehicles (Ground truth)')
xlabel('time (sec)')

%% Plot true positives
subplot(4,1,2)
stairs(hTruePositives.Values.Time,hTruePositives.Values.Data(:));
grid on
xlim([0,tmax])
ylim([-1,6])
title('True positives')
xlabel('time (sec)')

%% Plot false negatives
subplot(4,1,3)
stairs(hFalseNegatives.Values.Time,hFalseNegatives.Values.Data(:));
grid on
xlim([0,tmax])
ylim([-1,6])
title('False  negatives')
xlabel('time (sec)')

%% Plot false positives
subplot(4,1,4)
stairs(hFalsePositives.Values.Time,hFalsePositives.Values.Data(:));
grid on
xlim([0,tmax])
ylim([-1,4])
title('False positives')
xlabel('time (sec)')

end