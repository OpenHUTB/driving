classdef hVehicle < matlab.System

    properties (Access = private)
        mActorSimulationHdl; 
        mScenarioSimulationHdl; 
        mActor; 
    end

    methods (Access=protected)
        function sz = getOutputSizeImpl(~)
            sz = [1 1];
        end

        % 定义采样时间
        function st = getSampleTimeImpl(obj)
            st = createSampleTime( ...
                obj, 'Type', 'Discrete', 'SampleTime', 0.02);
        end

        function t = getOutputDataTypeImpl(~)
            t = "double";
        end

        function resetImpl(~)
        end

        function setupImpl(obj)
    
            % 查找场景模拟对象，即其中包含动作者的场景。
            obj.mScenarioSimulationHdl = ...
                Simulink.ScenarioSimulation.find( ...
                    'ScenarioSimulation', 'SystemObject', obj);
            
            % 使用 Simulink.ScenarioSimulation.find 函数并查找参与者对象
            % 并反映该行为所附加的参与者。
            obj.mActorSimulationHdl = Simulink.ScenarioSimulation.find( ...
                'ActorSimulation', 'SystemObject', obj);

            obj.mActor.pose = ...
                obj.mActorSimulationHdl.getAttribute('Pose');

            obj.mActor.velocity = ...
                obj.mActorSimulationHdl.getAttribute('Velocity');
        end
        
        % stepImpl中的代码在场景模拟的每个时间步执行。
        function stepImpl(obj, ~)
        
            % 此代码获取场景中动作者的初始姿势和速度。
            velocity = obj.mActor.velocity;
            dTimeUnit = obj.getSampleTimeImpl.SampleTime;
            pose = obj.mActor.pose;

            % 更新姿势
            pose(1,4) = pose(1,4) + velocity(1) * dTimeUnit; % x
            pose(2,4) = pose(2,4) + velocity(2) * dTimeUnit; % y
            pose(3,4) = pose(3,4) + velocity(3) * dTimeUnit; % z

            obj.mActor.pose = pose;

            
            % 使用新的姿势值更新场景中的 RoadRunner actor。
            obj.mActorSimulationHdl.setAttribute('Pose', pose);
        end

        function releaseImpl(~)
        end
    end
end