function cmap = sim3dColormap
% Define colormap for object labels used in 3D simulation environment.

cmap = [
128 0 0     % Label 1: Building
0 0 0       % Label 2: Not used
72 0 90     % Label 3: Other
255 255 0   % Label 4: Pedestrian
192 192 192 % Label 5: Pole
0 0 0       % Label 6: Not used
128 64 128  % Label 7: Roads
60 40 222   % Label 8: Sidewalk
128 128 0   % Label 9: Vegetation
64 0 128    % Label 10: Vehicle
0 0 0       % Label 11: Not used
192 128 128 % Label 12: Generic traffic signs
192 128 128 % Label 13: Stop sign
192 128 128 % Label 14: Yield sign
192 128 128 % Label 15: Speed limit sign
192 128 128 % Label 16: Weight limit sign
0 0 0       % Label 17: Not used
0 0 0       % Label 18: Not used
192 128 128 % Label 19: Left and right arrow warning sign
192 128 128 % Label 20: Left chevron warning sign
192 128 128 % Label 21: Right chevron warning sign
0 0 0       % Label 22: Not used
192 128 128 % Label 23: Right one-way sign
0 0 0       % Label 24: Not used
192 128 128 % Label 25: School bus only sign
0 0 0       % Label 26: Not used
0 0 0       % Label 27: Not used
0 0 0       % Label 28: Not used
0 0 0       % Label 29: Not used
0 0 0       % Label 30: Not used
0 0 0       % Label 31: Not used
0 0 0       % Label 32: Not used
0 0 0       % Label 33: Not used
0 0 0       % Label 34: Not used
0 0 0       % Label 35: Not used
0 0 0       % Label 36: Not used
0 0 0       % Label 37: Not used
0 0 0       % Label 38: Not used
192 128 128 % Label 39: Crosswalk sign
0 0 0       % Label 40: Not used
192 128 128 % Label 41: Traffic signal
192 128 128 % Label 42: Curve right warning sign
192 128 128 % Label 43: Curve left warning sign
192 128 128 % Label 44: Up right arrow warning sign
0 0 0       % Label 45: Not used
0 0 0       % Label 46: Not used
0 0 0       % Label 47: Not used
192 128 128 % Label 48: Railroad crossing sign
192 128 128 % Label 49: Street sign
192 128 128 % Label 50: Roundabout warning sign
192 128 128 % Label 51: Fire hydrant
192 128 128 % Label 52: Exit sign
192 128 128 % Label 53: Bike lane sign
0 0 0       % Label 54: Not used
0 0 0       % Label 55: Not used
0 0 0       % Label 56: Not used
128 128 128 % Label 57: Sky
60 40 222   % Label 58: Curb
60 40 222   % Label 59: Flyover ramp
60 40 222   % Label 60: Road guard rail
0 255 255   % Label 61: Bicyclist
0 0 0       % Label 62: Not used
0 0 0       % Label 63: Not used
0 0 0       % Label 64: Not used
0 0 0       % Label 65: Not used
0 0 0       % Label 66: Not used
240 150 25  % Label 67: Deer
0 0 0       % Label 68: Not used
0 0 0       % Label 69: Not used
0 0 0       % Label 70: Not used
150 50 15   % Label 71: Barricade
0 128 192   % Label 72: Motorcycle
];

% Normalize colormap to the range [0, 1].
cmap = cmap ./ 255;

end