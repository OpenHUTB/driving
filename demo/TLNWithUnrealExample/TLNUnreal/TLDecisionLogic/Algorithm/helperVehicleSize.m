classdef helperVehicleSize < matlabshared.tracking.internal.SimulinkBusUtilities
% This class is for internal use and may be removed or modified in the future
%
% Limits the reported covariance from the measurements to be no greater
% than the expected dimensions from a vehicle. This is needed when extended
% tracking is not used and control decisions are being made using the state
% of a point track.
%
% internal class, no error checking is performed

% Copyright 2020 The MathWorks, Inc.

%#codegen
    properties(Nontunable)
        %VehicleSize  Maximum dimension of a vehicle (m)
        VehicleSize = 5
    end
    
    properties(Constant, Access=protected)
        %pBusPrefix Prefix used to create bus names
        %   Buses will be created with the name <pBusPrefix>#, where
        %   <pBusPrefix> is the char array set to pBusPrefix and # is an
        %   integer. Subbuses will be created by appending the name of the
        %   structure field associated with the subbus to the base bus
        %   name. For example: <pBusPrefix>#<fieldName>
        pBusPrefix = 'BusVehicleSizeDetections'
    end
    
    methods(Access = protected)
        function Out = stepImpl(obj,In)
            Out = In;
            poscov = obj.VehicleSize^2*eye(2);
            for m = 1:Out.NumDetections
                Out.Detections(m).MeasurementNoise(1:2,1:2) = poscov;
            end
        end

        function [out, argsToBus] = defaultOutput(obj)
            
            out = struct.empty();
            argsToBus = {};
            
            % Create template for output struct as combination of all input
            % structs
            busIn = propagatedInputBus(obj,1);
            if isempty(busIn)
                return
            end
            
            out = matlabshared.tracking.internal.SimulinkBusUtilities.bus2struct(busIn);
        end
        
        % Currently only support simulink environment, so nothing to do
        % here
        function y = sendToBus(~,x,varargin)
            y = x;
        end
        
        function dt = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            dt = getOutputDataTypeImpl@matlabshared.tracking.internal.SimulinkBusUtilities(obj);
        end
    end

    methods(Access = protected, Static)
        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename("class"));
        end
    end
end
