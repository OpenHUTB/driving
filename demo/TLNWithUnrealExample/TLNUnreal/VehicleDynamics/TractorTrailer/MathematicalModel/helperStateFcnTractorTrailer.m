function dxdt = helperStateFcnTractorTrailer(x, u, L1, L2, M1)
% Tractor-Trailer dynamic system
%
% States:
%   x(1): x2 (center of trailer end, global x position) x(2): y2 (center of
%   trailer end, global y position) x(3): theta2 (trailer orientation,
%   global angle, 0 = east) x(4): beta2 (truck orientation in terms of
%   trailer, 0 = aligned)
% 
% Inputs:
%   u(1): alpha (truck steering angle) u(2): v (truck longitudinal
%   velocity)
% 
% Parameters:
%   M1: hitch length L1: truck length L2: trailer length
% 
% Units: length/position in "m", Velocity in "m/s" and angle in "rad"
% 
% All angles are set positive counter-clockwise.
% 
% NOTE: This is a helper function for example purposes and may be removed
% or modified in the future.
% 
% Copyright 2022 The MathWorks, Inc.
% 

% inputs
alpha = u(1);
v = u(2);

theta2 = x(3);
beta2 = x(4);  

% State Equation
dxdt = zeros(4,1);
dxdt(1) = v*cos(beta2)*(1 + M1/L1*tan(beta2)*tan(alpha))*cos(theta2);
dxdt(2) = v*cos(beta2)*(1 + M1/L1*tan(beta2)*tan(alpha))*sin(theta2);
dxdt(3) = v*(sin(beta2)/L2 - M1/L1/L2*cos(beta2)*tan(alpha));
dxdt(4) = v*(tan(alpha)/L1 - sin(beta2)/L2 + M1/L1/L2*cos(beta2)*tan(alpha));