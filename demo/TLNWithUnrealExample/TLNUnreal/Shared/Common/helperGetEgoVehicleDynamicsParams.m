function egoVehDyn = helperGetEgoVehicleDynamicsParams(scenario,egoCarID)
% helperGetEgoVehicleDynamicsParams extracts vehicle dynamics parameters
% from scenario
%
% Scenario is in ISO 8855 (North-West-Up) with respect to rear axle
% Returns struct in SAE J670E (North-East-Down) with respect to
% center of gravity (vehicle center)
%
%  egoVehDyn.X0            % Initial position X (m)
%  egoVehDyn.Y0            % Initial position Y (m)
%  egoVehDyn.Yaw0          % Initial yaw (rad)
%  egoVehDyn.VLong0        % Initial longitudinal velocity(m/sec)
%  egoVehDyn.CGToFrontAxle % Distance center of gravity to front axle (m)
%  egoVehDyn.CGToRearAxle  % Distance center of gravity to rear axle (m)
%
% This is a helper function for example purposes and may be modified in
% the future.

% Copyright 2022 The MathWorks, Inc.

% Ego in ISO 8855 (North-West-Up) with respect to rear axle
ego = scenario.Actors(egoCarID);

% Shift reference position to center of gravity (vehicle center)
position_CG = driving.scenario.internal.Utilities.translateVehiclePosition(...
    ego.Position,...     % Position with respect to rear axle (m)
    ego.RearOverhang,... % (m)
    ego.Length,...       % (m)
    ego.Roll,...         % (deg)
    ego.Pitch,...        % (deg)
    ego.Yaw);            % (deg)

% Translate to SAE J670E (North-East-Down)
% Adjust sign of y position to
egoVehDyn.X0  =  position_CG(1); % (m)
egoVehDyn.Y0  = -position_CG(2); % (m)
egoVehDyn.VX0 =  ego.Velocity(1); % (m)
egoVehDyn.VY0 = -ego.Velocity(2); % (m)

% Adjust sign and unit of yaw
egoVehDyn.Yaw0 = -deg2rad(ego.Yaw); % (rad)

% Longitudinal velocity
egoVehDyn.VLong0 = hypot(egoVehDyn.VX0,egoVehDyn.VY0); % (m/sec)

% Distance from center of gravity to axles
egoVehDyn.CGToFrontAxle = ego.Length/2 - ego.FrontOverhang;
egoVehDyn.CGToRearAxle  = ego.Length/2 - ego.RearOverhang;

end