classdef HelperComputeGroundTruthBoxes < matlab.System
    %HelperComputeGroundTruthBoxes computes the ground truth bounding boxes
    %for the vehicles based on the actor positions and vehicle dimensions.
    % NOTE: The name of this System Object and it's functionality may
    % change without notice in a future release,
    % or the System Object itself may be removed.
    
    % Copyright 2021 The MathWorks, Inc.
    
    % Public, tunable properties
    properties(Nontunable)
        
        %VehicleDimensions holds information about the actors dimensions in
        %the scenario.
        VehicleDimensions = struct('id', 0, 'length', 0, 'width', 0, ...
            'height', 0, 'rearOverhang', 0, 'roll', 0, 'pitch', 0, ...
            'yaw', 0, 'velocity', 0, 'frontOverhang', 0);
        
        %Camera Sensor parameters
        Camera = struct('ImageSize',[768 1024],'PrincipalPoint',...
            [512 384],'FocalLength',[512 512],'Position',[1.8750 0 1.2000],...
            'PositionSim3d',[0.5700 0 1.2000],'Rotation',[0 0 0],...
            'DetectionRanges',[6 30],'MeasurementNoise',diag([6,1,1]));
    end

  properties (SetAccess='private', GetAccess='private', Hidden)
        % Sensor holds information about mono camera configuration
        Sensor;
        
        % Initilize output ground truth boxes with zeros
        GTBoxes;
        
        % Label used for vehicles
        VehicleLabel;
        
        % Initialize maximum width allowed for bounding box
        MaxBBoxWidth;
        
        % Initialize maximum height allowed for bounding box
        MaxBBoxHeight;
        
        % Region of interest
        ROI;
        
        % Bounding box overlap threshold 
        OverlapThreshold;
        
        % Initialize a distance threshold to use for the bounding boxes of
        % vehicles that are not more than this threshold distance away from
        % the ego vehicle
        EgoDistanceThreshold;
        
        
        % Initilaize a overlap ratio that removes boxes that are occluded
        % by larger bounding boxes
        OccludedBBoxOverlapRatio;
        
        % Initilaze minimum X value of bounding box.
        MinBBoxXValue;
        
        % Initialize starting pixel of ego vehicle hood 
        EgoVehicleHood;
        
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            % Camera setup
            %-------------
            camera = obj.Camera;
            
            camIntrinsics = cameraIntrinsics(camera.FocalLength, ...
                camera.PrincipalPoint, camera.ImageSize);
            
            sensor = monoCamera(camIntrinsics, camera.Position(3),...
                'Pitch', camera.Rotation(2));
            
            % Assign mono camera sensor property
            obj.Sensor = sensor;
            
            % Label used for vehicles
            obj.VehicleLabel  = 10;
            
            
            % Maximum width of the bounding boxes allowed
            obj.MaxBBoxWidth = 900;
            
             % Maximum height of the bounding boxes allowed
            obj.MaxBBoxHeight = 600;
            
            % Region of interest
            obj.ROI = [1,1,1024,480];
            
            % Bounding box overlap threshold 
            obj.OverlapThreshold = 0.5;
            
            % Assign threshold distance to use for the bounding boxes of
            % vehicles that are not more than this threshold distance away
            % from the ego vehicle
            obj.EgoDistanceThreshold = 60;
            
            % Assign overlap ratio removes boxes that are
            % occluded by larger bounding boxes with overlap ratio > 0.8
            obj.OccludedBBoxOverlapRatio = 0.8;
            
            % Minimum X value of bounding box.
            obj.MinBBoxXValue = 470;
            
            % Starting pixel of ego vehicle hood
            obj.EgoVehicleHood = 470;
        end

        function num = getNumOutputsImpl(obj)
            % Define total number of outputs for system with optional
            % outputs
            num = 1;
        end

        function out = getOutputSizeImpl(obj)
            % Return size for each output port
            out = [20 4];
        end

        function out = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
        end

        function out = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
        end

        function out = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
        end

        function [BBoxes] = stepImpl(obj, actorPositions, frame, labelledFrame )
            
            [BBoxes, ~, ~] = helperComputeGroundTruthBoxes(obj, actorPositions, frame, labelledFrame);
        end

    end

    methods(Access = protected, Static)
        function flag = showSimulateUsingImpl
            % Return false if simulation mode hidden in System block dialog
            flag = false;
        end
    end
end

function [result, centers, frameOut] = helperComputeGroundTruthBoxes(obj, actorPositions, ...
    frame, labelledFrame)
