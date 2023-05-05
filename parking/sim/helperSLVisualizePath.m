function helperSLVisualizePath(pose, steer, refPoses, costmapStruct, vehicleDimsStruct, varargin)

%helperSLVisualizePath visualize reference path and vehicle position.

% Copyright 2017-2019 The MathWorks, Inc.

if nargin == 7
    isParkingManeuver = varargin{1};
    parkCostmapSize   = varargin{2};
else
    isParkingManeuver = false;
    parkCostmapSize   = 0;
end

persistent pathPoints vehicleDims costmap vehicleBodyHandle axesHandle isParkingMode

if isempty(costmap)
    % Initialize vehicle dimensions object
    vehicleDims = vehicleDimensions( ...
        vehicleDimsStruct.Length, ...
        vehicleDimsStruct.Width, ...
        vehicleDimsStruct.Height, ...
        'Wheelbase',        vehicleDimsStruct.Wheelbase, ...
        'RearOverhang',     vehicleDimsStruct.RearOverhang, ...
        'WorldUnits',       char(vehicleDimsStruct.WorldUnits));
    
    ccConfig = inflationCollisionChecker(vehicleDims, 5);
    
    % Initialize vehicleCostmap object
    costmap = vehicleCostmap(costmapStruct.Costs, ...
        'FreeThreshold',     costmapStruct.FreeThreshold, ...
        'OccupiedThreshold', costmapStruct.OccupiedThreshold, ...
        'MapLocation',       costmapStruct.MapExtent([1, 3]), ...
        'CellSize',          costmapStruct.CellSize, ...
        'CollisionChecker',  ccConfig);
end

if isempty(pathPoints)
    pathPoints = zeros(size(refPoses, 1), 2);
end

if isempty(isParkingMode)
    isParkingMode = false;
end

if isempty(axesHandle)
    axesHandle = 0;
end

% Plot smooth path and map
if ~isequal(pathPoints, refPoses(:,1:2))
    % Initialize figure
    if ~any(pathPoints)
        % Plot path
        fh1=figure;
        fh1.Name        = 'Automated Parking Valet';
        fh1.NumberTitle = 'off';
        axesHandle      = axes(fh1);
        plot(costmap, 'Parent', axesHandle, 'Inflation', 'off');
        legend off
        axis tight
        title(axesHandle, 'Global costmap');
        hold(axesHandle, 'on');
        
        axesHandle.XLim = costmap.MapExtent(1:2);
        axesHandle.YLim = costmap.MapExtent(3:4);
    end
    
    % Plot smooth path
    plot(axesHandle, refPoses(:,1), refPoses(:,2),'b', 'LineWidth', 2);
    
    % Update path points for the new path segment
    pathPoints = refPoses(:,1:2);
end

% Plot trajectory
plot(axesHandle, pose(1), pose(2), 'r.');

% Plot vehicle
if isempty(vehicleBodyHandle) 
    vehicleBodyHandle = helperPlotVehicle(pose, vehicleDims, steer, 'Parent', axesHandle);
else
    vehicleShapes = helperVehiclePolyshape(pose, vehicleDims, steer);    
    for n = 1 : numel(vehicleBodyHandle)
        vehicleBodyHandle(n).Shape = vehicleShapes(n);
    end
end

% Plot the local costmap with the planned parking maneuver path
if isParkingManeuver && ~isParkingMode % Draw once
    isParkingMode   = isParkingManeuver;
    fh2=figure;
    fh2.Name        = 'Parking Maneuver';
    fh2.NumberTitle = 'off';
    localMapAxes    = axes(fh2);
    plot(costmap, 'Parent', localMapAxes, 'Inflation', 'off');
    legend off
    axis tight
    title(localMapAxes, 'Local costmap');
    hold(localMapAxes, 'on');
    
    % Plot smooth path
    plot(localMapAxes, refPoses(:,1), refPoses(:,2),'b', 'LineWidth', 2);
    
    % Plot vehicle
    helperPlotVehicle(pose, vehicleDims, steer, 'Parent', localMapAxes);
    
    localMapAxes.XLim = [pose(1)-parkCostmapSize/2, pose(1)+parkCostmapSize/2];
    localMapAxes.YLim = [pose(2)-parkCostmapSize/2, pose(2)+parkCostmapSize/2];
end

drawnow('limitrate');

end


