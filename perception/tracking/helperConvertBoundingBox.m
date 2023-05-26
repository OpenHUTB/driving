function convertedDets = helperConvertBoundingBox(detections, R)

setR = nargin ==2;
isCell = iscell(detections);
convertedDets = detections;
for i=1:numel(detections)
    if isCell
        for j=1:numel(detections{i})
            xywh = detections{i}(j).Measurement;
            convertedDets{i}(j).Measurement = [xywh(1)+xywh(3)/2, xywh(2) + xywh(4)/2, xywh(3)*xywh(4), xywh(3)/xywh(4)];
            if setR
                convertedDets{i}(j).MeasurementNoise = R;
            end
        end
    else
        xywh = detections(i).Measurement;
        convertedDets(i).Measurement = [xywh(1)+xywh(3)/2, xywh(2) + xywh(4)/2, xywh(3)*xywh(4), xywh(3)/xywh(4)];
        if setR
            convertedDets(i).MeasurementNoise = R;
        end
    end
end
end