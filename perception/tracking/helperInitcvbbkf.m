function filter = helperInitcvbbkf(detection)
% Initialize a linear Constant-Velocity Kalman filter for Bounding Box tracking.

% detection must have a Measurement following the [u, v, s, r] format
measurement = detection.Measurement;

% Initialize state with null velocity
X0 = [measurement(1:4)' ; zeros(4,1)];

% Initialize state covariance with high variance on velocity states
P0 = diag([1 1 10 10 1e4 1e4 1e4 1e2]);

% Add some process noise to capture unknown acceleration
Q = diag([1 1 1 1 10 10 10 1]);

dt = 1;
A = [eye(4), dt*eye(4); zeros(4), eye(4)];
H = [eye(4), zeros(4)];

% Put it all together
filter = trackingKF(State = X0,...
    StateCovariance = P0,...
    ProcessNoise = Q, ...
    MotionModel = 'custom',...
    StateTransitionModel = A,...
    MeasurementModel = H);

end
