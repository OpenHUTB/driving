function detectionMetrics = helperComputePrecisionAndMissrate(logsout)
% helperComputePrecisionAndMissrate A helper function for computing the
% post simulation metrics using logged data from
% VisionVehicleDetectorTestBench.slx.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the elements that are needed to compute post simulation
% metrics.

% Copyright 2021 The MathWorks, Inc.
detections = logsout.get('detections');
truth = logsout.get('vehicle_boxes_truth');
for i = 1:length(truth.Values.Time)
    currDetections.NumDetections = detections.Values.NumDetections.Data(i);
    
    for j = 1: size(detections.Values.Detections,1)
        currDetections.Detections(j,1).Boxes = detections.Values.Detections(j).Boxes.Data(:,:,i);
        currDetections.Detections(j,1).Scores = detections.Values.Detections(j).Scores.Data(:,:,i);
    end
    [tablePredicted, tableTruth] = storeDetectionsAndTruthInTable(currDetections, truth.Values.Data(:,:,i), 0);
end
[~,~] = storeDetectionsAndTruthInTable([],[],1);
% Evaluate the detections against the truth
[avgPrecision, recall, precision] = evaluateDetectionPrecision(tablePredicted, tableTruth);
[averageMissrate, fppi, missRate] = evaluateDetectionMissRate(tablePredicted, tableTruth);

detectionMetrics.avgPrecision = avgPrecision;
detectionMetrics.recall = recall;
detectionMetrics.precision = precision; 
detectionMetrics.averageMissrate = averageMissrate;
detectionMetrics.fppi = fppi;
detectionMetrics.missRate = missRate;

end

function [tablePredictedOut, tableTruthOut] =  storeDetectionsAndTruthInTable(detections, groundTruth, flush)
% store the detection results and truth in a table format.

persistent tablePredicted;
persistent tableTruth;
persistent tableIndex;
if(isempty(tableIndex))
    tablePredicted = table();
    tableTruth = table();
    tableIndex = 1;
end

if flush
    vars = whos;
    vars = vars([vars.persistent]);
    varName = {vars.name};
    clear(varName{:});
    tablePredictedOut = [];
    tableTruthOut = [];
    return
end

groundTruth = groundTruth(any(groundTruth,2),:);
vehiclesDetected = detections.NumDetections;

predictedBBoxes = zeros(vehiclesDetected, 4);
predictedScores = zeros(vehiclesDetected, 1);

for i = 1:vehiclesDetected
    predictedBBoxes(i,:) = detections.Detections(i).Boxes;
    predictedScores(i) = detections.Detections(i).Scores;
end

tablePredicted(tableIndex,:) = table({predictedBBoxes}, {predictedScores}, 'VariableNames', {'Boxes', 'Scores'});

tableTruth.car{tableIndex} = groundTruth;
tableIndex = tableIndex + 1;
tablePredictedOut = tablePredicted;
tableTruthOut = tableTruth;

end