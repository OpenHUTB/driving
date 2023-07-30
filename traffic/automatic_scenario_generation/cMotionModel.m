classdef (Abstract) cMotionModel
    % cMotionModel 抽象类用于表示运动模型，是一个不能直接实例化的类。

    % 公共可访问的属性，隐藏实现细节
    properties (Access = public, Hidden = true)
        Pose(1,1) cPose;              % 当前姿态（位置和朝向）
        LastPose(1,1) cPose;          % 上一时刻姿态
        TimeStamp(1,1) double {mustBeNonNan, mustBeFinite, mustBeNonnegative} = 0; % 当前时间戳
        LastTimeStamp(1,1) double {mustBeNonNan, mustBeFinite, mustBeNonnegative} = 0; % 上一时刻时间戳
    end

    % 公共可设置的属性，隐藏实现细节
    properties (SetAccess = public, Hidden = true)
        Mass(1,1) double {mustBeNonNan, mustBeFinite, mustBePositive} = 1200;    % 质量
        Inertia(1,1) double {mustBeNonNan, mustBeFinite, mustBePositive} = 1900; % 惯性
    end

    % 私有属性，隐藏实现细节
    properties (Access = private, Hidden = true)
        InitialPose = 0;    % 初始姿态
    end

    % 公共方法，隐藏实现细节
    methods (Access = public, Hidden = true)

        % 构造函数，创建 cMotionModel 对象
        function obj = cMotionModel(varargin)
            if (nargin >= 1)
                actor = varargin{1};
                obj.Pose = cPose([actor.PositionX, actor.PositionY, actor.PositionZ], ...
                                 [actor.Yaw, actor.Pitch, actor.Roll]);
                obj.LastPose = obj.Pose;
                obj.InitialPose = obj.Pose;
            else
                obj.Pose = cPose();
                obj.LastPose = obj.Pose;
                obj.InitialPose = obj.Pose;
            end
        end

        % 重置运动模型为初始状态
        function obj = reset(obj)
            obj.Pose = obj.InitialPose;
            obj.LastPose = obj.InitialPose;
            obj.TimeStamp = 0;
            obj.LastTimeStamp = 0;
        end

        % 更新运动模型的参数
        function obj = updateParams(obj, varargin)
            parser = inputParser;
            addOptional(parser, 'Mass', -1);
            addOptional(parser, 'Inertia', -1);
            parse(parser, varargin{:});
            results = parser.Results;
            if (results.Mass ~= -1 && results.Mass > 0)
                obj.Mass = results.Mass;
            end
            if (results.Inertia ~= -1 && results.Inertia > 0)
                obj.Inertia = results.Inertia;
            end
        end
    end
end

