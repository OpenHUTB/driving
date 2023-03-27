function helperRTTestManagerSetup(targetMdl)
%helperRTTestManagerSetup function deploys and runs the targetMdl on the
% target machine. This function is used in test file and test case
% callbacks of a test manager file.
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2021 The MathWorks, Inc.

% Read or create slrealtime object
try
    tg = evalin('base', 'tg');
catch
    tg = slrealtime;
end

% If the controller is not running on target, run deployment commands
if ~tg.isRunning  
    % Build the target model
    slbuild(targetMdl);

    % Load real-time application to the target
    tg.load(targetMdl);

    % Start execution of real-time application on target
    tg.start;
end
% Assign slrealtime object to base workspace
assignin('base', 'tg', tg);

end