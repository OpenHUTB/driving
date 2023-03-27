function [tractorTrailerParameters,vehicleDimension] = helperInitTractorTrailerParams()
% helperInitializeVehicleParameters initializes the parameters for a two
% axle tractor towing a single axle trailer.

% NOTE: This is a helper function for example purposes and may be removed or
% modified in the future.

% Copyright 2022 The MathWorks, Inc

tractorTrailerParameters = struct;

% Common Parameters
tractorTrailerParameters.CzWhlAxl = 557955.087061454;
tractorTrailerParameters.F0zWhlAxl = 16132.238006786356;
tractorTrailerParameters.Hmax = 0.25;
tractorTrailerParameters.KzWhlAxl = 5.8428920084843889E+7;

% Hitch Parameters
tractorTrailerParameters.HTCH = struct;
tractorTrailerParameters.HTCH.F0z = 41297.816939606848;
tractorTrailerParameters.HTCH.Kz = 1.4957545534771611E+6;
tractorTrailerParameters.HTCH.Cz = 142834.03850286055;
tractorTrailerParameters.HTCH.Cxy = 254469.00494077324;
tractorTrailerParameters.HTCH.Kxy = 2.6647931882941267E+6;

% Tractor Parameters
tractorTrailerParameters.TRA = struct;
tractorTrailerParameters.TRA.Mass = 7500;
tractorTrailerParameters.TRA.StaticNormalFrontLoad = struct;
tractorTrailerParameters.TRA.StaticNormalFrontLoad.FR = 264.66666666666669;
tractorTrailerParameters.TRA.StaticNormalFrontLoad.FL = 264.66666666666669;
tractorTrailerParameters.TRA.StaticNormalRearLoad = struct;
tractorTrailerParameters.TRA.StaticNormalRearLoad.RR = 322;
tractorTrailerParameters.TRA.StaticNormalRearLoad.RL = 322;
tractorTrailerParameters.TRA.WheelBase = 3.075;
tractorTrailerParameters.TRA.FrontAxlePositionfromCG = 3.19;
tractorTrailerParameters.TRA.RearAxlePositionfromCG = 5.82;
tractorTrailerParameters.TRA.HeightCG = 1.5;
tractorTrailerParameters.TRA.FrontalArea = 8.16;
tractorTrailerParameters.TRA.DragCoefficient = 0.15;
tractorTrailerParameters.TRA.NumberOfWheelsPerAxle = 4;
tractorTrailerParameters.TRA.Thread = struct;
tractorTrailerParameters.TRA.Thread.FR = 1.705;
tractorTrailerParameters.TRA.Thread.RR = 1.705;
tractorTrailerParameters.TRA.PitchMomentInertia = 24419.983065198983;
tractorTrailerParameters.TRA.RollMomentInertia = 5491.1092294665541;
tractorTrailerParameters.TRA.YawMomentInertia = 26240.474174428451;
tractorTrailerParameters.TRA.SteeringRatio = 18;
tractorTrailerParameters.TRA.TrackWidth = 2.55;
tractorTrailerParameters.TRA.SprungMass = 1096.7226666666666;
tractorTrailerParameters.TRA.InitialLongPosition = -3.19;
tractorTrailerParameters.TRA.InitialLatPosition = 0;
tractorTrailerParameters.TRA.InitialVertPosition = 0;
tractorTrailerParameters.TRA.InitialRollAngle = 0;
tractorTrailerParameters.TRA.InitialPitchAngle = 0;
tractorTrailerParameters.TRA.InitialYawAngle = 0;
tractorTrailerParameters.TRA.InitialLongVel = 0;
tractorTrailerParameters.TRA.InitialLatVel = 0;
tractorTrailerParameters.TRA.InitialVertVel = 0;
tractorTrailerParameters.TRA.InitialRollRate = 0;
tractorTrailerParameters.TRA.InitialPitchRate = 0;
tractorTrailerParameters.TRA.InitialYawRate = 0;
tractorTrailerParameters.TRA.MiddleAxlePositionFromCG = 4.51;
tractorTrailerParameters.TRA.HitchHeight = 0.43;
tractorTrailerParameters.TRA.HitchDistance = 3.19;
tractorTrailerParameters.TRA.F0z = [7991.658831458536 5372.9175269733869 2774.0151717646404];
tractorTrailerParameters.TRA.Kz = [289447.7474310745 194600.25860883188 100471.31136857595];
tractorTrailerParameters.TRA.Cz = [27640.223862281971 18582.955850734055 9594.303505940281];
tractorTrailerParameters.TRA.NumAxle = 3;

