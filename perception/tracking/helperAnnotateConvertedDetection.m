function frame = helperAnnotateDetection(dets, frame)
if isempty(dets)
    return
end
positions = vertcat(dets.Measurement);
positions = helperBBMeasurementFcn(positions')';
scorelabels = arrayfun(@(x) x.ObjectAttributes.Score, dets);
frame = insertObjectAnnotation(frame, 'Rectangle',positions, scorelabels,'TextBoxOpacity',0.2);