%helperComputeGroundTruthBoxes computes the ground truth bounding boxes for
%the vehicles based on the actor positions and vehicle dimensions.

% Frame for output video
frameOut = frame;

% Initialize the variables with zeros.
allBoxes = zeros(20,4);
result = zeros(20,4);
centers = zeros(20,3);
count = 0;
countCenter = 0;

for i = 1:size(actorPositions.Actors,1)

    
    pos = actorPositions.Actors(i).Position;
    
    % Computing distance between positions of each actor with ego vehicle
    
    % Euclidean distance between the actor position and origin (vehicle
    % coordinates)
    egoDistance = sqrt(sum((pos - [0,0,0]) .^ 2));

    % Check and discard the bounding boxes those are not in the range of 
    % [0 to 200] meters
    if pos(1) > 0 && pos(1)<200
        
        actorID = actorPositions.Actors(i).ActorID;
        extractID = [obj.VehicleDimensions.id];

        % Extracting actor dimensions for computation of Bounding Boxes
        actor = obj.VehicleDimensions(extractID == actorID);
        actorPositions.Actors(i).RearOverhang = actor.rearOverhang;
        actorPositions.Actors(i).Length = actor.length;

        % Translating actor position from geometric center to rear axle
        % center of the vehicle
        bottom_center = translateVehicleCenter(actorPositions.Actors(i));
        
        dimensionActor = [actor.length, actor.width, actor.height];
        
        % Computing the direction vector of the actor to be used in
        % computation of bounding boxes using dimensions
        forwardVector = computeDirection(actor);

        % Compute Bounding box using actor dimensions, center rear axle 
        % position, sensor object and direction vector
        bbox = computeBbox(obj, dimensionActor, bottom_center, forwardVector);
        
        bbWidth = bbox(3);
        bbHeight = bbox(4);
        
        % Include Bounding box only when width and height are appropriate
        % not more than 900px and 600px respectively and lower left corner
        % is inside the frame

        if bbWidth < obj.MaxBBoxWidth && bbHeight < obj.MaxBBoxHeight ...
                && bbox(1) < size(frame,1) ...
                && bbox(2) < size(frame,2)
            countCenter = countCenter+1;
            count = count+1;
            
            % Use bounding boxes of vehicles not more than 60m away from
            % the ego vehicle
            if egoDistance < obj.EgoDistanceThreshold
                result(count,:) = bbox;
                allBoxes(i,:) = bbox;
            else
                allBoxes(i,:) = bbox;
            end
        end
        
    end

end


% Adjust the bounding boxes inside the frame if boxes exceeds the frame
% dimensions then drag them into the frame, keeping width and height
% constant
allBoxes = adjustBoxes(allBoxes,frameOut);


% Enhancing the computed bounding boxes from semantic segmentation output
% obtained from 'Simulation 3d camera forward facing' block
updatedResult = segmentationBoxes(obj, allBoxes,labelledFrame);

result = zeros(20,4);
for p = 1: size(updatedResult,1)
    result(p,:) = updatedResult(p,:);
    thisBB = result(p,:);
    updatedBbox = adjustBboxInFrame(thisBB, frameOut);
    
    % Computing bottom center of the updated bounding box in image 
    % coordinates 
    yBottom = updatedBbox(2) + updatedBbox(4) - 1;
    xCenter = updatedBbox(1) + (updatedBbox(3)-1)/2;
    
    % Using the center to convert into vehicle coordinates using
    % imageToVehicle API

    vehicleCenter = imageToVehicle(obj.Sensor, [xCenter, yBottom]);
    
    % Collating vehicle centers to be used in metrics computation
    centers(p,:) = [vehicleCenter(1), vehicleCenter(2),0];

    
    label = sprintf('X=%0.2f, Y=%0.2f', thisBB(1), thisBB(2));
    frameOut = insertObjectAnnotation(frameOut, 'rectangle',...
            [thisBB(1), thisBB(2), thisBB(3), thisBB(4)],label,'Color','r');
end

end

% Translating vehicle center from geometric center to rear axle center of
% the vehicle
function new_position = translateVehicleCenter(actor)

position = actor.Position;
roll = actor.Roll;
pitch = actor.Pitch;
yaw = actor.Yaw;
length = actor.Length;
rearOverhang = actor.RearOverhang;

new_position = driving.scenario.internal.Utilities.translateVehiclePosition(...
    position, rearOverhang, length, roll, pitch, yaw);

end

