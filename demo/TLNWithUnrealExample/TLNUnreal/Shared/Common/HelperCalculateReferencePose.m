classdef HelperCalculateReferencePose < matlab.System
    %HelperCalculateReferencePose calculates reference path information in
    %the current section between start and end waypoint.
    %
    %   This is a helper file for example purposes and may be removed or
    %   modified in the future.



    % Copyright 2021 The MathWorks, Inc.

    properties(Nontunable)
        %PredictionHorizon Curvature Prediction Horizon Steps
        PredictionHorizon = 10;
        %Longitudinal Distance From CG to rear axle
        DistanceFromCGToRear  = 1.35;

    end

    % Pre-computed constants
    properties(Access = private)
        % Current way point index
        CurrentIndex = 0;

        % Ego reference path
        ReferencePath;

        % Number of waypoints in the path
        NumWaypoints;
    end

    methods(Access = protected)

        % Calulate reference pose information between current section of path.
        function [CurvatureSequence, LateralDeviation, RelativeYawAngle, IsGoalReached] = stepImpl(obj, EgoActor, EgoReferencePath)
            
            % Initializing outputs with zeros.
            CurvatureSequence = zeros(obj.PredictionHorizon, 1);
            LateralDeviation = 0;
            RelativeYawAngle = 0;
            
            startIndex = obj.CurrentIndex;
            obj.ReferencePath = EgoReferencePath;
            obj.NumWaypoints = EgoReferencePath.numPoints;
            egoCgPosition = EgoActor.Position(1:2) + obj.DistanceFromCGToRear*[cosd(EgoActor.Yaw) sind(EgoActor.Yaw)];
            endIndex = searchEndIndex(obj, startIndex, egoCgPosition);
            startIndex = endIndex - 1;
            obj.CurrentIndex = startIndex;

            % Distance between section start and end points
            DeltaXY = [obj.ReferencePath.x(endIndex) - obj.ReferencePath.x(startIndex),...
                obj.ReferencePath.y(endIndex) - obj.ReferencePath.y(startIndex)];

            % Distance between section starting point and current position
            RXY = [egoCgPosition(1) - obj.ReferencePath.x(startIndex),...
                egoCgPosition(2) - obj.ReferencePath.y(startIndex)];

            % Normalized distance between section starting point and current position
            DeltaSq = DeltaXY.*DeltaXY;
            if norm(DeltaSq)<0.1
                u = 1;
            else
                u = (RXY.*DeltaXY)/DeltaSq;
            end

            if endIndex < (obj.NumWaypoints-obj.PredictionHorizon)
                IsGoalReached = false;
            else
                IsGoalReached = true;
                return;
            end

            % Target States at start point of current section
            XYTarget0 = [obj.ReferencePath.x(startIndex),...
                obj.ReferencePath.y(startIndex)];
            YawTarget0       = obj.ReferencePath.theta(startIndex);
            CurvatureTarget0 = obj.ReferencePath.kappa(startIndex);


            % Target States at end point of current section
            XYTarget1 = [obj.ReferencePath.x(endIndex),...
                obj.ReferencePath.y(endIndex)];
            YawTarget1       = obj.ReferencePath.theta(endIndex);
            CurvatureTarget1 = obj.ReferencePath.kappa(endIndex);


            % Target States on the current section corresponding to current pose
            XYTargetCurr  = XYTarget0  + u*(XYTarget1-XYTarget0);
            delYaw = mod(YawTarget1-YawTarget0+pi,2*pi)-pi;
            YawTargetCurr = YawTarget0 + u*delYaw;

            % Calculate curavture sequence based on prediction horizon size
            RefCurvature0 = CurvatureTarget0 + u*(CurvatureTarget1-CurvatureTarget0);
            curSeqSize = obj.PredictionHorizon - 2;
            CurvatureSequence = [RefCurvature0; obj.ReferencePath.kappa(endIndex:endIndex + curSeqSize)];

            % Distance between current position and target position
            Dist2Ref = [egoCgPosition(1)-XYTargetCurr(1),...
                egoCgPosition(2)-XYTargetCurr(2)];

            CrossProd = DeltaXY(2)*Dist2Ref(1) - DeltaXY(1)*Dist2Ref(2);


            [~, Dist] = ProjectPoint2Line(obj, XYTarget0, XYTarget1, egoCgPosition(1:2));
            LateralDeviation = Dist*sign(CrossProd);

            RelativeYawAngle = mod(YawTargetCurr-deg2rad(EgoActor.Yaw)+pi,2*pi)-pi;
        end

        function endIndex = searchEndIndex(obj, startIndex,egoCgPosition)
            % calculate distance between the current ego position and referencePath position with next index
            minDist = norm([obj.ReferencePath.x(startIndex+1) obj.ReferencePath.y(startIndex+1)] - egoCgPosition);
            endIndex = startIndex;
            for i = startIndex+2:obj.NumWaypoints
                dist = norm([obj.ReferencePath.x(i) obj.ReferencePath.y(i)] - egoCgPosition);
                if dist > minDist % when the distance starts to increase
                    endIndex = i - 1; % this point is the index for the current segment
                    return;
                else
                    minDist = dist;
                end
                endIndex = i;
            end
        end

        % Calculate the distance between the current position from the reference path
        function [ProjPoint,ProjDist] = ProjectPoint2Line(~, p0, p1, q)

            a = [-q(1)*(p1(1)-p0(1)) - q(2)*(p1(2)-p0(2)); ...
                -p0(2)*(p1(1)-p0(1)) + p0(1)*(p1(2)-p0(2))];

            b = [p1(1) - p0(1), p1(2) - p0(2);...
                p0(2) - p1(2), p1(1) - p0(1)];

            ProjPoint = -(b\a);

            ProjDist = norm(ProjPoint' - q);

        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.CurrentIndex = 1;
        end

        function [CurvatureSequence,LateralDeviation,RelativeYawAngle, IsGoalReached] = getOutputSizeImpl(obj)
            % Return size for each output port
            CurvatureSequence = [obj.PredictionHorizon 1];
            IsGoalReached = [1 1];
            LateralDeviation = [1 1];
            RelativeYawAngle = [1 1];
        end

        function [CurvatureSequence, LateralDeviation, RelativeYawAngle, IsGoalReached] = getOutputDataTypeImpl(~)
            % Return data type for each output port
            CurvatureSequence = "double";
            IsGoalReached = "logical";
            LateralDeviation = "double";
            RelativeYawAngle = "double";
        end

        function [CurvatureSequence,LateralDeviation,RelativeYawAngle,IsGoalReached] = isOutputComplexImpl(~)
            % Return true for each output port with complex data
            CurvatureSequence = false;
            IsGoalReached = false;
            LateralDeviation = false;
            RelativeYawAngle = false;
        end

        function [CurvatureSequence,LateralDeviation,RelativeYawAngle, IsGoalReached] = isOutputFixedSizeImpl(~)
            % Return true for each output port with fixed size
            CurvatureSequence = true;
            IsGoalReached = true;
            LateralDeviation = true;
            RelativeYawAngle = true;
        end
    end
end
