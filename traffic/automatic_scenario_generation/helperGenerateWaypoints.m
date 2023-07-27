function waypoints=helperGenerateWaypoints(scenario,startPositions,goalPositions,varargin)
%helperGenerateWaypoints 函数的主要功能是调用 helperWaypointsGen 来生成车辆的轨迹

    %调用 helperWaypointsGen 来生成车辆的轨迹。它接受四个输入参数：scenario 表示驾驶场景，startPositions 是一个包含车辆起始位置的数组，goalPositions 是一个包含车辆目标位置的数组，varargin{:} 表示任意其他可选参数。
    traj=helperWaypointsGen(scenario,startPositions,goalPositions,varargin{:});
    %从 traj 结构体中获取车辆的路径（路点）。
    waypoints=traj.Path;
end
