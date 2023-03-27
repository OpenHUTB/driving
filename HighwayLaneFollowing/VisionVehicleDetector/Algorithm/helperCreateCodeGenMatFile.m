function helperCreateCodeGenMatFile(detector)
%helperCreateCodeGenMatFile creates a mat file with the detector data based
%on the selection of ACF or YOLOv2 vehicle detector.

% Examples of calling this function:
%
% helperCreateCodeGenMatFile("ACF");
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2020-21 The MathWorks, Inc.

% Validate the input argument.
arguments
    detector (1,:) char {mustBeMember(detector,{'ACF','YOLOv2'})};
end

    % Based on the detector, create a mat file if it is not already exists.
    % This mat file has corresponding detector information.
    if(detector == "ACF" && ~(isfile('vehicleDetectorACFModel.mat')))
        detector = vehicleDetectorACF();
        detector = toStruct(detector);
        % Remove the 'weights' and 'depth' fields from classifier struct. Those
        % two fields are unused for inference, removing them reduces the buffer
        % size used in generated code.
        detector.Classifier = rmfield(detector.Classifier, {'weights', 'depth'});
        save('vehicleDetectorACFModel.mat', '-struct', 'detector');
    elseif(detector == "YOLOv2" && ~(isfile('vehicleDetectorYOLOv2Model.mat')))
        detector = vehicleDetectorYOLOv2();
        save('vehicleDetectorYOLOv2Model.mat', 'detector');
    end
end