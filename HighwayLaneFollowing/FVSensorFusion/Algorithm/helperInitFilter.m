function filter = helperInitFilter(detection)
%Helper function to update the process noise and state covariance of the
%initialized filter from initcvekf.

% Copyright 2021 The MathWorks, Inc.

% initialize filter with initcvekf
filter = initcvekf(detection);

% update processnoise
filter.ProcessNoise = blkdiag(25,5,1e-2);

% update statecovariance
filter.StateCovariance = blkdiag(filter.StateCovariance(1:4,1:4),1e-2*eye(2));
end