% Algorithm for computing bounding boxes of the vehicle from its dimensions
function bbox = computeBbox(obj, actorDimensions, bottomCenter, forwardVector)
length = actorDimensions(1);
width = actorDimensions(2);
height = actorDimensions(3);

p0 = bottomCenter;
bcImg = vehicleToImage(obj.Sensor,p0);

% Computing multiple points depicting corners of the cuboid enclosing the 
% vehicle. Task is to choose 4 points in the 2d frame and chose the best
% possible bounding box with those 4 points. 
frontCenterBottom = p0 + [length/2,0,0];
backCenterBottom = p0 - [length/2,0,0];
frontRightBottom = frontCenterBottom - [0,width/2,0];
frontLeftBottom = frontCenterBottom + [0,width/2,0];
backRightBottom = backCenterBottom - [0,width/2,0];
backLeftBottom = backCenterBottom + [0,width/2,0];
frontRightTop = frontRightBottom + [0,0,height];
frontLeftTop = frontLeftBottom + [0,0,height];
backRightTop = backRightBottom + [0,0,height];
backLeftTop = backLeftBottom + [0,0,height];

points = [frontCenterBottom; backCenterBottom; frontLeftBottom; ...
    frontRightBottom; backLeftBottom; backRightBottom; ...
    frontLeftTop; frontRightTop; backLeftTop; backRightTop];

% Converting the computed points into image coordinates
img = vehicleToImage(obj.Sensor, points);

% Compute 4 corner points of the bounding box based on direction of the
% vehicle
if forwardVector(1) < 0
    % Sort points based on height
    sorted2 = sortrows(img, 2);
    % Lower left corner of the vehicle is the point with least value of Y
    llcorner = sorted2(1,:);
    % Maximum value of Y in all the points
    heightCorner = sorted2(end,:);
    % Sort points based on both the columns
    sorted1 = sortrows(img,[1,2]);
    % Diagonally opposite corner of lower left corner
    trcorner = sorted1(end,:);
    % Construct bounding box based on these corners
    bbox = [llcorner(1), llcorner(2), abs(sorted2(1,1) - trcorner(1)),...
        abs(llcorner(2)-heightCorner(2))];
else
    % Sort points based on height
    sorted2 = sortrows(img,2);
    % Height of the bbox = maxY - minY
    height = abs(sorted2(1,2)-sorted2(end,2));
    % Sort points based on both the columns
    sorted1 = sortrows(img,[1,2]);
    % Lower left corner of the bbox is the point with minimum X value
    llcorner = sorted1(1,:);
    widthCorner = sorted1(end,:);
    cornerRect = [llcorner(1,1),sorted2(1,2)];
    bbox = [cornerRect(1) + (abs(cornerRect(1) - bcImg(1))/4), ...
         cornerRect(2), abs(llcorner(1) - widthCorner(1)), height];
end



end

% Adjust the boxes to fit inside the frame 
function result = adjustBoxes(boxes, frameOut)

    groundTruthVehicleCount = 0;
    for i = 1:size(boxes,1)
        tempBB = boxes(i,:);

        if ~all(tempBB == 0)

            % If x coordinate of the lower left corner of bounding box is 
            % less than 0
            if tempBB(1) < 0
                
                % Adjust width of the box 
                tempBB(3) = tempBB(1)+tempBB(3);
                % Set x coordinate to zero
                tempBB(1) = 0;
                % Make changes in 'boxes' variable as well
                boxes(i,3) = tempBB(3);
                boxes(i,1) = 0;
            end
            
            % if y coordinate of the lower left corner of the bounding box
            % is less than 0
            if tempBB(2) < 0
                % Adjust height of the bounding box
                tempBB(4) = tempBB(2)+tempBB(4);
                % Set y coordinate to 0
                tempBB(2) = 0;
                % Make the same changes in boxes variable
                boxes(i,4) = tempBB(4);
                boxes(i,2) = 0;
            end
            
            % If top left corner of the box exceeds the maximum height 
            % of the frame 
            if tempBB(2) + tempBB(4) > size(frameOut,1)
                % Adjust height of the box
                tempBB(4) = size(frameOut,1) - tempBB(2);
                boxes(i,4) = tempBB(4);
            end

            % If lower right corner of the box exceeds the maximum width of
            % the frame
            if tempBB(1) + tempBB(3) > size(frameOut,2)
                % Adjust the width of the bounding box
                tempBB(3) = size(frameOut,2) - tempBB(1);
                boxes(i,3) = tempBB(3);
            end

            if all(tempBB>=0)
                groundTruthVehicleCount = groundTruthVehicleCount + 1;
            end
        end
    end
    result = boxes;

