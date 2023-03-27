function helperAddVehicle(scenario, passVehMesh, defaultVehiclePosition)
%helperAddVehicle sets the vehicle profiles to be similar with Simulation
%3D vehicle profiles.
% helperAddVehicle accepts following inputs:
%   scenario                driving scenario object.
%   passVehMesh             string that represents the type of vehicle in
%                           simulation3D. Valid vehicle types are:
%                           "Hatchback"
%                           "Muscle car"
%                           "Small pickup truck"
%                           "Sport utility vehicle"
%                           "Sedan" [default]
%
% defaultVehiclePosition    default position of the vehicle.

%   This is a helper function for example purposes and
%   may be removed or modified in the future.

%   Copyright 2020 The MathWorks, Inc.
%
%% Check vehicle mesh and update vehicleProfile
switch passVehMesh
    case "Hatchback"
        % https://www.mathworks.com/help/vdynblks/ref/hatchback.html
        vehicleProfile.Length = 0.589 + 1.343 + 1.104 + 0.828;
        vehicleProfile.Width = 1.653;
        vehicleProfile.Height = 1.286 + 0.227;
        vehicleProfile.FrontOverhang = 0.828;
        vehicleProfile.RearOverhang = 0.589;
    case "Muscle car"
        % https://www.mathworks.com/help/vdynblks/ref/musclecar.html
        vehicleProfile.Length = 0.945 + 1.529 + 1.491 + 0.983;
        vehicleProfile.Width = 2.009;
        vehicleProfile.Height = 1.129 + 0.241;
        vehicleProfile.FrontOverhang = 0.983;
        vehicleProfile.RearOverhang = 0.945;
    case "Small pickup truck"
        % https://www.mathworks.com/help/vdynblks/ref/smallpickuptruck.html
        vehicleProfile.Length = 1.321 + 1.750 + 1.947 + 1.124;
        vehicleProfile.Width = 2.073;
        vehicleProfile.Height = 1.502 + 0.488;
        vehicleProfile.FrontOverhang = 1.124;
        vehicleProfile.RearOverhang = 1.321;
    case "Sport utility vehicle"
        % https://www.mathworks.com/help/vdynblks/ref/sportutilityvehicle.html
        vehicleProfile.Length = 0.939 + 1.474 + 1.422 + 0.991;
        vehicleProfile.Width = 1.935;
        vehicleProfile.Height = 1.426 + 0.348;
        vehicleProfile.FrontOverhang = 0.991;
        vehicleProfile.RearOverhang = 0.939;
    otherwise % case "Sedan"
        % https://www.mathworks.com/help/vdynblks/ref/sedan.html
        vehicleProfile.Length = 1.119 + 1.305 + 1.513 + 0.911;
        vehicleProfile.Width = 1.842;
        vehicleProfile.Height = 1.246 + 0.271;
        vehicleProfile.FrontOverhang = 0.911;
        vehicleProfile.RearOverhang = 1.119;
end

% add vehicle to scenario
vehicle(scenario,...
    'ClassID',  1, ...
    'Position', defaultVehiclePosition, ...
    'Roll',     0, ...
    'Pitch',    0, ...
    'Yaw',      0, ...
    'Length',   vehicleProfile.Length, ...
    'Width',    vehicleProfile.Width, ...
    'Height',   vehicleProfile.Height, ...
    'RearOverhang',  vehicleProfile.RearOverhang,...
    'FrontOverhang', vehicleProfile.FrontOverhang);
end