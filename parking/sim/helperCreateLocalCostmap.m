function localCostmap = helperCreateLocalCostmap(costmap, currentPose, nextGoal, localCostmapSize)
%helperCreateSubCostmap Create a local costmap based on the current pose of
%   the vehicle and the goal pose
%
%   Copyright 2019 The MathWorks, Inc.

%#codegen

currentGrid = worldToGrid(costmap, currentPose(1:2));
goalGrid    = worldToGrid(costmap, nextGoal(1:2));

halfGridSize = round(localCostmapSize/(2*costmap.CellSize));

mapLocation = gridToWorld(costmap, currentGrid+[halfGridSize,-halfGridSize]);

localCostmap = vehicleCostmap( ...
    costmap.Costmap(currentGrid(1)-halfGridSize:currentGrid(1)+halfGridSize, ...
    currentGrid(2)-halfGridSize:currentGrid(2)+halfGridSize), ...
    'FreeThreshold',      costmap.FreeThreshold, ...
    'OccupiedThreshold',  costmap.OccupiedThreshold, ...
    'MapLocation',        mapLocation, ...
    'CellSize',           costmap.CellSize, ...
    'CollisionChecker',   costmap.CollisionChecker);
end

%------------------------------------------------------------------
function gridLocations = worldToGrid(costmap, xyPoints)
%worldToGrid - convert world coordinates to grid indices.
%   gridLocations = worldToGrid(cmap, xyPoints) converts
%   xyPoints specified as an M-by-2 matrix to an M-by-2
%   matrix of grid indices.

% Transform to grid coordinates
worldOrigin = [costmap.MapExtent(1), costmap.MapExtent(3)];
cellSize    = costmap.CellSize;

% Translate origin, flip, and take care of resolution.
gridLocations = max( ceil( ...
    flip(xyPoints - worldOrigin, 2)/cellSize ), 1 );

% Adjust Y direction
gridLocations(:,1) = size(costmap.Costmap,1)+1 - gridLocations(:,1);
end

%------------------------------------------------------------------
function xyPoints = gridToWorld(costmap, gridLocations)
%gridToWorld - convert grid indices to world coordinates.
%   xyPoints = gridToWorld(cmap, gridLocations) converts
%   gridLocations specified as an M-by-2 matrix to an M-by-2
%   matrix of world locations.

% Flip
gridLocations = flip(gridLocations,2);

% Adjust Y direction
gridLocations(:,2) = size(costmap.Costmap,1)+1 - gridLocations(:,2);

% Translate origin and take care of resolution
worldOrigin = [costmap.MapExtent(1), costmap.MapExtent(3)];
xyPoints = (gridLocations * costmap.CellSize) - ...
    ([0.5 0.5] * costmap.CellSize - worldOrigin);
end