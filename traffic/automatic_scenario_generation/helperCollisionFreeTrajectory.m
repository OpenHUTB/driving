classdef helperCollisionFreeTrajectory<matlab.System


    properties(Nontunable,Access=public)

        Scene;
    end


    properties(Access=private,Hidden=true)

        Vehicles;

        RNStruct;

        ActorCount=0;
    end

    methods

        function obj=helperCollisionFreeTrajectory(varargin)

            setProperties(obj,nargin,varargin{:})
        end

        function RNStruct=fetchData(obj)

            scenarioData=cScenario(obj.Scene);
            RNStruct=scenarioData.RNStruct;
        end

        function set.Scene(obj,sceneObj)

            obj.Scene=sceneObj;
        end
    end

    methods(Access=protected)

        function setupImpl(obj)

            if(obj.ActorCount==0)
                obj.RNStruct=obj.fetchData();
                obj.ActorCount=numel(obj.RNStruct.Actors);
            end
        end

        function Actors=stepImpl(obj,time)


            obj.RNStruct=obj.RNStruct.update(time);
            Actors=obj.RNStruct.getActorDetails();
        end

        function resetImpl(obj)

        end


        function s=saveObjectImpl(obj)



            s=saveObjectImpl@matlab.System(obj);



        end

        function loadObjectImpl(obj,s,wasLocked)






            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end


        function validateInputsImpl(obj,u)

        end

        function validatePropertiesImpl(obj)

        end

        function ds=getDiscreteStateImpl(obj)

            ds=struct([]);
        end

        function processTunedPropertiesImpl(obj)


        end

        function flag=isInputSizeMutableImpl(obj,index)


            flag=false;
        end

        function sts=getSampleTimeImpl(obj)
            sts=createSampleTime(obj,'Type','Discrete',...
            'SampleTime',0.025,'OffsetTime',0.0);
        end

        function flag=isInactivePropertyImpl(obj,prop)


            flag=false;
        end
    end

    methods(Static,Access=protected)
        function simMode=getSimulateUsingImpl

            simMode="Interpreted execution";
        end
        function groups=getPropertyGroupsImpl

            scenarioPropList{1}=matlab.system.display.internal.Property(...
            'Scene','Description','ScenarioName');
            groupScenario=matlab.system.display.Section(...
            'Title','Scene','PropertyList',scenarioPropList);
            groups=groupScenario;
        end
    end
end
