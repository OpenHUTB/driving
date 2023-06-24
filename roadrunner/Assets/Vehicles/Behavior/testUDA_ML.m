%% 使用用户定义操作的参与者行为
% 在此示例中，创建一个参与者行为来处理从场景接收的用户定义操作。
% 自定义行为testUDA_ML.m被编写为 MATLAB System 对象文件。
% 在此行为中，代码读取用户定义动作的自定义参数，然后相应地更改相关动作者的姿势。
% 参考：https://ww2.mathworks.cn/help/releases/R2022b/driving/ug/co-simulate-roadrunner-with-agents-modeled-in-matlab.html
classdef testUDA_ML < matlab.System

    properties
    end

    properties (Access = private)
        mActorHdl;
        mThrottleLevel = 35;
        mSteeringAngle = 0;
    end

    methods (Access=protected)
        function interface = getInterfaceImpl(~)
            import matlab.system.interface.*;
            interface = ActorInterface();
        end

        % 定义了采样时间
        function st = getSampleTimeImpl(obj)
            st = createSampleTime( ...
                obj, 'Type', 'Discrete', 'SampleTime', 0.02);
        end

        % setupImpl中的代码仅在模拟开始时调用一次。
        function setupImpl(obj)
            % 查找场景模拟对象，即包含动作者组的场景
            sim = Simulink.ScenarioSimulation.find('ScenarioSimulation');
            % 返回此行为所附加的参与者对象
            actor = sim.get('ActorSimulation','SystemObject',obj);
            obj.mActorHdl = actor;
        end

        function resetImpl(~)
        end

        function releaseImpl(~)
        end

        % 提取场景中用户定义操作的自定义参数。
        % 它还发出一个Action Complete事件，
        % 由RoadRunner Scenario在使用用户定义操作的操作阶段结束时进行处理。
        % stepImpl中的代码在场景模拟的每个时间步执行。
        function stepImpl(obj)
            uda = obj.mActorHdl.getAction("UserDefinedAction", "CustomDrive");
            for i = 1:length(uda)
                obj.mThrottleLevel = eval(uda(i).Parameters.ThrottleLevel);
                obj.mSteeringAngle = eval(uda(i).Parameters.SteeringAngle);
                obj.mActorHdl.sendEvent('ActionComplete', uda(i).ActorAction.ActionID);
            end

            % 根据自定义参数的值更新车辆的当前姿态和速度。
            dTimeUnit = obj.getSampleTimeImpl.SampleTime;
            pose = obj.mActorHdl.getAttribute('Pose');

            maxSpeed = 50;
            distance = dTimeUnit*obj.mThrottleLevel*maxSpeed/100;
            angle = deg2rad(obj.mSteeringAngle);

            pose(1,4) = pose(1,4) + distance*cos(angle);
            pose(2,4) = pose(2,4) + distance*sin(angle);

            obj.mActorHdl.setAttribute('Pose', pose);
        end
    end
end