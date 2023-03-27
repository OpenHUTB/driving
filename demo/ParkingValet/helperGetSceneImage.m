function [sceneImage, sceneRef] = helperGetSceneImage(sceneName)
%helperGetSceneImage Retrieve scene image and spatial reference
%   [sceneImage, sceneRef] = helperGetSceneImage(sceneName) retrieves the
%   image and spatial reference associated with the scene specified by
%   sceneName. sceneName must be a string scalar or character vector
%   specifying the name of a scene. sceneImage is a truecolor RGB image.
%   sceneRef is a spatial referencing object of type imref2d describing the
%   relationship between intrinsic image coordinates and world coordinates.
%
%   Example : Read and display image for Virtual M-City
%   ---------------------------------------------------
%   % Get scene image and spatial reference for Virtual M-City
%   sceneName = 'VirtualMCity';
%   [sceneImage, sceneRef] = helperGetSceneImage(sceneName);
%
%   % Display image
%   figure
%   imshow(sceneImage, sceneRef)
%   xlabel('X (m)')
%   ylabel('Y (m)')
%   title(sceneName)
%
%   % Set Y-direction back to normal
%   set(gca, 'YDir', 'normal')
%
%   See also imref2d.

% Copyright 2019 The MathWorks, Inc.

% Validate scene name
supportedScenes = {'LargeParkingLot', 'ParkingLot', 'DoubleLaneChange', ...
    'USCityBlock', 'USHighway', 'CurvedRoad', 'VirtualMCity', 'StraightRoad'};

sceneName = validatestring(sceneName, supportedScenes, mfilename, 'sceneName');

% Read image
imageName = strcat('sim3d_', sceneName, '.jpg');
sceneImage = imread(imageName);

% Read spatial reference
data = load('sim3d_SpatialReferences.mat');
sceneRef = data.spatialReference.(sceneName);
end