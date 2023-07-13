classdef cScenario




    properties

        RNStruct=[];
    end
    properties(Access=private,Hidden=true)

        InputType(1,:)char;

        DebugEnabled=struct('FOV',false,'Coll',false,'SFG',false);
    end
    methods
        function obj=cScenario(varargin)

            if(nargin>=1)
                scenario=varargin{1};
                if(isa(scenario,'drivingScenario'))
                    obj.InputType='drivingScenario';
                    obj.RNStruct=obj.loadRoadNetwork(scenario);
                    obj.RNStruct.DebugEnabled=obj.DebugEnabled;
                    obj=obj.updateActorDetails(scenario);
                    if(obj.DebugEnabled.FOV)
                        obj.RNStruct=obj.RNStruct.plot();
                    end
                else
                    filePath=scenario;
                    extensionPoint=strfind(filePath,'.');
                    extension=filePath(extensionPoint(end):end);
                    if(strcmpi(extension,'.xodr')==1)
                        obj.InputType='xodr';
                    end
                    obj.RNStruct=obj.loadRoadNetwork(scenario);
                    obj=obj.updateActorDetails(scenario);
                    obj.RNStruct.DebugEnabled=DebugEnabled;
                    if(obj.DebugEnabled.FOV)
                        obj.RNStruct=obj.RNStruct.plot();
                    end
                end
            else

            end
        end
        function data=getStruct(obj)

            data=obj.RNStruct.getStruct();
        end
    end
    methods(Access=private,Hidden=true)
        function RNStruct=loadRoadNetwork(obj,scenario)

            if(strcmp(obj.InputType,'drivingScenario'))

                model=mf.zero.Model;

                rn=driving.internal.scenarioAdapter.getRoadNetwork(...
                scenario,model);

                RNStruct=cRoadNetwork(rn);

                RNStruct.RoadGraph=rn.getDigraph();
                RNStruct.Scenario=obj.copyMap(scenario);
            elseif(strcmp(obj.InputType,'xodr'))

                adapterobj=matlabshared.drivingutils.OpenDriveAdapter(...
                obj.filePath);



                rn=adapterobj.getRoadNetworkData();

                scenario=...
                driving.internal.scenarioAdapter.getDrivingScenario(...
                rn);

                model=mf.zero.Model;

                rn=driving.internal.scenarioAdapter.getRoadNetwork(...
                scenario,model);

                RNStruct=cRoadNetwork(rn);

                RNStruct.RoadGraph=rn.getDigraph();
                RNStruct.Scenario=obj.copyMap(scenario);
            end
        end
        function ds=copyMap(obj,scenario)

            sceneDescriptor=getScenarioDescriptor(scenario,'Simulator','DrivingScenario');
            ds=getScenario(sceneDescriptor,'Simulator','DrivingScenario');
        end

        function obj=updateActorDetails(obj,scenario)


            actors=scenario.Actors;
            sampleTime=scenario.SampleTime;
            actorsMap=obj.RNStruct.ActorsMap;
            if(~isempty(actors))
                for idx=1:length(actors)
                    actor=actors(idx);
                    if(actor.ClassID<=4&&actor.ClassID>=1)
                        if(actorsMap.isKey(actor.ActorID)==1)
                            index=actorsMap(actor.ActorID);
                            actorRN=obj.RNStruct.Actors(index);
                            actorRN.DebugEnabled=obj.DebugEnabled;

                            RCSPattern=actor.RCSPattern;
                            RCSAzimuthAngles=actor.RCSAzimuthAngles;
                            mesh.vertices=actor.Mesh.Vertices;
                            mesh.faces=actor.Mesh.Faces;
                            frontOverhang=actor.FrontOverhang;
                            rearOverhang=actor.RearOverhang;
                            wheelbase=actor.Wheelbase;

                            entryTime=actor.EntryTime;
                            exitTime=actor.ExitTime;

                            actorRN=actorRN.updateGeometry('Mesh',mesh,...
                            'FrontOverhang',frontOverhang,...
                            'RearOverhang',rearOverhang,...
                            'Wheelbase',wheelbase,...
                            'RCSPattern',RCSPattern,...
                            'RCSAzimuthAngles',RCSAzimuthAngles,...
                            'RCSElevationAngles',RCSAzimuthAngles);


                            if(isa(actor.MotionStrategy,...
                                'driving.scenario.Path'))
                                wayPts=actor.MotionStrategy.Waypoints;
                                sampledWayPts=...
                                actor.MotionStrategy.SamplePoints;
                                speed=actor.MotionStrategy.Speed;
                                waitTime=actor.MotionStrategy.WaitTime;
                                initialYaw=actor.Yaw*pi/180;
                                actorRN.Path=cPath(wayPts,...
                                sampledWayPts,speed,...
                                'InitialYaw',initialYaw,...
                                'WaitTime',waitTime,...
                                'EntryTime',entryTime,...
                                'ExitTime',exitTime,...
                                'SampleTime',sampleTime);

                                actorRN=actorRN.updateMotionModelInput();
                                actorRN.MotionModel.OverrideSpeed=1;
                            else
                                actorRN.Path=cPath('EntryTime',...
                                entryTime,...
                                'ExitTime',exitTime,...
                                'SampleTime',sampleTime);

                            end
                            obj.RNStruct.Actors(index)=actorRN;
                        end
                    end
                end
            end
        end
    end
end