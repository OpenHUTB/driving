function [tp, fp, fn] = helperEvaluateMetrics(detections, vehicleBoxes)
%helperEvaluateMetrics computes the metrics for the Generate Code for
%Vision Vehicle Detector example based on the ground truth and the detected
%vehicles.

% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2020-2021 The MathWorks, Inc.

%%
% Filter the boxes from the ground truth that are occluded by larger
% bounding boxes.

filteredVehicleBoxes = filterHiddenBoxes(vehicleBoxes);

numHiddenBoxes =  size(vehicleBoxes(any(vehicleBoxes, 2), :),1)- size(filteredVehicleBoxes,1);

% Compute true positives, false positives, false negatives, average
% precision, and average miss rate.
[tp, fp, fn, ~] = computeMetrics(detections, filteredVehicleBoxes);

% Hidden bounding boxes are considered as false negatives.
fn = fn + numHiddenBoxes;


end

% Removes boxes that are occluded by larger bounding boxes with overlap
% ratio > 0.8
function updatedBoxes = filterHiddenBoxes(boundingBoxes)

nonZeroBbox = boundingBoxes(any(boundingBoxes,2),:);

overlapRatios = bboxOverlapRatio(nonZeroBbox, nonZeroBbox,'Min');
removed = [];

for i = 1:size(overlapRatios,2)
    row = overlapRatios(i,:);
    hidden = sum(row>0.8);
    if hidden>0    
        for j = 1:size(row,2)
            ratio = row(j);
            if ratio>0.8 && i~=j
                
                bboxiSize = nonZeroBbox(i,3)*nonZeroBbox(i,4);
                bboxjSize = nonZeroBbox(j,3)*nonZeroBbox(j,4);
                if bboxiSize<bboxjSize
                    if ~any(removed(:) == i)
                        removed = cat(2, removed, i);
                    end
                else
                    if ~any(removed(:) == j)
                        removed = cat(2, removed, j);
                    end
                end
            end
        end
    end
end

updatedBoxes = [];

    for k = 1:size(nonZeroBbox,1)
        if ~any(removed(:) == k) && nonZeroBbox(k,3) > 10 && nonZeroBbox(k,4)>10
            updatedBoxes = cat(1, updatedBoxes, nonZeroBbox(k,:));
        end
    end

end

% Compute metrics based on the ground truth and the detections.
function [tp, fp, fn, matches] = computeMetrics(detections, groundTruth)
vehiclesInFrame = size(groundTruth,1);
vehiclesDetected = detections.NumDetections;


bboxPred = zeros(vehiclesDetected,4);
bboxScores = zeros(vehiclesDetected,1);

overlapThreshold = 0.5;
for j = 1:vehiclesDetected
    bboxPred(j,:) = detections.Detections(j).Boxes;
    bboxScores(j) = detections.Detections(j).Scores;
end

% Compute bounding box overlap ratio
overlap = bboxOverlapRatio(groundTruth, bboxPred);

falseNegatives = [];
matches = {};
for i = 1:vehiclesInFrame
    % Compute overlap ratio between the detected and ground truth boxes
    row = overlap(i,:);
    match = sum(row>overlapThreshold);

    % If there is no corresponding box for a ground truth box, then it can
    % be treated as a false negative
    if match == 0
        falseNegatives = cat(2,falseNegatives,i);
    else
        % if there are more than one matches, then all but one can be taken
        % as false positive
        if match>1
            [~, index] = max(row);
            overlap(:,index) = 0;
            matches = cat(1, matches, {i,index});
        else 
            j = find(row>overlapThreshold);
            overlap(:,j) = 0;
            matches = cat(1, matches, {i, j});
        end
    end
            
end

% Assign number of false negatives
fn = size(falseNegatives,2);

% Assign number of true positives
tp = size(matches,1);

% Assign number of false positives
fp = abs(vehiclesDetected-tp);
end