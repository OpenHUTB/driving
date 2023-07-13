function waypoints=helperGenerateWaypoints(scenario,startPositions,goalPositions,varargin)













    traj=helperWaypointsGen(scenario,startPositions,goalPositions,varargin{:});
    waypoints=traj.Path;
end