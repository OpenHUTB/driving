function hFigure = helperDisplayTrafficLightScene(xlimit, ylimit)
%helperDisplayTrafficLightScene Retrieve scene image and spatial reference
%   hFigure = helperDisplayTrafficLightScene(xlimit, ylimit) retrieves
%   the image of section specified by xlimit and ylimit in
%   USCityBlockScene.
%
%   Example : Read and display image for a section in US City Block scene
%   ---------------------------------------------------------------------
%   % Define the section xlimits and y limits of interest 
%   xlimit = [-110 70];
%   ylimit = [-105 105];
%    
%   Display scene image for US City Block
%   hFigure = helperDisplayTrafficLightScene(xlimit, ylimit);
%   close(hFigure);
%

% Copyright 2020 The MathWorks, Inc.

% Read US City Block scene image
sceneImage = imread('sim3d_USCityBlock.jpg');

% Read spatial reference data
data = load('sim3d_SpatialReferences.mat');
sceneRef = data.spatialReference.USCityBlock;

% Open and get the handle for the new figure window
hFigure = figure;

% Display US City Block scene in the figure window using the spatial
% reference data
imshow(sceneImage, sceneRef);

% Set graphics object properties
set(gca,'YDir','normal');

% Name the x and y labels
xlabel('X (m)');
ylabel('Y (m)');

% Show only selected section in the US City Block scene
xlim(xlimit);
ylim(ylimit);

end