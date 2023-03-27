function  helperPlotLaneBoundaryParams(logsout)
% helperPlotLaneBoundaryParams A helper function for plotting the detected
% parabolic lane boundary parametes along with corresponding ground truth
% from LaneMarkerDetectorTestBench.slx.
%
% This is a helper function for example purposes and may be removed or
% modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the elements to be plotted.

% Copyright 2020 The MathWorks, Inc.
 
%% Get the data from simulation
hLaneDetections = logsout.get('lane_detections'); 
hLaneBoundaries = logsout.get('lane_boundaries');
tmax = hLaneDetections.Values.Left.Curvature.Time(end);  

% Get the detected lane boudary parameters
left_offset = getLaneOffset(hLaneDetections.Values.Left);
right_offset = getLaneOffset(hLaneDetections.Values.Right);

left_headingangle = getLaneHeadingAngle(hLaneDetections.Values.Left);
right_headingangle = getLaneHeadingAngle(hLaneDetections.Values.Right);

% Get the lane boudary parameters from ground truth
left_curvature = getLaneCurvature(hLaneDetections.Values.Left);
right_curvature = getLaneCurvature(hLaneDetections.Values.Right);
numSamples = size(hLaneBoundaries.Values.LaneBoundaries(1).Coordinates.Data,3);
leftTruthParams = zeros(numSamples,3);
rightTruthParams = zeros(numSamples,3);
for i = 1:size(hLaneBoundaries.Values.LaneBoundaries(1).Coordinates.Data,3)
    leftTruthParams(i,:) = polyfit(hLaneBoundaries.Values.LaneBoundaries(1).Coordinates.Data(:,1,i), hLaneBoundaries.Values.LaneBoundaries(1).Coordinates.Data(:,2,i),2);
    rightTruthParams(i,:) = polyfit(hLaneBoundaries.Values.LaneBoundaries(2).Coordinates.Data(:,1,i), hLaneBoundaries.Values.LaneBoundaries(2).Coordinates.Data(:,2,i),2);
end
%% Plot the detected left lane boundary parameters along with corresponding ground truth
figure('Name','Left lane detections and ground truth','position',[835 100 720 600]);
subplot(3,1,1)
plot(left_offset.Time,left_offset.Data(:),'r')
grid on
hold on
plot(left_offset.Time,leftTruthParams(:,3),'b')
xlim([0,tmax])
ylim([0 2.5]);
legend('detections','ground truth','location','NorthEast')
title('Left lane boundary lateral offsets')
xlabel('time (sec)')
ylabel('lateral offset')

subplot(3,1,2)
plot(left_headingangle.Time,left_headingangle.Data(:),'r')
grid on
hold on
plot(left_headingangle.Time,leftTruthParams(:,2),'g')
xlim([0,tmax])
ylim([-0.1 0.1]);
legend('detections','ground truth','location','NorthEast')
title('Left lane boundary heading angles')
xlabel('time (sec)')
ylabel('heading angle')

subplot(3,1,3)
plot(left_curvature.Time,left_curvature.Data(:),'r')
grid on
hold on
plot(left_curvature.Time,leftTruthParams(:,1),'g')
xlim([0,tmax])
ylim([-0.01 0.01]);
legend('detections','ground truth','location','NorthEast')
title('Left lane boundary curvatures')
xlabel('time (sec)')
ylabel('curvature')
%% Plot the detected left lane boundary parameters along with corresponding ground truth
figure('Name','Right lane detections and ground truth','position',[835 100 720 600]);
subplot(3,1,1)
plot(right_offset.Time,right_offset.Data(:),'r')
grid on
hold on
plot(right_offset.Time,rightTruthParams(:,3),'b')
xlim([0,tmax])
ylim([-2.5 0]);
legend('detections','ground truth','location','NorthEast')
title('Right lane boundary lateral offsets')
xlabel('time (sec)')
ylabel('lateral offset')

subplot(3,1,2)
plot(right_headingangle.Time,right_headingangle.Data(:),'r')
grid on
hold on
plot(right_headingangle.Time,rightTruthParams(:,2),'g')
xlim([0,tmax])
ylim([-0.1 0.1]);
legend('detections','ground truth','location','NorthEast')
title('Right lane boundary heading angles')
xlabel('time (sec)')
ylabel('heading angle')

subplot(3,1,3)
plot(right_curvature.Time,right_curvature.Data(:),'r')
grid on
hold on
plot(right_curvature.Time,rightTruthParams(:,1),'g')
xlim([0,tmax])
ylim([-0.01 0.01]);
legend('detections','ground truth','location','NorthEast')
title('Right lane boundary curvatures')
xlabel('time (sec)')
ylabel('curvature')

end

function offset = getLaneOffset(lane_detections)
offset = lane_detections.LateralOffset;
for n = 1:numel(offset.Time)
    % Remove offsets for undetected (zero strength) lanes
    if lane_detections.Strength.Data(n) <= 0
        offset.Data(n) = nan;
    end
end
end

function headingAngle = getLaneHeadingAngle(lane_detections)
headingAngle = lane_detections.HeadingAngle;
for n = 1:numel(headingAngle.Time)
    % Remove heading angles for undetected (zero strength) lanes
    if lane_detections.Strength.Data(n) <= 0
        headingAngle.Data(n) = nan;
    end
end
end

function curvature = getLaneCurvature(lane_detections)
curvature = lane_detections.Curvature;
for n = 1:numel(curvature.Time)
    % Remove curvatures for undetected (zero strength) lanes
    if lane_detections.Strength.Data(n) <= 0
        curvature.Data(n) = nan;
    end
end
end