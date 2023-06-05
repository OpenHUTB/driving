function ds = helperCreateCFSMScenario(out, currScenario)
% helperCreateCFSMScenario converts a collision prone drivingScenario to
% collision free drivingScenario.
%
%   Copyright 2022 The MathWorks, Inc.

vehicles = createVehicleStruct(out);
ds = drivingScenario;
ds.SampleTime = currScenario.SampleTime;
ds.StopTime = currScenario.StopTime;
ds.VerticalAxis = 'Y';
% ds.Scene = currScenario.Scene;
% ds.RoadHistory = currScenario.RoadHistory;
for i = 1 : numel(vehicles)
    oldActor = currScenario.Actors(i);
    waypoints = vehicles(i).Position;

    n = size(waypoints,1);

    % find the course angles at each waypoint
    course = NaN(n,1);
    course = matlabshared.tracking.internal.scenario.clothoidG2fitMissingCourse(waypoints,course);

    % obtain the (horizontal) initial positions
    hip = complex(waypoints(:,1), waypoints(:,2));

    % obtain the starting curvature, final curvature, and length of each segment.
    [~, ~, hl] = matlabshared.tracking.internal.scenario.clothoidG1fit2(hip(1:n-1),course(1:n-1),hip(2:n),course(2:n));

    % report cumulative horizontal distance traveled from initial point.
    hcd = [0; cumsum(hl)];

    % Fetch the Scaled velocity used to avoid collisions
    Velocity = vehicles(i).Speed';

    % Find positions that were repeated because the actor was stopped
    [~,idx] = unique(hcd,'rows','stable');

    % Remove those waypoints and velocity from trajectory and add waitTime
    waypoints = waypoints(idx,:);
    Velocity = Velocity(idx);
    d = diff(idx);
    waitTime = [ds.SampleTime*(d-ones(size(d)));0];

    newActor =  vehicle(ds, 'Position', waypoints(1,:), 'Length', ...
        oldActor.Length, 'ClassID', oldActor.ClassID,...
        'Width', oldActor.Width, 'Height', oldActor.Height, ...
        'Mesh', driving.scenario.carMesh);

    trajectory(newActor, waypoints, Velocity, waitTime);
end
end

function vehicles = createVehicleStruct(out)
numActors =  numel(out{1});
for i = 1 : numActors
    Position = [];
    Speed = [];
    for j = 1:numel(out)
        Position = [Position;out{j}(i).Position];
        Speed = [Speed;out{j}(i).Speed];
    end
    vehicles(i).Position = Position; %#ok<*AGROW>
    vehicles(i).Speed = Speed;
end
end
