classdef cDimVehicle < cGeometry
    properties(SetAccess=private, Hidden=true)
        % 车辆模型的前悬长度
        FrontOverhang(1,1) double {mustBeNonNan, mustBeFinite, mustBePositive} = 0.9;
        
        % 车辆模型的采样时间
        SampleTime(1,1) double {mustBeNonNan, mustBeFinite, mustBePositive} = 0.1;
        
        % 车辆模型的后悬长度
        RearOverhang(1,1) double {mustBeNonNan, mustBeFinite, mustBePositive} = 1;
        
        % 车辆模型的轴距
        Wheelbase(1,1) double {mustBeNonNan, mustBeFinite, mustBePositive} = 2.8;
        
        % 车辆模型的顶点信息（上、下、边界）
        Vertices = struct('Upper', [], 'Lower', [], 'Boundary', []);
    end
    
    methods(Access=public, Hidden=true)
        function obj = cDimVehicle(varargin)
            % cDimVehicle类的构造函数，继承自cGeometry类
            
            obj@cGeometry(varargin{:});
            obj = obj.updateParams(varargin{:});
        end
        
        function obj = updateParams(obj, varargin)
            % 更新车辆模型参数的方法
            
            parser = inputParser;
            addOptional(parser, 'FrontOverhang', -1);
            addOptional(parser, 'RearOverhang', -1);
            addOptional(parser, 'Wheelbase', -1);
            addOptional(parser, 'Length', -1);
            addOptional(parser, 'Width', -1);
            addOptional(parser, 'Height', -1);
            addOptional(parser, 'Mesh', -1);
            addOptional(parser, 'RCSPattern', -1);
            addOptional(parser, 'RCSAzimuthAngles', -1);
            addOptional(parser, 'RCSElevationAngles', -1);
            parse(parser, varargin{:});
            results = parser.Results;
            
            % 更新车辆模型的前悬长度、后悬长度和轴距
            if (results.FrontOverhang ~= -1)
                obj.FrontOverhang = results.FrontOverhang;
            end
            if (results.RearOverhang ~= -1)
                obj.RearOverhang = results.RearOverhang;
            end
            if (results.Wheelbase ~= -1)
                obj.Wheelbase = results.Wheelbase;
            end
            
            % 更新车辆模型的网格信息和RCS信息
            if (isstruct(results.Mesh))
                obj.Mesh = results.Mesh;
            end
            if (results.RCSPattern ~= -1)
                obj.RCSPattern = results.RCSPattern;
            end
            if (results.RCSAzimuthAngles ~= -1)
                obj.RCSAzimuthAngles = results.RCSAzimuthAngles;
            end
            if (results.RCSElevationAngles ~= -1)
                obj.RCSElevationAngles = results.RCSElevationAngles;
            end
            
            % 更新车辆模型的尺寸信息（长度、宽度和高度）
            len = results.Length;
            wid = results.Width;
            hei = results.Height;
            if (len ~= -1 && wid ~= -1 && hei ~= -1)
                % 当输入的尺寸参数都不为-1时，更新车辆模型的尺寸信息
                if (size(len, 1) ~= size(wid, 1) && size(len, 1) ~= size(hei, 1) && size(wid, 1) ~= size(hei, 1))
                    % 如果输入的尺寸参数维度不一致，则显示警告信息，并设置默认尺寸
                    msg = 'Expected input to be of same dimension.';
                    disp(msg);
                    len = 4.7;
                    wid = 1.8;
                    hei = 1.4;
                    obj.CuboidNums = 1;
                end
                obj.Length = len;
                obj.Width = wid;
                obj.Height = hei;
                obj.CuboidNums = max(size(len, 1), size(len, 2));
            end
        end
        
        function [length, width] = getActorDims(obj)
            % 获取车辆模型的尺寸信息（长度和宽度）
            length = obj.length(1);
            width = obj.width(1);
        end
        
        function obj = updateVertices(obj, pose)
            % 更新车辆模型顶点信息的方法
            
            x = pose.Position.X;
            y = pose.Position.Y;
            yaw = pose.Orientation.Yaw;
            % 计算车辆模型的上、下、边界顶点
            obj.Vertices.Upper = [x + obj.Length*cos(yaw), y + obj.Length*sin(yaw)];
            obj.Vertices.Lower = [x - obj.Length*cos(yaw), y - obj.Length*sin(yaw)];
            obj.Vertices.Boundary = [obj.Vertices.Upper; x, y; obj.Vertices.Lower];
        end
    end
end
