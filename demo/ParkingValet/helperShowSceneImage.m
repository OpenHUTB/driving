function varargout = helperShowSceneImage(varargin)
%helperShowSceneImage Display scene image
%   helperShowSceneImage(sceneName) displays the scene specified by
%   sceneName on a figure in world coordinates.
%   
%   helperShowSceneImage(sceneImage, sceneRef) displays the scene image
%   sceneImage using the spatial reference sceneRef. sceneImage must be a
%   truecolor RGB image and sceneRef must be an imref2d object.
%
%   hIm = helperShowSceneImage(...) returns the handle to the image object.
%   
%   Example - Display LargeParkingLot scene
%   ---------------------------------------
%   figure
%   helperShowSceneImage('LargeParkingLot')
%
%   See also imshow, imref2d

% Copyright 2019 The MathWorks, Inc.

narginchk(1,2);
nargoutchk(0,1);

if nargin==1
    sceneName = varargin{1};
    [sceneImage, sceneRef] = helperGetSceneImage(sceneName);
elseif nargin==2
    sceneImage = varargin{1};
    sceneRef   = varargin{2};
end

validateattributes(sceneRef, {'imref2d'}, {'scalar'}, mfilename, 'sceneRef');
imageSize = sceneRef.ImageSize;
validateattributes(sceneImage, {'numeric'}, {'real','nonsparse','size',[imageSize 3]}, mfilename, 'sceneImage');

hIm = imshow(sceneImage, sceneRef);

set(gca, 'YDir', 'normal', 'Visible', 'on')

if nargin==1
    title(sceneName)
end

xlabel('X (m)')
ylabel('Y (m)')

if nargout==1
    varargout{1} = hIm;
end
end