% Trailer Parameters
tractorTrailerParameters.VEH = struct;
tractorTrailerParameters.VEH.Mass = 5500;
tractorTrailerParameters.VEH.StaticNormalFrontLoad = struct;
tractorTrailerParameters.VEH.StaticNormalFrontLoad.FR = 264.66666666666669;
tractorTrailerParameters.VEH.StaticNormalFrontLoad.FL = 264.66666666666669;
tractorTrailerParameters.VEH.StaticNormalRearLoad = struct;
tractorTrailerParameters.VEH.StaticNormalRearLoad.RR = 322;
tractorTrailerParameters.VEH.StaticNormalRearLoad.RL = 322;
tractorTrailerParameters.VEH.WheelBase = 3.075;
tractorTrailerParameters.VEH.FrontAxlePositionfromCG = 2.3;
tractorTrailerParameters.VEH.RearAxlePositionfromCG = 2.3;
tractorTrailerParameters.VEH.HeightCG = 1.3;
tractorTrailerParameters.VEH.FrontalArea = 8.16;
tractorTrailerParameters.VEH.DragCoefficient = 0.55;
tractorTrailerParameters.VEH.Thread = struct;
tractorTrailerParameters.VEH.Thread.FR = 1.705;
tractorTrailerParameters.VEH.Thread.RR = 1.705;
tractorTrailerParameters.VEH.PitchMomentInertia = 29303.979678238782;
tractorTrailerParameters.VEH.RollMomentInertia = 6589.3310753598644;
tractorTrailerParameters.VEH.YawMomentInertia = 31488.569009314142;
tractorTrailerParameters.VEH.SteeringRatio = 18;
tractorTrailerParameters.VEH.TrackWidth = 2.55;
tractorTrailerParameters.VEH.SprungMass = 1096.7226666666666;
tractorTrailerParameters.VEH.InitialLongPosition = 3.1;
tractorTrailerParameters.VEH.InitialLatPosition = 0;
tractorTrailerParameters.VEH.InitialVertPosition = 0;
tractorTrailerParameters.VEH.InitialRollAngle = 0;
tractorTrailerParameters.VEH.InitialPitchAngle = 0;
tractorTrailerParameters.VEH.InitialYawAngle = 0;
tractorTrailerParameters.VEH.InitialLongVel = 0;
tractorTrailerParameters.VEH.InitialLatVel = 0;
tractorTrailerParameters.VEH.InitialVertVel = 0;
tractorTrailerParameters.VEH.InitialRollRate = 0;
tractorTrailerParameters.VEH.InitialPitchRate = 0;
tractorTrailerParameters.VEH.InitialYawRate = 0;
tractorTrailerParameters.VEH.MiddleAxlePositionFromCG = 0.9;
tractorTrailerParameters.VEH.HitchHeight = 0.43;
tractorTrailerParameters.VEH.HitchDistance = 1.61;
tractorTrailerParameters.VEH.NumberOfWheelsPerFrontAxle = 2;
tractorTrailerParameters.VEH.NumberOfWheelsPerRearAxle = 4;
tractorTrailerParameters.VEH.NumberOfWheelsPerMiddleAxle = 4;
tractorTrailerParameters.VEH.F0z = [11443.119467618786 16898.319495084248 19284.969507100392];
tractorTrailerParameters.VEH.Kz = [414455.27434789605 612035.70076953247 698477.13732899853];
tractorTrailerParameters.VEH.Cz = [39577.563361785164 58445.104275709928 66699.653425552024];

% Overall Vehicle Dimension
vehicleDimension.TractorLength = 6.89;
vehicleDimension.TrailerLength = 13.69;
vehicleDimension.InterConnection = 0;
vehicleDimension.Width = 2.54;
vehicleDimension.TrailerHitchToFront = 1.7;
vehicleDimension.TractorEndToHitch = 1.68;
vehicleDimension.TireRadius = 0.51;
vehicleDimension.Overlap = vehicleDimension.TrailerHitchToFront + vehicleDimension.TractorEndToHitch; 
end