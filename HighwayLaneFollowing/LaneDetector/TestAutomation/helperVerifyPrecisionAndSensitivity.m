function helperVerifyPrecisionAndSensitivity(test,precisionThreshold,sensitivityThreshold)
% helperVerifyPrecisionAndSensitivity A helper function to verify the
% precision and sensitivity metrics from
% LaneMarkerDetectorMetricAssessments.slx.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the test bench simulation outputs the Simulink
% log, logsout, containing the elements to be plotted.

% Copyright 2021 The MathWorks, Inc.

% Compute metircs for the whole simulation run
[numLaneMatches, numLaneMisses, numFalsePositives] = helperPlotLaneMetrics(test.sltest_simout.logsout);

% Compute precision
precision = (numLaneMatches./(numLaneMatches+numFalsePositives))*100;
% Compute Sensitivity
sensitivity = (numLaneMatches./(numLaneMatches+numLaneMisses))*100;

import matlab.unittest.constraints.IsGreaterThan
% Verify precision
test.verifyThat(precision,IsGreaterThan(precisionThreshold),'Verify Precision');
% Verify sensitivity
test.verifyThat(sensitivity,IsGreaterThan(sensitivityThreshold),'Verify Sensitivity');
end