end

function updatedBbox = adjustBboxInFrame(tempBB, frame)

    if ~all(tempBB == 0)
        
        % If x coordinate of the lower left corner of bounding box is 
        % less than 0
        if tempBB(1) < 0
            tempBB(3) = tempBB(1)+tempBB(3);
            tempBB(1) = 0;
        end
        
        % If y coordinate of the lower left corner of the bounding box
        % is less than 0
        if tempBB(2) < 0
            tempBB(4) = tempBB(2)+tempBB(4);
            tempBB(2) = 0;
        end
        
        % If top left corner of the box exceeds the maximum height 
        % of the frame 
        if tempBB(2) + tempBB(4) > size(frame,1)
            tempBB(4) = size(frame,1) - tempBB(2);
            
        end
        
        % If lower right corner of the box exceeds the maximum width of
        % the frame
        if tempBB(1) + tempBB(3) > size(frame,2)
            tempBB(3) = size(frame,2) - tempBB(1);
        end
    end
    updatedBbox = tempBB;
        
end

% Computes direction of the actor based on Yaw, roll and Pitch
% values. This implementation is derived from internal translatePosition
% API
function forwardVector = computeDirection(actor)

yaw = actor.yaw;
roll = actor.roll;
pitch = actor.pitch;

R = driving.scenario.internal.rotZ(yaw) ...
    * driving.scenario.internal.rotY(pitch) ...
    * driving.scenario.internal.rotX(roll);
forwardVector = R(:,1)';

end

% Use segmentation output to refine the previously computed bounding boxes
function boundingBox = segmentationBoxes(obj, result, labeledFrame)
 
    % Binary mask Image using label used for vehicles
    maskImg = labeledFrame == obj.VehicleLabel;
    boundingBox = [];
    
    % Set pixel corresponding to ego vehicle to zero
    maskImg(obj.EgoVehicleHood:end,:) = 0;
    
    % Finding connected components in the binary mask Image
    CCresult = bwconncomp(maskImg);
   
    % Cropping the image using ROI
    crop = imcrop(labeledFrame, obj.ROI);
    
    % Binary mask Image for the cropped image
    maskCrop=  crop == obj.VehicleLabel;
    
    % Set pixel corresponding to ego vehicle to zero
    maskCrop(obj.EgoVehicleHood:end,:) = 0;
    
    if CCresult.NumObjects >= 1
        % Computing bounding boxes based on region properties
        info = regionprops(maskCrop, 'BoundingBox');
        segmentationboxes = [];
        for k = 1 : length(info)
            BB = info(k).BoundingBox;
            % Include boxes with width and height less than the maximum
            % allowed
            if BB(3)< obj.MaxBBoxWidth && BB(4)< obj.MaxBBoxHeight
                segmentationboxes = cat(1,segmentationboxes,BB);
            end
        end
        % Consider bounding boxes which have height and width 
        % greter than zero
        truth = result(all(result(:,3:4)>0,2),:);
        % Overlap ratios between the segmentation boxes and the ground
        % truth boxes computed in the previous step
        overlap = bboxOverlapRatio(segmentationboxes,  truth,'Min');
        finalBoxes = [];
       

        % Find correspondence between semantic segmentation boxes and
        % ground Truth boxes (computed in previous step)
        for i = 1:size(overlap,1)
            row = overlap(i,:);
            
            segmentationBoxTopLeft = segmentationboxes(i,1);
            segmentationBoxTopRight = segmentationboxes(i,1)+segmentationboxes(i,3);
            segmentationBoxBottomLeft = segmentationboxes(i,2)+segmentationboxes(i,4);
            segmentationBoxWidth = segmentationboxes(i,3);
            segmentationBoxHeight = segmentationboxes(i,4);

            minBoxWidth = 13;
            minBoxHeight = 8;
            
            % Find number of ground truth bounding boxes overlapping with a
            % single semantic segmentation box with overlap ratio greater
            % than threshold
            match = sum(row>obj.OverlapThreshold);
            
            % Consider bounding boxes from semantic segmentation when the 
            % bounding boxes are adjacent to the ego vehicle
            pixelOffset = 5;
            if match ==0 && (segmentationBoxTopLeft<pixelOffset || segmentationBoxTopRight>(obj.ROI(3)-pixelOffset))
                finalBoxes = cat(1,finalBoxes, round(segmentationboxes(i,:)));
                
            % If there is just 1:1 correspondence, i.e. there is a single
            % bounding box corresponding to a single semantic segmentation
            % box, this is a trivial case, where we can directly use the
            % segmentation box as the truth for the actor's bounding box
            elseif match == 1 && (segmentationBoxWidth>minBoxWidth && segmentationBoxHeight>minBoxHeight)
                
                if  segmentationBoxBottomLeft >= obj.ROI(4)
                    x = find(row>obj.OverlapThreshold);
                    segmentationboxes(i,4) = truth(x,4);
                end
                
                finalBoxes = cat(1,finalBoxes, round(segmentationboxes(i,:)));
                
            % If there are more than 1 bounding boxes inside the semantic
            % segmentation box, we need to refine those boxes using flood
            % fill approach
            elseif match>1
                temp = find(row>obj.OverlapThreshold);
                modify = segmentationboxes(i,:);
                gt = truth(temp,:);
                
                updatedBox = floodFill(obj, modify, match, gt, maskImg);
                finalBoxes = cat(1,finalBoxes, updatedBox);
            end
        end

        % Filter out boxes of the vehicles that have been occluded by other
        % vehicles
        finalBoxes = filterBoxes(obj,finalBoxes);
        boundingBox = finalBoxes;
    end
    


