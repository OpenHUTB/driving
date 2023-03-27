function helperPlotDiffSignals(diffResult)
%helperPlotDiffSignals Plots the signal differences that are computed from
%two simulation runs of LaneMarkerDetectorTestBench.slx.
% Required Input
% diffResult: Simulink.sdi.DiffRunResult object obtained from
% Simulink.sdi.compareRuns 
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2020 The MathWorks, Inc.
%%
% Get left lane curvature difference 
leftLaneCurvatureIndex = 9;
leftCurvatureDiffResult = getResultByIndex(diffResult,leftLaneCurvatureIndex);
% Get left lane heading angle difference 
leftLaneHeadingAngleIndex = 11;
leftLaneHeadingAngleDiffResult = getResultByIndex(diffResult,leftLaneHeadingAngleIndex);
% Get left lane lateral offset difference 
leftLaneLateralOffset = 12;
leftLaneLateralOffsetDiffResult = getResultByIndex(diffResult,leftLaneLateralOffset);

% Get right lane curvature difference 
rightLaneCurvatureIndex = 16;
rightCurvatureDiffResult = getResultByIndex(diffResult,rightLaneCurvatureIndex);
% Get right lane heading angle difference 
righLaneHeadingAngleIndex = 18;
rightLaneHeadingAngleDiffResult = getResultByIndex(diffResult,righLaneHeadingAngleIndex);
% Get right lane lateral offset difference 
rightLaneLateralOffset = 19;
rightLaneLateralOffsetDiffResult = getResultByIndex(diffResult,rightLaneLateralOffset);

%% Plot the left lane difference results
figure('Name','Lane Difference Results');
subplot(3,1,1)
plot(leftCurvatureDiffResult.Diff.Time,leftCurvatureDiffResult.Diff.Data(:))
ylim([-0.0001 0.0001]);
title('Left lane curvature difference')
xlabel('time (sec)')
ylabel('diff signal')

subplot(3,1,2)
plot(leftLaneHeadingAngleDiffResult.Diff.Time,leftLaneHeadingAngleDiffResult.Diff.Data(:))
ylim([-0.001 0.001]);
title('Left lane heading angle difference')
xlabel('time (sec)')
ylabel('diff signal')

subplot(3,1,3)
plot(leftLaneLateralOffsetDiffResult.Diff.Time,leftLaneLateralOffsetDiffResult.Diff.Data(:))
ylim([-0.01 0.01]);
title('Left lane lateral offset difference')
xlabel('time (sec)')
ylabel('diff signal')

%% Plot the right lane difference results
figure('Name','Right Lane Difference Results');
subplot(3,1,1)
plot(rightCurvatureDiffResult.Diff.Time,rightCurvatureDiffResult.Diff.Data(:))
ylim([-0.0001 0.0001]);
title('Right lane curvature difference')
xlabel('time (sec)')
ylabel('diff signal')

subplot(3,1,2)
plot(rightLaneHeadingAngleDiffResult.Diff.Time,rightLaneHeadingAngleDiffResult.Diff.Data(:))
ylim([-0.001 0.001]);
title('Right lane heading angle difference')
xlabel('time (sec)')
ylabel('diff signal')

subplot(3,1,3)
plot(rightLaneLateralOffsetDiffResult.Diff.Time,rightLaneLateralOffsetDiffResult.Diff.Data(:))
ylim([-0.01 0.01]);
title('Right lane lateral offset difference')
xlabel('time (sec)')
ylabel('diff signal')

end