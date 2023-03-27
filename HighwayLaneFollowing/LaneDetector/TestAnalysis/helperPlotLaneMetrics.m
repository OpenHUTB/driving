function [numLaneMatches, numLaneMisses,numFalsePositives] = helperPlotLaneMetrics(logsout)
% helperPlotLaneMetrics A helper function for plotting the lane metrics 
% computed from LaneMarkerDetectorTestBench.slx.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the elements to be plotted.

% Copyright 2020 The MathWorks, Inc.

%% Get the data from simulation
hLeftLaneMetrics = logsout.get('left_lane_metrics');
hRightLaneMetrics = logsout.get('right_lane_metrics');
hLeftDeviation = logsout.get('left_lane_distance');
hRightDeviation = logsout.get('right_lane_distance');
tmax = hLeftLaneMetrics.Values.Time(end); 
%% Compute precision and sensitivity 
numSamples = length(hLeftLaneMetrics.Values.Time);
for i =1:numSamples
    leftLaneMatches(i) = hLeftLaneMetrics.Values.Data(1,1,i); 
    leftLaneMisses(i) = hLeftLaneMetrics.Values.Data(1,2,i);
    leftLaneFalsePositives(i) = hLeftLaneMetrics.Values.Data(1,3,i);
    rightLaneMatches(i) = hRightLaneMetrics.Values.Data(1,1,i); 
    rightLaneMisses(i) = hRightLaneMetrics.Values.Data(1,2,i);
    rightLaneFalsePositives(i) = hRightLaneMetrics.Values.Data(1,3,i);
end

numLaneMatches = sum(leftLaneMatches) + sum(rightLaneMatches);
numLaneMisses = sum(leftLaneMisses) + sum(rightLaneMisses);
numFalsePositives = sum(leftLaneFalsePositives) + sum(rightLaneFalsePositives);

%% Plot left lane metrics
figure('Name','Left lane Metrics','position',[835 100 720 600]);
subplot(4,1,1)
stairs(hLeftLaneMetrics.Values.Time,leftLaneMatches);
grid on
xlim([0,tmax])
title('Left lane matches')
xlabel('time (sec)')
ylabel('num matches')

subplot(4,1,2)
stairs(hLeftLaneMetrics.Values.Time,leftLaneMisses);
grid on
xlim([0,tmax])
title('Left lane misses')
xlabel('time (sec)')
ylabel('num misses')

subplot(4,1,3)
stairs(hLeftLaneMetrics.Values.Time,leftLaneFalsePositives);
grid on
xlim([0,tmax])
title('Left false positives')
xlabel('time (sec)')
ylabel('num false positives')

subplot(4,1,4)
stairs(hLeftDeviation.Values.Time,hLeftDeviation.Values.Data(:));
grid on
xlim([0,tmax])
title('Average left lane distance from ground truth')
xlabel('time (sec)')
ylabel('distance')

%% Plot right lane metrics
figure('Name','Right Lane Metrics','position',[835 100 720 600]);
subplot(4,1,1)
stairs(hRightLaneMetrics.Values.Time,rightLaneMatches);
grid on
xlim([0,tmax])
title('Right lane matches')
xlabel('time (sec)')
ylabel('num matches')

subplot(4,1,2)
stairs(hRightLaneMetrics.Values.Time,rightLaneMisses);
grid on
xlim([0,tmax])
title('Right lane misses')
xlabel('time (sec)')
ylabel('num misses')

subplot(4,1,3)
stairs(hRightLaneMetrics.Values.Time,rightLaneFalsePositives);
grid on
xlim([0,tmax])
title('Right false positives')
xlabel('time (sec)')
ylabel('num false positives')

subplot(4,1,4)
stairs(hRightDeviation.Values.Time,hRightDeviation.Values.Data(:));
grid on
xlim([0,tmax])
title('Average right lane distance from ground truth')
xlabel('time (sec)')
ylabel('distance')
end
