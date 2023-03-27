function collision = helperSLDetectVehicleCollision(targetPoses, vehicleProfiles, nvp)
% helperSLDetectVehicleCollision detects collision of vehicles in ego coordinates
%
% targetPoses:     Array of poses of target vehicles
% vehicleProfiles: Array of vehicle profiles, first vehicle is ego
% collision:       Returns true if collision detected
%
% This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2019-2021 The MathWorks, Inc.

arguments
    targetPoses;
    vehicleProfiles;
    nvp.egoActorID = 1;
    nvp.NumTargetActors = numel(targetPoses);
end

% Default no collision
collision = false;

% Ego polyshape
egoProfile = vehicleProfiles(nvp.egoActorID);
p1 = vehicle2polyshape(...
    [0 0],... % Position [x y] (m)
    0,...     % Yaw (deg)
    egoProfile.Width,...
    egoProfile.Length,...
    egoProfile.Length/2 + egoProfile.OriginOffset(1));

    % Remove actor profile for ego actor
    vehicleProfiles(nvp.egoActorID) = [];

% Compare overlap of ego and target polyshapes
for n = 1:nvp.NumTargetActors

    targetProfile = vehicleProfiles(n);
    p2 = vehicle2polyshape(...
        targetPoses(n).Position,...
        targetPoses(n).Yaw,...
        targetProfile.Width,...
        targetProfile.Length,...
        targetProfile.Length/2 + targetProfile.OriginOffset(1));
    
    overlapRatio = area(intersect(p1,p2))/area(union(p1,p2));
    
    if overlapRatio > 0
        collision = true; % collision detected
        return;
    end
end

end

% Construct cuboid based on vehicle position and yaw.
function pshape = vehicle2polyshape(position,yaw,width,length,rearOverhang)

x = position(1);
y = position(2);

ycoord = [y-width/2, y+width/2, y+width/2, y-width/2];
xcoord = [x-rearOverhang, x-rearOverhang, x+length-rearOverhang, x+length-rearOverhang];
pshape = rotate(polyshape(xcoord, ycoord), yaw, [x, y]);

end
