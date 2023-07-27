% 定义一个helperCollisionFreeTrajectory类,继承自matlab.System
classdef helperCollisionFreeTrajectory<matlab.System

    % 定义公有不可调用属性Scene,用于存放运动规划相关的场景信息
    properties(Nontunable,Access=public)

        Scene;
    end

    % 定义私有隐藏属性
    properties(Access=private,Hidden=true)

        % Vehicles属性,用于存储车辆信息
        Vehicles;

        % RNStruct属性,用于存储道路网络结构信息
        RNStruct;

        % ActorCount属性,用于存储演员(Actors)的数目,默认初始化为0
        ActorCount=0;
    end

    methods
    
        %类的构造函数,使用setProperties来设置属性
        function obj=helperCollisionFreeTrajectory(varargin)

            setProperties(obj,nargin,varargin{:})
        end

        % fetchData方法,用于获取RNStruct数据
        function RNStruct=fetchData(obj)

            scenarioData=cScenario(obj.Scene);
            RNStruct=scenarioData.RNStruct;
        end

        % 设置Scene属性的set方法
        function set.Scene(obj,sceneObj)

            obj.Scene=sceneObj;
        end
    end

    
    methods(Access=protected)
        %定义setupImpl保护方法，初始化场景
        function setupImpl(obj)
            %ActorCount为0，表明场景还未初始化
            if(obj.ActorCount==0)
                %调用fetchData()获取RNStruct数据
                obj.RNStruct=obj.fetchData();
                %设置ActorCount为RNStruct中的演员数目
                obj.ActorCount=numel(obj.RNStruct.Actors);
            end
        end
        
        % 定义stepImpl保护方法，更新并返回场景中的演员状态
        function Actors=stepImpl(obj,time)
            %调用RNStruct的update方法更新内部状态
            obj.RNStruct=obj.RNStruct.update(time);
            %调用getActorDetails()获取当前时刻的演员详情
            Actors=obj.RNStruct.getActorDetails();
        end

        %将场景进行重置为起始状态
        function resetImpl(obj)

        end


        %保存对象状态，便于稍后恢复
        function s=saveObjectImpl(obj)
            
            s=saveObjectImpl@matlab.System(obj);

        end

        %加载对象状态
        function loadObjectImpl(obj,s,wasLocked)

            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %验证输入的有效性
        function validateInputsImpl(obj,u)

        end

        %验证对象的属性是否正确
        function validatePropertiesImpl(obj)

        end

        %获取系统的离散状态
        function ds=getDiscreteStateImpl(obj)

            ds=struct([]);
        end
        

        % 处理调谐属性的方法
        function processTunedPropertiesImpl(obj)


        end

        % 检查输入端口大小是否可变的方法
        function flag=isInputSizeMutableImpl(obj,index)


            flag=false;
        end

        % 获取采样时间的方法
        function sts=getSampleTimeImpl(obj)
            sts=createSampleTime(obj,'Type','Discrete',...
            'SampleTime',0.025,'OffsetTime',0.0);
        end

        % 检查属性是否非活动的方法
        function flag=isInactivePropertyImpl(obj,prop)
            flag=false;
        end
    end

    methods(Static,Access=protected)

        % 获取仿真模式的方法
        function simMode=getSimulateUsingImpl
            simMode="Interpreted execution";
        end

        % 获取属性组的方法
        function groups=getPropertyGroupsImpl

            scenarioPropList{1}=matlab.system.display.internal.Property(...
            'Scene','Description','ScenarioName');
            groupScenario=matlab.system.display.Section(...
            'Title','Scene','PropertyList',scenarioPropList);
            groups=groupScenario;
        end
    end
end