end

function updatedBox = floodFill(obj, modify, match, groundTruth, maskImg)
    
    % Convert bounding box coordinates to integers
    groundTruth = round(groundTruth);
    modify = round(modify);
    for i = 1:match
        % If the left edge of the bounding box is towards the left of the edge
        % of the segmentation box, we need to drag it inside the
        % segmentation box by setting it equal to the value of segmentation
        % box, we do not need to modify the width.
        if groundTruth(i,1) < modify(1)
            %gt(i,3) = gt(i,3) + abs(modify(1) - gt(i,1));
            groundTruth(i,1) = modify(1);
        end
        % If the right edge of the bounding box falls outside the rightmost
        % edge of the segmentation box, we need to drag it inside the
        % segmentation box by setting it equal to the value of rightmost
        % edge of segmentation box
        if( groundTruth(i,1) + groundTruth(i,3) > modify(1)+modify(3))
            width = groundTruth(i,3);
            groundTruth(i,3) = (modify(1) + modify(3)) - groundTruth(i,1); 
            groundTruth(i,1) = groundTruth(i,1) + (groundTruth(i,3) - width);
            groundTruth(i,3) = (modify(1) + modify(3)) - groundTruth(i,1);
        end
    end

    % Finally, to take care of the pixels that are still inside the
    % segmentation box and have not been assigned to any vehicle box, we
    % iterate over all the pixels inside the segmentation box, and based on
    % unassigned pixels, adjust the height/width of the bounding boxes
    for i = round(modify(1)):round(modify(1)+modify(3))
        for j= round(modify(2)):round(modify(2) +modify(4))
            if maskImg(j,i) == 1
                [minX,ind] = min(groundTruth(:,1));
                % if the pixel value is less than the minimum X value of
                % the box already computed, we adjust the box to include
                % that pixel also.
                if i< round(minX) && j< obj.MinBBoxXValue
                    groundTruth(ind,3) = (groundTruth(ind,1)+groundTruth(ind,3)) - i;
                    groundTruth(ind,1) = i;
                    
                end
                [maxY,ind] = max(groundTruth(:,2)+groundTruth(:,4));
                if j >maxY
                    groundTruth(ind,4) = j - groundTruth(ind,2);
                end
            end
        end
    end
    updatedBox = groundTruth;
end

function updatedBoxes = filterBoxes(obj, boundingBoxes)

nonZeroBbox = boundingBoxes(any(boundingBoxes,2),:);

overlapRatios = bboxOverlapRatio(nonZeroBbox, nonZeroBbox,'Min');
removed = [];

for i = 1:size(overlapRatios,2)
    row = overlapRatios(i,:);
    % Check if a box overlaps another box with ratio > 0.8
    hidden = sum(row>obj.OccludedBBoxOverlapRatio);
    if hidden>0    
        for j = 1:size(row,2)
            ratio = row(j);
            if ratio>obj.OccludedBBoxOverlapRatio && i~=j
                % Compute sizes of both the boxes
                bboxiSize = nonZeroBbox(i,3)*nonZeroBbox(i,4);
                bboxjSize = nonZeroBbox(j,3)*nonZeroBbox(j,4);
                % Remove the box with smaller size
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
        if ~any(removed(:) == k) && nonZeroBbox(k,3) > obj.VehicleLabel &&obj.VehicleLabel
            updatedBoxes = cat(1, updatedBoxes, nonZeroBbox(k,:));
        end
    end
end

