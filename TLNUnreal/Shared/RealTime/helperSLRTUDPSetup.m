function helperSLRTUDPSetup(targetMdl, targetIP, ...
                                         hostMdl, hostIP)
%helperSLRTUDPSetup configures the IP addresses of UDP send
% and receive blocks for the host and target models.
%
% targetMdl: Name of the target model
% targetIP : IP address of the target machine where the targetMdl will be deployed.
% hostMdl  : Name of the host model
% hostIP   : IP address of the host machine where the host model will run.
%
% Example usage:
%   helperSLRTUDPSetup('RTForwardVehicleSensorFusionTarget', '10.1.10.15', 'RTForwardVehicleSensorFusionHost', '10.1.10.16');
%
% This is a helper script for example purposes and may be removed or
% modified in the future.

% Copyright 2021 The MathWorks, Inc.

% Setup host model
setUDPIP(hostMdl, hostIP, targetIP);

% Setup target model
setUDPIP(targetMdl, targetIP, hostIP);

end

function setUDPIP(mdl, sendIPAddr, receiveIPAddr)
% Load the model
if ~bdIsLoaded(mdl)
    load_system(mdl);
end

% Find all blocks of S-Function type in the model (Note: UDP Send/Receive
% blocks are of S-Function type)
blockPaths = getfullname(Simulink.findBlocksOfType(mdl,'S-Function'));
% Go over all blocks
for i=1:size(blockPaths, 1)
    try
        % Check for UDP Send block and update IPs
        set_param(blockPaths{i}, 'ipAddress', sendIPAddr) % Local IP address
        set_param(blockPaths{i}, 'toAddress', receiveIPAddr) % To IP address
    catch
        % If mask parameters don't exist, do nothing.
    end
    try
        % Check for UDP Receive block and update IPs
        set_param(blockPaths{i}, 'ipAddress', sendIPAddr) % Local IP address
        set_param(blockPaths{i}, 'fmAddress', receiveIPAddr) % From IP address
    catch
        % If mask parameters don't exist, do nothing.
    end
end

% Save the model
save_system(mdl);
end