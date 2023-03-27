%helperLaneDetector provides lane marker detections on image frame.
% helperLaneDetector estimates lane markers on the image frame
% provided by monoCamera sensor.
%
% NOTE: The name of this class and it's functionality may
% change without notice in a future release,
% or the class itself may be removed.

% Copyright 2020-2021 The MathWorks, Inc.
classdef helperLaneDetector < handle
    properties
        % Lane marker detection parameters
        % The percentage extent of the ROI a lane needs to cover. It can remove
        % noisy detections
        LaneXExtentThreshold = 0.4;
        % Sensitivity for the lane segmentation routine
        LaneSegmentationSensitivity = 0.25;
        % Approximate lane marker width specified in meters
        ApproximateLaneMarkerWidth = 0.25;  
        % The percentage of inlier points required per unit length
        LaneStrengthThreshold = 0.24;
        % Maximum number of lane marker detections from
        % findParabolicLaneBoundaries
        MaxNumLaneMarkersToDetect = 2;
        % Min and max lane detection range specified in meters
        LaneDetectionRanges = [6 30];
        
        % Assign lane boundary parameters to default values by assuming
        % that left lane has lateral offset of 2m and right lane has
        % lateral offset of -2m from central lane.
        DefaultLeftLaneParams = [0 0 2];
        DefaultRightLaneParams = [0 0 -2];
        LastValidLaneLeft;
        LastValidLaneRight;
        LeftPredict;
        RightPredict;
        IsLeftTrackInitialized = false;
        IsRightTrackInitialized = false;
        % To initialize LeftPredict and RightPredict properties with
        % valid lane boundary parameters at the starting of
        % the simulation
        FirstInstance = true;
        KalmanLeftFilter;
        KalmanRightFilter;
        % To log the lanes status of the previous three frames
        ReplaceLeft = false(1,3);
        ReplaceRight = false(1,3);
    end
    
    properties (SetAccess='private', GetAccess='public')
        Sensor;
        MaxLaneStrength;
        VehicleROI;
        % Bird's eye view associated with the Sensor
        BirdsEyeImage;
        BirdsEyeBW;
        BirdsEyeConfig;       
    end
    
    properties (SetAccess='private', GetAccess='private', Hidden)
        % Region of bird's eye view  
        OutView;    
        % Width, in meters, of the birds eye view used for analyzing lane markers 
        WidthOfBirdsEyeView = 16;              
    end
    
    
    methods
        %------------------------------------------------------------------
        % Constructor
        %------------------------------------------------------------------
        function this = helperLaneDetector(sensor)
            this.Sensor = sensor;
            % Assign initial values for Lane tracker
            this.LastValidLaneLeft = parabolicLaneBoundary(this.DefaultLeftLaneParams);
            this.LastValidLaneRight = parabolicLaneBoundary(this.DefaultRightLaneParams);
            this.LeftPredict = this.DefaultLeftLaneParams;
            this.RightPredict = this.DefaultRightLaneParams;
            this.KalmanLeftFilter = configKalman(this,this.DefaultLeftLaneParams);
            this.KalmanRightFilter = configKalman(this,this.DefaultRightLaneParams);         
        end
    end
    
    
    methods (Access='public')
        %------------------------------------------------------------------
        % laneDetector detects lane boundaries in a frame of video sequence.
        %  [leftEgoBoundary,rightEgoBoundary] = laneDetector(frame) returns
        %  detected left and right ego-lane boundaries
        function [leftEgoBoundary,rightEgoBoundary] =  laneDetector(obj,frame)          
            sensor = obj.Sensor;
            
            % Define area to transform
            distAheadOfSensor = obj.LaneDetectionRanges(2); % in meters, as previously specified in monoCamera height input
            spaceToOneSide    = obj.WidthOfBirdsEyeView/2;  % all other distance quantities are also in meters
            bottomOffset      = obj.LaneDetectionRanges(1);
            outView   = [bottomOffset, distAheadOfSensor, -spaceToOneSide, spaceToOneSide]; % [xmin, xmax, ymin, ymax]
            outImageSize = [NaN, 250]; % output image width in pixels; height is chosen automatically to preserve units per pixel ratio
            
            % Compute birdsEyeView image
            birdsEyeConfig = birdsEyeView(sensor, outView, outImageSize);
            obj.BirdsEyeConfig = birdsEyeConfig;
            birdsEyeImage = transformImage(birdsEyeConfig, frame);
            birdsEyeImage = rgb2gray(birdsEyeImage);
            obj.BirdsEyeImage = birdsEyeImage;
            
            % Lane marker segmentation ROI in world units
            vehicleROI = outView - [-1, 2, -4, 4]; % look 4 meters to left and right, and 7 meters ahead of the sensor
            obj.VehicleROI = vehicleROI;
            approxLaneMarkerWidthVehicle = obj.ApproximateLaneMarkerWidth; % 25 centimeters
            
            % Detect lane boundary features
            laneSensitivity = obj.LaneSegmentationSensitivity;
            birdsEyeViewBW = segmentLaneMarkerRidge(birdsEyeImage, birdsEyeConfig, ...
                approxLaneMarkerWidthVehicle, 'ROI', vehicleROI, ...
                'Sensitivity', laneSensitivity);
            obj.BirdsEyeBW = birdsEyeViewBW;
            % Obtain lane candidate points in vehicle coordinates
            [imageX, imageY] = find(birdsEyeViewBW);
            xyBoundaryPoints = imageToVehicle(birdsEyeConfig, [imageY, imageX]);
            
            maxLanes      = obj.MaxNumLaneMarkersToDetect; % look for maximum of two lane markers
            boundaryWidth = 3*approxLaneMarkerWidthVehicle; % expand boundary width
            
            % Find lane boundary candidates
            coder.varsize('boundaries',[inf,inf]);
            coder.varsize('boundaryPoints',[inf,inf]);
            [boundaries, boundaryPoints] = findParabolicLaneBoundaries(xyBoundaryPoints,boundaryWidth, ...
                'MaxNumBoundaries', maxLanes, 'validateBoundaryFcn', @validateBoundaryFcn);
            
            % Validate boundaries using the last valid lane boundaries.
            
            % Check whether the last valid lanes are proper based on their
            % width and strength 
            areLastBoundariesSet = ~((obj.LastValidLaneRight.Width == 0 && obj.LastValidLaneRight.Strength == 0)...
                && (obj.LastValidLaneLeft.Width == 0 && obj.LastValidLaneLeft.Strength == 0));
            
            if areLastBoundariesSet
                % Construct vectors by considering weighted heading angle
                % and lateral offset for validating against last valid
                % lanes. Not considering curvature because it might vary
                % even for the valid lanes in case of curved road.
                
                % Give weight to heading angle to bring their values to the
                % order of lateral offset values. This ensures the distance
                % computed is not overly biased with the change in lateral
                % offset.
                weightForHeadingAngle = 10;
                
                % Construct lane vector from previous valid lanes.
                lastValidLaneVec = [obj.LastValidLaneLeft.Parameters(2)*weightForHeadingAngle obj.LastValidLaneLeft.Parameters(3);...
                    obj.LastValidLaneRight.Parameters(2)*weightForHeadingAngle obj.LastValidLaneRight.Parameters(3)];
                
                % Construct lane vector from detected lane boundaries.
                currentDetectedLaneVec = zeros(length(boundaries),2);
                for nBoundary = 1:length(boundaries)
                    currentDetectedLaneVec(nBoundary,:) = [boundaries(nBoundary).Parameters(2)*weightForHeadingAngle boundaries(nBoundary).Parameters(3)];
                end
                
                % Find pair-wise euclidean distance between the vectors constructed
                % using current boundaries and last valid lane boundaries
                coder.varsize('distanceMatrix',[inf,inf]); 
                distanceMatrix = coder.nullcopy(zeros(2,size(currentDetectedLaneVec,1)));
                for i = 1:size(lastValidLaneVec,1)
                    for j = 1:size(currentDetectedLaneVec,1)
                        distanceMatrix(i,j) = norm(currentDetectedLaneVec(j,:)-lastValidLaneVec(i,:)); 
                    end
                end 
                
                % Find the two best boundary indices such that one of them
                % has minimum distance from left lane and another one has
                % minimum distance from right lane.
                [distMin,indexMin] = min(distanceMatrix,[],2);
                
                % For the valid boundaries, it is expected that the
                % distance should be less than distThreshold. Discard the
                % indices for which this condition is not satisfied.
                distThreshold = 0.5;
                k = find(distMin > distThreshold, 1);
                if ~isempty(k)
                    indexMin(distMin > distThreshold) = [];
                end
                
                % Get the valid boundary indices in sorted order.
                validBoundaryIndex = sort(indexMin);
                numValidBoundaries = length(validBoundaryIndex);
                numDetectedBoundaries = length(boundaries);
                % Keep the valid boundaries and discard others from the
                % detected boundaries using the valid indices.
                if (numDetectedBoundaries > numValidBoundaries)
                    % Assign boundaries and boundaryPoints to temporary
                    % variables.
                    tempBoundaries = boundaries;
                    tempBoundaryPoints = boundaryPoints;
                    % Reallocate boundaries and boundaryPoints
                    boundaries = parabolicLaneBoundary(zeros(1,3));
                    boundaries = repmat(boundaries,1,numValidBoundaries);
                    boundaryPoints = coder.nullcopy(cell(1,numValidBoundaries));
                    % Fill boundaries and boundaryPoints with valid ones.
                    for id = 1:numValidBoundaries
                        boundaries(id) = tempBoundaries(validBoundaryIndex(id));
                        boundaryPoints{1,id} = tempBoundaryPoints{1,id};
                    end
                end
            end
            
            % Establish criteria for rejecting boundaries based on their length
            maxPossibleXLength = diff(vehicleROI(1:2));
            minXLength         = maxPossibleXLength * obj.LaneXExtentThreshold; % establish a threshold
            
            % To compute the maximum strength, assume all image pixels within the ROI
            % are lane candidate points
            birdsImageROI = vehicleToImageROI(obj);
            [laneImageX,laneImageY] = meshgrid(birdsImageROI(1):birdsImageROI(2),birdsImageROI(3):birdsImageROI(4));
            
            % Convert the image points to vehicle points
            vehiclePoints = imageToVehicle(birdsEyeConfig,[laneImageX(:),laneImageY(:)]);
            
            % Find the maximum number of unique x-axis locations possible for any lane
            % boundary
            maxPointsInOneLane = numel(unique(single((vehiclePoints(:,1)))));
            
            % Set the maximum length of a lane boundary to the ROI length
            maxLaneLength = diff(vehicleROI(1:2));
            
            % Compute the maximum possible lane strength for this image size/ROI size
            % specification
            maxStrength   = maxPointsInOneLane/maxLaneLength;
            if( numel(boundaries) > 0 )
                isOfMinLength = false(1, numel(boundaries));
                for i = 1 : numel(boundaries)
                    if(diff(boundaries(i).XExtent) > minXLength)
                        isOfMinLength(i) = true;
                    end
                end
            else
                isOfMinLength = false;
            end
            % Reject weak boundaries
            idx = 0;
            strongBoundaries = parabolicLaneBoundary(zeros(nnz(isOfMinLength), 3));
            for i = 1 : size(isOfMinLength,2)
                if( isOfMinLength(i) == 1 )
                    if( boundaries(i).Strength > obj.LaneStrengthThreshold*maxStrength )
                        idx = idx + 1;
                        strongBoundaries(idx) = boundaries(i);
                    end
                end
            end
            
            % Classify lane marker type when boundaryPoints are not empty
            if isempty(boundaryPoints)
                strongBoundaries = repmat(strongBoundaries,1,2);
                strongBoundaries(1) = parabolicLaneBoundary(zeros(1,3));
                strongBoundaries(2) = parabolicLaneBoundary(zeros(1,3));
            else
                strongBoundaries = classifyLaneTypes(obj,strongBoundaries, boundaryPoints);
            end
            % Find ego lanes
            xOffset = 0;    %  0 meters from the sensor
            distancesToBoundaries = coder.nullcopy(ones(size(strongBoundaries,2),1));
            
            for i = 1 : size(strongBoundaries, 2)
                distancesToBoundaries(i) = strongBoundaries(i).computeBoundaryModel(xOffset);
            end
            
            % Find candidate ego boundaries
            distancesToLeftBoundary = distancesToBoundaries>0;
            if (numel(distancesToBoundaries(distancesToLeftBoundary)))
                minLeftDistance = min(distancesToBoundaries(distancesToLeftBoundary));
            else
                minLeftDistance = 0;
            end
            distancesToRightBoundary = (distancesToBoundaries <0);
            if( numel(distancesToBoundaries(distancesToRightBoundary)))
                minRightDistance = max(distancesToBoundaries(distancesToRightBoundary));
            else
                minRightDistance = 0;
            end
            % Find left ego boundary
            if (minLeftDistance ~= 0)
                leftEgoBoundaryIndex  = distancesToBoundaries == minLeftDistance;
                leftEgoBoundary = parabolicLaneBoundary(zeros(nnz(leftEgoBoundaryIndex), 3));
                idx = 0;
                for i = 1 : size(leftEgoBoundaryIndex, 1)
                    if( leftEgoBoundaryIndex(i) == 1)
                        idx = idx + 1;
                        leftEgoBoundary(idx) = strongBoundaries(i);
                    end
                end
            else               
                leftEgoBoundary = parabolicLaneBoundary(zeros(1,3));
            end
            % Find right ego boundary
            if (minRightDistance ~= 0)
                rightEgoBoundaryIndex = distancesToBoundaries == minRightDistance;
                rightEgoBoundary = parabolicLaneBoundary(zeros(nnz(rightEgoBoundaryIndex), 3));
                idx = 0;
                for i = 1 : size(rightEgoBoundaryIndex, 1)
                    if( rightEgoBoundaryIndex(i) == 1)
                        idx = idx + 1;
                        rightEgoBoundary(idx) = strongBoundaries(i);
                    end
                end
            else
                 rightEgoBoundary = parabolicLaneBoundary(zeros(1,3));
            end
        end
        
        %------------------------------------------------------------------
        % rejectInvalidLanes method reject lane boundaries if they are
        % invalid and replaces using the predicted outputs from Kalman
        % trackers.
        function [leftEgoBoundary,rightEgoBoundary] = rejectInvalidLanes(obj,leftEgoBoundary,rightEgoBoundary)
            
            % Discard the unreasonable lanes and replace with estimated lanes
            if(obj.FirstInstance && ~isempty(leftEgoBoundary) && ~isempty(rightEgoBoundary))
                if(nnz(leftEgoBoundary.Parameters) && nnz(rightEgoBoundary.Parameters))
                    obj.LeftPredict = leftEgoBoundary.Parameters;
                    obj.RightPredict =  rightEgoBoundary.Parameters;
                    obj.FirstInstance = false;
                    obj.LastValidLaneLeft = leftEgoBoundary;
                    obj.LastValidLaneRight = rightEgoBoundary;
                end
            end
            
            % Valid lane parameters
            latDeltaMax  = 1.5; % Max lateral change between steps (m)
            laneWidthMin = 2.5; % Minimum valid lane width (m)
            laneWidthMax = 5.5; % Minimum valid lane width (m)
            
            % Initialize flags to reject lanes
            obj.ReplaceLeft = [false obj.ReplaceLeft(1:end-1)];
            obj.ReplaceRight = [false obj.ReplaceRight(1:end-1)];
            
            
            % Previous detected lanes
            leftPrev  = obj.LastValidLaneLeft;
            rightPrev = obj.LastValidLaneRight;
            
            % Current detected lanes
            leftCur = leftEgoBoundary;
            rightCur = rightEgoBoundary;
            
            % Longitudinal points to compare lateral distances (1 m increments)
            longDist = obj.LaneDetectionRanges(1):obj.LaneDetectionRanges(2);
            
            if (~obj.FirstInstance)
                % Check validity of left lane
                if isempty(leftCur)
                   obj.ReplaceLeft(1) = true;
                else
                    % Replace lane if lateral distance deviates too much
                    latDistLeftPrev = leftPrev.computeBoundaryModel(longDist);
                    latDistLeftCur  = leftCur.computeBoundaryModel(longDist);
                    latDeltaMaxArray = latDeltaMax*ones(size(latDistLeftCur));
                    if nnz(abs(latDistLeftCur - latDistLeftPrev) > latDeltaMaxArray)
                        obj.ReplaceLeft(1) = true;                     
                    end
                end
                
                % Check validity of right lane
                if isempty(rightCur)
                    obj.ReplaceRight(1) = true;
                else
                    % Replace lane if lateral distance deviates too much
                    latDistRightPrev = rightPrev.computeBoundaryModel(longDist);
                    latDistRightCur  = rightCur.computeBoundaryModel(longDist);
                    latDeltaMaxArray = latDeltaMax*ones(size(latDistRightCur));
                    if nnz(abs(latDistRightCur - latDistRightPrev) > latDeltaMaxArray)
                        obj.ReplaceRight(1) = true;
                    end
                end
            end
            
            % If left lane is improper in the current frame then replace it
            % with left lanes from previous frame
            if obj.ReplaceLeft(1)         
                leftCur = leftPrev; 
                % If left lanes are improper in the current frame and in
                % the previous frame, then replace it with predicted lanes
                if (obj.ReplaceLeft(2))
                    leftCur.Parameters = obj.LeftPredict;                    
                    % If left lanes are improper for the current frame and
                    % the previous two frames then replace it with default
                    % left lanes
                    if(obj.ReplaceLeft(3))
                        leftCur = parabolicLaneBoundary(obj.DefaultLeftLaneParams);
                    end                    
                end
            end
            
            % If right lane is improper in the current frame then replace
            % it with right lane from previous frame
            if (obj.ReplaceRight(1))
                rightCur = rightPrev;
                % If right lanes are improper in the current frame and in
                % the previous frame, then replace it with predicted lanes
                if (obj.ReplaceRight(2))
                    rightCur.Parameters = obj.RightPredict;
                    % If right lanes are improper for the current frame and
                    % the previous two frames then replace it with default
                    % right lanes
                    if (obj.ReplaceRight(3))
                        rightCur = parabolicLaneBoundary(obj.DefaultRightLaneParams);
                    end
                end
            end
            
            % Validate that lane widths are expected
            latDistLeftCur  = leftCur.computeBoundaryModel(longDist);
            latDistRightCur = rightCur.computeBoundaryModel(longDist);
            laneWidth = latDistLeftCur - latDistRightCur;
            if ~isempty(laneWidth)
                minLanes = laneWidth < laneWidthMin;
                maxLanes = laneWidth > laneWidthMax;
                if  (nnz(minLanes)) || (nnz(maxLanes))
                    % Lanes are not in a trustworthy state, reset to
                    % default lanes
                    obj.ReplaceLeft(1) = true;
                    obj.ReplaceRight(1) = true;              
                    leftCur = parabolicLaneBoundary(obj.DefaultLeftLaneParams);
                    rightCur = parabolicLaneBoundary(obj.DefaultRightLaneParams);
                    
                end
            end
            % Update output
            leftEgoBoundary = leftCur;
            rightEgoBoundary = rightCur;
            
            % Update state
            obj.LastValidLaneLeft = leftCur;
            obj.LastValidLaneRight = rightCur;
            
            % Update tracker     
            updateTracker(obj,leftCur,rightCur);                       
                      
        end
        
        %------------------------------------------------------------------
        % updateTracker intializes Kalman filters for left and right
        % lanes. In case of improper lane detections, replace lanes
        % with the predicted data from Kalman filters. In case of
        % proper lanes, update the filter.
        function updateTracker(obj,leftCur,rightCur)
            detectionsLeft = zeros(1,3);
            detectionsRight = zeros(1,3);
            leftCurParameters = leftCur.Parameters;
            if (nnz(leftCurParameters))
                detectionsLeft = [leftCur.Parameters(1)...
                    leftCur.Parameters(2) ...
                    leftCur.Parameters(3)];
            end
            rightCurParameters = rightCur.Parameters;
            if (nnz(rightCurParameters))
                detectionsRight = [rightCur.Parameters(1)...
                    rightCur.Parameters(2) ...
                    rightCur.Parameters(3)];
            end
                        
            if(~obj.IsLeftTrackInitialized) && nnz(detectionsLeft)
                lenSubState = 3;
                classToUse = 'double';
                numDims = length(detectionsLeft);
                lenState = numDims * lenSubState;
                State = zeros(lenState, 1, classToUse);
                State(1: lenSubState: lenState) = detectionsLeft;
                obj.KalmanLeftFilter.State = State;
                obj.IsLeftTrackInitialized = true;
            end
            
            if(~obj.IsRightTrackInitialized) && nnz(detectionsRight)
                lenSubState = 3;
                classToUse = 'double';
                numDims = length(detectionsRight);
                lenState = numDims * lenSubState;
                State = zeros(lenState, 1, classToUse);
                State(1: lenSubState: lenState) = detectionsRight;
                obj.KalmanRightFilter.State = State;
                obj.IsRightTrackInitialized = true;
            end
            
            % Correct the KalmanLeftFilter with proper left lane detections
            if (obj.IsLeftTrackInitialized) && any(detectionsLeft ~= obj.DefaultLeftLaneParams)                
                predict(obj.KalmanLeftFilter);
                correct(obj.KalmanLeftFilter, detectionsLeft);
            end
            
            % Correct the KalmanRightFilter with proper right lane detections
            if (obj.IsRightTrackInitialized) && any(detectionsRight ~= obj.DefaultRightLaneParams)                              
                predict(obj.KalmanRightFilter);
                correct(obj.KalmanRightFilter, detectionsRight);
            end
            
            % Update obj.LeftPredict and obj.RightPredict to use them if the lanes
            % are improper in the next sample
            if (obj.IsLeftTrackInitialized)
                obj.LeftPredict =  predict(obj.KalmanLeftFilter);
            end
            if obj.IsRightTrackInitialized
                obj.RightPredict = predict(obj.KalmanRightFilter);
            end
        end
        
        %------------------------------------------------------------------
        % configKalman intializes Kalman filters
        function kalmanFilter = configKalman(~,initialLocation)
            % Create a KalmanFilter object
            lenSubState = 3;
            As = [1, 1, 0.5; 0, 1, 1; 0, 0, 1];
            Hs = [1, 0, 0];
            InitialEstimateError = [1 1 1]*1e5;
            MotionNoise = [25, 10, 10];
            MeasurementNoise = 25;
            numDims = length(initialLocation);
            lenState = numDims * lenSubState;
            classToUse = 'double';
            StateTransitionModel = zeros(lenState, lenState, classToUse);
            MeasurementModel     = zeros(numDims,  lenState, classToUse);
            State = zeros(lenState, 1, classToUse);
            StateCovariance  = diag(repmat(InitialEstimateError, [1, numDims]));
            ProcessNoise     = diag(repmat(MotionNoise,          [1, numDims]));
            MeasurementNoise = diag(repmat(MeasurementNoise,     [1, numDims]));
            
            for iDim = 1: numDims
                iFirst = (iDim - 1) * lenSubState + 1;
                iLast = iDim * lenSubState;
                StateTransitionModel(iFirst:iLast, iFirst:iLast) = As;
                MeasurementModel(iDim, iFirst:iLast) = Hs;
            end
            State(1: lenSubState: lenState) = initialLocation;
            kalmanFilter = vision.KalmanFilter(StateTransitionModel,MeasurementModel,...
                'ProcessNoise',ProcessNoise ,'MeasurementNoise',MeasurementNoise,'StateCovariance',StateCovariance );
            kalmanFilter.State = State;
        end
        
    
        %--------------------------------------------------------------------------
        % vehicleToImageROI converts ROI in vehicle coordinates to image
        % coordinates in bird's-eye-view image.
        function imageROI = vehicleToImageROI(obj)
            birdsEyeConfig = obj.BirdsEyeConfig;
            vehicleROI = double(obj.VehicleROI);
            
            loc2 = (abs(vehicleToImage(birdsEyeConfig, [vehicleROI(2) vehicleROI(4)])));
            loc1 = (abs(vehicleToImage(birdsEyeConfig, [vehicleROI(1) vehicleROI(4)])));
            loc4 =     (vehicleToImage(birdsEyeConfig, [vehicleROI(1) vehicleROI(4)]));
            loc3 =     (vehicleToImage(birdsEyeConfig, [vehicleROI(1) vehicleROI(3)]));
            
            [minRoiX, maxRoiX, minRoiY, maxRoiY] = deal(loc4(1), loc3(1), loc2(2), loc1(2));
            
            imageROI = round([minRoiX, maxRoiX, minRoiY, maxRoiY]);
            
        end
        %--------------------------------------------------------------------------
        % Determine Lane Marker Types Classify lane boundaries as 'solid',
        % 'dashed', etc.
        function boundariesIsStrong = classifyLaneTypes(~,boundariesIsStrong, boundaryPoints)
            
            for bInd = 1 : size(boundariesIsStrong,2)
                
                vehiclePoints = boundaryPoints{bInd};
                % Sort by x
                vehiclePoints = sortrows(vehiclePoints, 1);
                
                xVehicle = vehiclePoints(:,1);
                xVehicleUnique = unique(xVehicle);
                
                % Dashed vs solid
                xdiff  = diff(xVehicleUnique);
                % Set a threshold to remove gaps in solid line but not the spaces from
                % dashed lines.
                xdiffThreshold = mean(xdiff) + 3*std(xdiff);
                largeGaps = xdiff(xdiff > xdiffThreshold);
                
                % Safe default
                boundary = boundariesIsStrong(bInd);           % changed according to set/get methods
                boundary.BoundaryType= LaneBoundaryType.Solid;
                
                if largeGaps>1
                    % Ideally, these gaps should be consistent, but you cannot rely
                    % on that unless you know that the ROI extent includes at least 3 dashes.
                    boundary.BoundaryType= LaneBoundaryType.Dashed;
                end
                boundariesIsStrong(bInd) = boundary;
            end
        end     
    end
end

%--------------------------------------------------------------------------
% Function that's used to reject some of the found curves
function isGood = validateBoundaryFcn(params)

if ~isempty(params)
    a = params(1);
    
    % Reject any curve with a small 'a' coefficient, which makes it highly
    % curved.
    isGood = abs(a) < 0.003; % a from ax^2+bx+c
else
    isGood = false;
end
end
