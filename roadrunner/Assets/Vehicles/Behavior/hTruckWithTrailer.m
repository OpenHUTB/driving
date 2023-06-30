%% 路径跟随参与者组行为
% 在此示例中，为由卡车和拖车组成的参与者组创建自定义行为。
% 自定义行为 hTruckWithTrailer.m 被编写为 MATLAB System 对象文件。
% 在此行为中，代码读取卡车（父级）的姿态和速度并更新拖车（子级），
% 以便子级在整个模拟过程中保持在父级后面的恒定距离。
% 参考：https://ww2.mathworks.cn/help/releases/R2022b/driving/ug/co-simulate-roadrunner-with-agents-modeled-in-matlab.html
classdef hTruckWithTrailer < matlab.System

    properties (Access = private)
        mActorSimulationHdl;
        mScenarioSimObj;
        mActor;
        mDt;
        mFirstStep = true;
        mRDelta = 0;
        mLDelta = 0;
        mTurn = 0;
        mYielded = false;
    end

    properties (Access = public)
        TargetSpeed = 17.9;
        TargetAccel = 10.0;
    end

    methods (Access=protected)
        function sz = getOutputSizeImpl(~)
            sz = [1 1];
        end

        function st = getSampleTimeImpl(obj)
            st = createSampleTime( ...
                obj, 'Type', 'Discrete', 'SampleTime', 0.02);
        end

        function t = getOutputDataTypeImpl(~)
            t = "double";
        end

        function resetImpl(obj)
            obj.mActorSimulationHdl = Simulink.ScenarioSimulation.find( ...
                'ActorSimulation', 'SystemObject', obj);
            obj.mScenarioSimObj = Simulink.ScenarioSimulation.find( ...
                'ScenarioSimulation', 'SystemObject', obj);
            obj.mDt = obj.mScenarioSimObj.get('StepSize');

            obj.mActor.pose = ...
                obj.mActorSimulationHdl.getAttribute('Pose');
            obj.mActor.actorModel = obj.mActorSimulationHdl.get('ActorModel');
            obj.mActor.speed = 0.0;
            obj.mActor.currPos = 0.0;
            obj.mFirstStep = true;
        end


        % stepImpl中的代码在场景仿真的每个时间步执行。
        function stepImpl(obj, ~)
            % 通过读取目标路径结构为卡车（父级）设置路线。
            path_action = obj.mActorSimulationHdl.getAction('PathAction');
            if(~isempty(path_action))
                obj.mActor.path = path_action.PathTarget.Path;
                obj.mActor.numPts = path_action.PathTarget.NumPoints;
                obj.mActor.currPt = 1;
            end


            % 读取目标速度值
            speedChg_action = obj.mActorSimulationHdl.getAction('SpeedAction');
            if(~isempty(speedChg_action))
                tgtSpeed = speedChg_action.SpeedTarget.SpeedValue;
                if(obj.mFirstStep)
                    assert(isequal(obj.mActor.speed, 0));
                else
                    assert(isequal(tgtSpeed, obj.TargetSpeed));
                end
            end

            obj.mFirstStep = false;

            % 更新卡车的速度，直到达到目标速度，然后保持相同的值。
            if(obj.mActor.speed < obj.TargetSpeed)
                obj.mActor.speed = obj.mActor.speed + obj.TargetAccel * obj.mDt;
                if ( obj.mActor.speed > obj.TargetSpeed )
                    obj.mActor.speed = obj.TargetSpeed;
                end
            end

            % 计算卡车在一个时间步内必须达到的绝对位移值
            ds = obj.mActor.speed * obj.mDt;

            % 计算路径上从当前点到下一个点的距离
            totalDist = -obj.mActor.currPos;
            for i = obj.mActor.currPt : obj.mActor.numPts-1
                pt1 = obj.mActor.path(i, :);
                pt2 = obj.mActor.path(i+1, :);
                prevDist = totalDist;
                totalDist = totalDist + norm(pt1 - pt2);

                % 段检查卡车在当前时间步内是否已到达路径上的目标点，
                % 并相应地计算下一个点。
                % 卡车的姿态被更新，然后相对于全局参考系进行变换。
                % 如果RoadRunner Scenario中未定义路径，则此代码片段会更新卡车的姿态。
                if(totalDist > ds)
                    v = obj.mActor.path(i+1, :) - obj.mActor.path(i, :);
                    obj.mActor.unit_v = (v/norm(v));
                    pos = obj.mActor.path(i, :) + (ds - prevDist) * obj.mActor.unit_v;
                    obj.mActor.currPt = i;
                    obj.mActor.currPos = (ds - prevDist);

                    obj.mActor.pose(1,4) = pos(1);
                    obj.mActor.pose(2,4) = pos(2);
                    obj.mActor.pose(3,4) = pos(3);

                    obj.mActor.pose(1, 1:3) = [obj.mActor.unit_v(2) obj.mActor.unit_v(1) 0];
                    obj.mActor.pose(2, 1:3) = [-obj.mActor.unit_v(1) obj.mActor.unit_v(2) 0];
                    obj.mActor.pose(3, 1:3) = [0 0 1];
                    obj.mActor.pose(4, 4) = 1;
                    break;
                end
            end

            if(obj.mActor.numPts == 0)
                pose = obj.mActor.pose;
                velocity = [10 4 0];
                obj.mActor.pose(1,4) = pose(1,4) + velocity(1) * obj.mDt; % x
                obj.mActor.pose(2,4) = pose(2,4) + velocity(2) * obj.mDt; % y
                obj.mActor.pose(3,4) = pose(3,4) + velocity(3) * obj.mDt; % z
            end

            % 计算拖车（子车）相对于卡车的位置的逻辑。
            % 该逻辑规定，在整个模拟过程中，孩子在父母身后保持固定距离。
            % 将卡车的更新姿态写入场景
            obj.mActorSimulationHdl.setAttribute('Pose', obj.mActor.pose);

            boundingBox = obj.mActor.actorModel.getAttribute('BoundingBox');
            u = boundingBox.min;
            y =[0 2*u(2) 0 1]';

            mat = obj.mActor.pose*y;
            trailerPose = obj.mActor.pose;
            trailerPose(13) = mat(1);
            trailerPose(14) = mat(2);
            trailerPose(15) = mat(3);
            child = obj.mActorSimulationHdl.getAttribute('Children');

            child.setAttribute('Pose',trailerPose);
        end

        function releaseImpl(~)
        end
    end
end