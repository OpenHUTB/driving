function helperVerifyPrecisionAndMissrate(test,minPrecision,maxMissrate)
% helperVerifyPrecisionAndMissrate plots figures and video for
% generating report from Automate Testing For Vision Vehicle Detector
% example. It takes logsout that is logged from simulation runs of
% VisionVehicleDetectorTestBench model. It is invoked from the CLEANUP
% callback of the test cases from Simulink Test.

% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2021 The MathWorks, Inc.


detectionMetrics = helperComputePrecisionAndMissrate(test.sltest_simout.logsout);

import matlab.unittest.constraints.IsGreaterThan
import matlab.unittest.constraints.IsLessThan

% Verify precision
test.verifyThat(detectionMetrics.avgPrecision,IsGreaterThan(minPrecision),'Verify Precision');
% Verify sensitivity
test.verifyThat(detectionMetrics.averageMissrate,IsLessThan(maxMissrate),'Verify Missrate');
helperPlotPrecisionAndMissrate(detectionMetrics, "YOLOv2");
end