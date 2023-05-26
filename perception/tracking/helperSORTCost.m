function costMatrix = helperSORTCost(tracker, dets)
D = numel(dets);
T = tracker.NumTracks;

% Return early if no detections or no tracks
if D*T == 0
    costMatrix = zeros(T,D);
    return
end

time = dets(1).Time;
tracks = predictTracksToTime(tracker, 'all',time);
costMatrix = -similarityIoU(tracks, dets);
end


function iou = similarityIoU(tracks, detections)
%Calculates the Intersection over Union similarity between a tracks and a
%detections

states = [tracks.State];
bbstate = helperBBMeasurementFcn(states); % convert states to [x, y, w, h] for bboxOverlapRatio
bbmeas = vertcat(detections.Measurement);
bbmeas = helperBBMeasurementFcn(bbmeas')';
iou = bboxOverlapRatio(bbstate', bbmeas); % bounding boxes must be concatenated vertically, transpose states
end