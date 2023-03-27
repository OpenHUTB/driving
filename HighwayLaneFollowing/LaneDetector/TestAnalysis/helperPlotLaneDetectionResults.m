function hFigure = helperPlotLaneDetectionResults(...
    logsout, cameraSensorVideoFileName, scenario, cameraParam, scenarioFcnName,...
    varargin)
% helperPlotLaneDetectionResults Visualizes lane marker detections from
% LaneMarkerDetectorTestBench model and records to movie.
%
% Required inputs
%   'logsout'                       Simulation log from 
%                                   LaneMarkerDetectorTestBench model
%   'cameraSensorVideoFileName'     Video file of camera sensor logged from
%                                   LaneMarkerDetectorTestBench model
%   'scenario'                      drivingScenario object that contains
%                                   the test scenario for which the model
%                                   is simulated
%   'cameraParam'                   Camera parameters used for camera
%                                   sensor during the simulation
%   'scenarioFcnName'               Name of the test scenario 
%
% Optional inputs name/value pairs [default value]
%   'RecordVideo'                       Flag to record video [false]
%   'RecordVideoFilename'               Name of generated video file ['DetectionResults']
%   'OpenRecordedVideoInVideoViewer'    Flag to open generated video with Video Viewer app (implay) [false]
%   'ForwardFacingCameraVideoFileName'  Logged video of camera sensor from simulation ['forwardFacingCamera.mp4'];
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2020 The MathWorks, Inc.

defaultRecordVideo = false;
defaultRecordVideoFilename = 'DetectionResults';
defaultOpenRecordedVideoInVideoViewer = false;
defaultVideoViewerJumpToTime = 0;

p = inputParser;
addParameter(p,'RecordVideo',defaultRecordVideo,@islogical);
addParameter(p,'RecordVideoFilename',defaultRecordVideoFilename,@isstring);
addParameter(p,'OpenRecordedVideoInVideoViewer',defaultOpenRecordedVideoInVideoViewer,@islogical);
addParameter(p,'VideoViewerJumpToTime',defaultVideoViewerJumpToTime,@isnumeric);
parse(p,varargin{:});

recordVideo         = p.Results.RecordVideo;
recordVideoFilename = p.Results.RecordVideoFilename;
openRecordedVideoInVideoViewer   = p.Results.OpenRecordedVideoInVideoViewer;
VideoViewerJumpToTime            = p.Results.VideoViewerJumpToTime;

% Get logged signals
hLaneDetections   = logsout.get('lane_detections').Values;
hLeftDeviation = logsout.get('left_lane_distance');
hRightDeviation = logsout.get('right_lane_distance');

% Create video writer
if recordVideo
    pVideoWriter = VideoWriter(recordVideoFilename);
    pVideoWriter.FrameRate = 1 / scenario.SampleTime;
    open(pVideoWriter);
end

% Create figure
[hFigure, videoReader, videoDisplayHandle,hVideoAxes, sensor] = ...
    createFigure(cameraSensorVideoFileName, cameraParam);

numSamples = videoReader.NumFrames;

