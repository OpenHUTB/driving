function helperPlotDiffSignals(diffResult)
%helperPlotDiffSignals Plots the signal differences that are computed from
%two simulation runs of VisionVehicleDetectorTestBench.slx.
% Required Input
% diffResult: Simulink.sdi.DiffRunResult object obtained from
% Simulink.sdi.compareRuns 
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2020-2021 The MathWorks, Inc.
%%
% Get true positives difference 
truePositivesIndex = 4;
truePositivesDiffResult = getResultByIndex(diffResult,truePositivesIndex);

% Get false negatives difference 
falseNegativesIndex = 6;
falseNegativesDiffResult = getResultByIndex(diffResult,falseNegativesIndex);

% Get falsePositives difference 
falsePositivesIndex = 5;
falsePositivesDiffResult = getResultByIndex(diffResult,falsePositivesIndex);


%% Plot the detection metric difference results
figure('Name','Detection Metrics Difference Results');
subplot(3,1,1)
plot(truePositivesDiffResult.Diff.Time,truePositivesDiffResult.Diff.Data(:))
ylim([-0.0001 0.0001]);
title('Difference in True Positives Between Normal and SIL Modes')
xlabel('time (sec)')
ylabel('diff signal')

subplot(3,1,2)
plot(falseNegativesDiffResult.Diff.Time,falseNegativesDiffResult.Diff.Data(:))
ylim([-0.001 0.001]);
title('Difference in False Negatives Between Normal and SIL Modes')
xlabel('time (sec)')
ylabel('diff signal')

subplot(3,1,3)
plot(falsePositivesDiffResult.Diff.Time,falsePositivesDiffResult.Diff.Data(:))
ylim([-0.01 0.01]);
title('Difference in False Positives Between Normal and SIL Modes')
xlabel('time (sec)')
ylabel('diff signal')
end