function frame = helperAnnotateTrack(tracks, frame)
%helperAnnotateTrack Annotate video frame with tracks
% frame = helperAnnotateTrack(tracks, frame) annotate an image, frame, with
% tracks bounding boxes. Specify tracks as an array of objectTrack. The
% State property of each objectTrack must follow the [u,v,s,r] convention
% as defined in the
if isempty(tracks)
    return
end
states = [tracks.State];
trackPositions = helperBBMeasurementFcn(states); % convert states to [x, y, w, h]
tracklabels = [tracks.TrackID];
trackColors = getTrackColors(tracks);
frame = insertObjectAnnotation(frame, 'Rectangle',trackPositions', tracklabels,'Color',trackColors, 'TextBoxOpacity',0.8);
end

function colors = getTrackColors(tracks)
colors = zeros(numel(tracks), 3);
coloroptions = 255*lines(7);
for i=1:numel(tracks)
    colors(i,:) = coloroptions(mod(tracks(i).TrackID, 7)+1,:);
end
end