for sampleIndex = 1:numSamples

    % Camera image
    frame = readFrame(videoReader);
    
    % Lane detections
    laneStrength = hLaneDetections.Left.Strength.Data(sampleIndex);
    laneCurvature = hLaneDetections.Left.Curvature.Data(sampleIndex);
    laneHeadingAngle = hLaneDetections.Left.HeadingAngle.Data(sampleIndex);
    laneLateralOffset = hLaneDetections.Left.LateralOffset.Data(sampleIndex);
    laneXExtent = hLaneDetections.Left.XExtent.Data(1,:,sampleIndex);
    laneBoundaryType = hLaneDetections.Left.BoundaryType.Data(sampleIndex);
    
    if laneStrength > 0
        laneBoundaries.Left = parabolicLaneBoundary([...
            laneCurvature/2,...
            laneHeadingAngle,...
            laneLateralOffset]);
        laneBoundaries.Left.Strength = laneStrength;
        laneBoundaries.Left.XExtent = laneXExtent;
        laneBoundaries.Left.BoundaryType = laneBoundaryType;
    else
        laneBoundaries.Left = parabolicLaneBoundary.empty;
    end
    
    laneStrength = hLaneDetections.Right.Strength.Data(sampleIndex);
    laneCurvature = hLaneDetections.Right.Curvature.Data(sampleIndex);
    laneHeadingAngle = hLaneDetections.Right.HeadingAngle.Data(sampleIndex);
    laneLateralOffset = hLaneDetections.Right.LateralOffset.Data(sampleIndex);
    laneXExtent = hLaneDetections.Right.XExtent.Data(1,:,sampleIndex);
    laneBoundaryType = hLaneDetections.Right.BoundaryType.Data(sampleIndex);
    
    if laneStrength > 0
        laneBoundaries.Right = parabolicLaneBoundary([...
            laneCurvature/2,...
            laneHeadingAngle,...
            laneLateralOffset]);
        laneBoundaries.Right.Strength = laneStrength;
        laneBoundaries.Right.XExtent = laneXExtent;
        laneBoundaries.Right.BoundaryType = laneBoundaryType;
    else
        laneBoundaries.Right = parabolicLaneBoundary.empty;
    end
    
        
    laneDeviation.Left = hLeftDeviation.Values.Data(sampleIndex);
    laneDeviation.Right = hRightDeviation.Values.Data(sampleIndex);
    
    % Simulation time
    simulationTime = (sampleIndex - 1) * scenario.SampleTime;
    
    % Update display
    updateDisplay(frame, videoDisplayHandle, hVideoAxes,...
        laneBoundaries, laneDeviation, sensor, scenarioFcnName, simulationTime)
    
    % Write frame
    if recordVideo && ~isempty(pVideoWriter)
        writeVideo(pVideoWriter, getframe(hFigure));
    end
    
end

% Write movie from recorded frames.
if recordVideo && ~isempty(pVideoWriter)
    close(pVideoWriter);
    
    % If requested, open in movie player and close original figure
    if openRecordedVideoInVideoViewer
        % Open recorded movie
        hVideoViewer = implay(recordVideoFilename + ".avi");
        hVideoViewer.Parent.Position = hFigure.Position;
        
        % Jump to requested time
        VideoViewerDisplayFrame = 1 + round(VideoViewerJumpToTime / scenario.SampleTime);
        hVideoViewerControls = hVideoViewer.DataSource.Controls;
        jumpTo(hVideoViewerControls,VideoViewerDisplayFrame)
        
        % Close original figure when movie is requested
        close(hFigure);
        
        % Return handle to movie player
        hFigure = hVideoViewer;
    end
end
end

%% Create Figure for Visualization
function [hFigure, videoReader, videoDisplayHandle, hVideoAxes, sensor] = ...
    createFigure(videoFileName, cameraParam)
% Creates the display figure

% Define container figure
figureName = 'Lane Detections Plot';

scrsz = double(get(groot,'ScreenSize'));
figurePosition = [10 10 scrsz(3)*.8 scrsz(4)*0.8];
hFigure = figure('Name',figureName,'Position',figurePosition);
% hFigure = figure('Name',figureName);
hFigure.NumberTitle = 'off';

% Bring figure to front
figure(hFigure);

% Read video frame
videoReader = VideoReader(videoFileName);
frame = readFrame(videoReader);

% Define the video objects
hVideoAxes = axes(hFigure, 'Units', 'Normal','Position',[0.1 0.1 0.8 0.8]);
videoDisplayHandle = createVideoDisplay(frame, hVideoAxes);

% Monocamera sensor
camIntrinsics = cameraIntrinsics(cameraParam.FocalLength, cameraParam.PrincipalPoint, cameraParam.ImageSize);
sensor = monoCamera(camIntrinsics, cameraParam.Position(3), 'Pitch', cameraParam.Rotation(2));

