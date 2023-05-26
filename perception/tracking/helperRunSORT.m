function trackLog = helperRunSORT(tracker, convertedDets, detectionScoreThreshold, showAnimation)

release(tracker);

trackLog = objectTrack.empty;
reader = VideoReader("PedestrianTrackingVideo.avi");
for i=1:reader.NumFrames

    % Parse detections set to retrieve detections on the ith frame
    curFrameDetections = convertedDets{i};
    attributes = [curFrameDetections.ObjectAttributes];
    scores = [attributes.Score];
    highScoreDetections = curFrameDetections(scores > detectionScoreThreshold);

    % Calculate association cost matrix
    iouCost = helperSORTCost(tracker,highScoreDetections );
    % Update tracker
    tracks = tracker(highScoreDetections, reader.CurrentTime, iouCost);

    % Advance reader
    frame = readFrame(reader);
    % Display results
    if showAnimation
        frame = helperAnnotateTrack(tracks, frame);
        % frame = helperAnnotateConvertedDetection(highScoreDetections, frame);    % %uncomment to show detections
        imshow(frame);
    end

    % Log tracks for evaluation
    trackLog = [trackLog ; tracks]; %#ok<AGROW>
end