% Reset the video reader to the first frame
videoReader.CurrentTime = 0;
end

function videoFrame = createVideoDisplay(frame, hVideoAxes)
% Initialize Video I/O
% Create objects for reading a video from a file and playing the video.
%
% Create a video player and display the first frame
videoFrame = imshow(frame, [], 'Parent', hVideoAxes);
hVideoAxes.Title.Interpreter = 'none';
end


%% Update Display
function updateDisplay(frame, videoDisplayHandle,hVideoAxes, ...
    laneBoundaries, laneDeviation,sensor,scenarioFcnName,simulationTime)
% This helper function updates the display for the forward collision
% warning example.
updateVideoDisplay(videoDisplayHandle,hVideoAxes, frame, laneBoundaries, laneDeviation,sensor,scenarioFcnName,simulationTime);
end
%--------------------------------------------------------------------------

function updateVideoDisplay(videoDisplayHandle, hVideoAxes, frame, laneBoundaries, laneDeviation,sensor, scenarioFcnName, simulationTime)
% updates the video display with a new annotated frame

% Call the helper function to annotate the frame
annotatedFrame = annotateVideoFrame( frame, laneBoundaries,laneDeviation,sensor);

% Display the annotated frame
if isvalid(videoDisplayHandle)
    set(videoDisplayHandle, 'CData', annotatedFrame);
    hVideoAxes.Title.String = scenarioFcnName +"( " + num2str(simulationTime,'%4.1f') + " sec)";
end
end

function annotatedFrame = annotateVideoFrame(frame, laneBoundaries,laneDeviation,sensor)
% annotates a video frame
annotatedFrame = frame;

if ~isempty(laneBoundaries.Left)
    % XY points for left lane marker
    xRangeVehicle = laneBoundaries.Left.XExtent;
    xPtsInVehicle = linspace(xRangeVehicle(1), xRangeVehicle(2), 100)';
    % Display the left lane boundary on the video frame
    annotatedFrame = insertLaneBoundary(annotatedFrame, laneBoundaries.Left, sensor, xPtsInVehicle,'Color','red');
    
    text = "Left Lane Deviation : %.2f m";
    textStr = sprintf(text,laneDeviation.Left);
    if(laneDeviation.Left < 0.5)
        annotatedFrame = insertText(annotatedFrame,[680 50], textStr,'Font','LucidaSansRegular','BoxColor','w','FontSize',20);
    else
        annotatedFrame = insertText(annotatedFrame,[680 50], textStr,'Font','LucidaSansRegular','BoxColor','r','FontSize',20);
    end
else
    textStr = "Left Lane : No detection";
    annotatedFrame = insertText(annotatedFrame,[680 50], textStr,'Font','LucidaSansRegular','BoxColor','r','FontSize',20);
end

if ~isempty(laneBoundaries.Right)
    % XY points for right lane marker
    xRangeVehicle = laneBoundaries.Right.XExtent;
    xPtsInVehicle = linspace(xRangeVehicle(1), xRangeVehicle(2), 100)';
    
    % Display the right lane boundary on the video frame
    annotatedFrame = insertLaneBoundary(annotatedFrame, laneBoundaries.Right, sensor, xPtsInVehicle,'Color','green');
    
    text = "Right Lane Deviation : %.2f m";
    textStr = sprintf(text,laneDeviation.Right);
    if(laneDeviation.Right < 0.5)
        annotatedFrame = insertText(annotatedFrame,[680 100], textStr,'Font','LucidaSansRegular','BoxColor','w','FontSize',20);
    else
        annotatedFrame = insertText(annotatedFrame,[680 100], textStr,'Font','LucidaSansRegular','BoxColor','r','FontSize',20);
    end
else
    textStr = "Right Lane : No detection";
    annotatedFrame = insertText(annotatedFrame,[680 100], textStr,'Font','LucidaSansRegular','BoxColor','r','FontSize',20);
end

end
%--------------------------------------------------------------------------

