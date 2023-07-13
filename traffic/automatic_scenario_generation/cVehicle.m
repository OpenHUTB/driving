classdef cVehicle<cActor





    properties(Access=public)

        SampleTime=0.1;

        CurrentTime=0;

        MotionModel;

        Path;

        CollisionBlock;

        FOVSensor;

        SafetyPolicy;
    end
    properties(Access=public,Hidden=true)

        DebugEnabled=struct('FOV',false,'Coll',false,'SFG',false);
    end
    properties(Access=private)

        SlowCounter=0;
    end
    methods(Access=public)
        function obj=cVehicle(vehicle,indx)

            obj@cActor(vehicle,indx);
            obj.Geometry=cDimVehicle('Length',vehicle.Length,'Width',...
            vehicle.Width,'Height',vehicle.Height);
            if(isa(vehicle,'driving.scenario.Actor'))
            end
            if(strcmpi(vehicle.Type,'Car'))
                obj.Type=cVehicleType('Car');
            elseif(strcmpi(vehicle.Type,'Truck'))
                obj.Type=cVehicleType('Truck');
            elseif(strcmpi(vehicle.Type,'Motorcycle'))
                obj.Type=cVehicleType('Motorcycle');
            elseif(strcmpi(vehicle.Type,'Bicycle'))
                obj.Type=cVehicleType('Bicycle');
            elseif(strcmpi(vehicle.Type,'Emergency'))
                obj.Type=cVehicleType('Emergency');
            elseif(strcmpi(vehicle.Type,'Police'))
                obj.Type=cVehicleType('Police');
            elseif(strcmpi(vehicle.Type,'Pedestrian'))
                obj.Type=cVehicleType('Pedestrian');
            else
                obj.Type=cVehicleType('Unknown');
            end
            obj.MotionModel=simpleMotionModel(vehicle);
            obj.Pose=obj.MotionModel.Pose;
            obj.Path=cPath();
            obj.FOVSensor=cFOVSensor(obj.ID,obj.Pose);
            obj.CollisionBlock=cCollisionDetection();
            obj.SafetyPolicy=cSafePolicyGenerator();
        end
        function obj=update(obj,time)


            actorsInView=obj.FOVSensor.getVehiclesInNeighbourhood();
            if(obj.DebugEnabled.Coll)
                disp('_______');
                disp('ID');
                disp(obj.ID);
                disp('actorsInView');
                disp(actorsInView);
            end

            obj.CollisionBlock=obj.CollisionBlock.checkInCollision(...
            obj,actorsInView);
            if(obj.DebugEnabled.Coll)
                disp("Collision Agents");
                disp("______");
                for indx=1:length(obj.CollisionBlock.AgentsInCollision.ID)
                    disp(obj.CollisionBlock.AgentsInCollision.ID(indx));
                    disp(obj.CollisionBlock.AgentsInCollision.Position(indx,:));
                    disp(obj.CollisionBlock.AgentsInCollision.Speed(indx));
                    disp(obj.CollisionBlock.AgentsInCollision.Yaw(indx));
                    disp(obj.CollisionBlock.AgentsInCollision.Length(indx));
                    disp(obj.CollisionBlock.AgentsInCollision.Width(indx));
                    disp(" ");
                end
                disp("______");
                disp("Scale1:");
            end

            obj.SafetyPolicy=obj.SafetyPolicy.computeScale(obj);
            if(obj.DebugEnabled.Coll)
                disp('#*#');
                disp(obj.SafetyPolicy.Scale);
                disp('#*#');
                disp("Speed1:");
                disp(obj.MotionModel.Speed);
                disp(obj.MotionModel.ScaledSpeed);
            end

            if(isempty(obj.CollisionBlock.AgentsInCollision.ID))
                [obj.SafetyPolicy.Scale,~]=...
                obj.SafetyPolicy.recoverFromZeroSpeed(obj);
                obj.MotionModel.ScaledSpeed=obj.SafetyPolicy.Scale*...
                obj.MotionModel.Speed;
            end
            if(obj.DebugEnabled.Coll)
                disp('#*#1');
                disp(obj.SafetyPolicy.Scale);
                disp(obj.MotionModel);
                disp('#*#1');
            end
            obj.MotionModel.Scale=obj.SafetyPolicy.Scale;


            obj.MotionModel=obj.MotionModel.update(time);
            pose=obj.Pose;
            newPose=obj.MotionModel.Pose;
            if(pose.Position~=newPose.Position)
                obj.Pose=newPose;
                obj.Geometry=obj.Geometry.updateVertices(obj.Pose);
                obj.FOVSensor=obj.FOVSensor.updateFOVPolygon(obj.Pose,obj.MotionModel.FutureYaw);
            end
            if(obj.DebugEnabled.Coll)
                disp("Speed Raw:");
                disp(obj.MotionModel.Speed);
                disp("Speed Edited:");
                disp(obj.MotionModel.ScaledSpeed);
                disp('_______');
            end
        end
        function plot(obj,figHandle,axesH)

            pose=obj.MotionModel.Pose;
            length=obj.Geometry.Length/2;
            width=obj.Geometry.Width/2;
            position=[pose.Position.X,pose.Position.Y];
            yaw=pose.Orientation.Yaw;
            diagonal=sqrt(length*length+width*width);
            edge1=[position(1)+diagonal*cos(pi/4+yaw),...
            position(2)+diagonal*sin(pi/4+yaw)];
            edge2=[position(1)+diagonal*cos(pi/4+pi/2+yaw),...
            position(2)+diagonal*sin(pi/4+pi/2+yaw)];
            edge3=[position(1)+diagonal*cos(pi/4+pi+yaw),...
            position(2)+diagonal*sin(pi/4+pi+yaw)];
            edge4=[position(1)+diagonal*cos(pi/4+3*pi/2+yaw),...
            position(2)+diagonal*sin(pi/4+3*pi/2+yaw)];
            fov=obj.FOVSensor.FOVNeigh;
            hold(axesH,'on');
            plot([edge1(1),edge2(1),edge3(1),edge4(1)],...
            [edge1(2),edge2(2),edge3(2),edge4(2)],'Parent',axesH);
            leftSidePath=obj.MotionModel.LookAheadPath.Left;
            rightSidePath=obj.MotionModel.LookAheadPath.Right;
            polygon=[leftSidePath;rightSidePath(end:-1:1,:)];
            plot(fov(:,1),fov(:,2),'Parent',axesH);
            if(~isempty(polygon))
                plot(polygon(:,1),polygon(:,2),'Parent',axesH);
            end
            text(position(1),position(2),num2str(obj.ID));
            hold(axesH,'off');
        end























        function[length,width]=getActorDims(obj)

            length=obj.Geometry.Length;
            width=obj.Geometry.Width;
        end
        function yaw=getYaw(obj)

            yaw=obj.Pose.Orientation.Yaw;
        end
        function obj=updateLookAheadPolygon(obj,width)

            obj.MotionModel=obj.MotionModel.updateLookAheadPolygon(width);
        end

        function[obj,roads,nodes]=updateRoad(obj,roads,nodes)



            if(obj.Pose.Position==obj.MotionModel.LastPose.Position)
                return;
            else
                point=[obj.Pose.Position.X...
                ,obj.Pose.Position.Y...
                ,obj.Pose.Position.Z];

                if((obj.RoadID==-1)||(obj.RoadIndex==1))
                    [rdID,rdIndx,rdType,laneType]=...
                    roadUtils.pointToRoadLookup(point,roads,nodes);
                    obj.RoadID=rdID;
                    obj.RoadIndex=rdIndx;
                    obj.RoadType=rdType;
                    obj.LaneType=laneType;
                    if(rdID~=-1)
                        road=roads(1);
                        road=road.removeActor(obj);
                        roads(1)=road;
                        if(rdType==1)
                            road=roads(obj.RoadIndex);
                            road=road.appendActor(obj);
                            roads(obj.RoadIndex)=road;
                        elseif(rdType==2)
                            node=nodes(obj.RoadIndex);
                            node=node.appendActor(obj);
                            nodes(obj.RoadIndex)=node;
                        end
                    end
                else
                    road=[];
                    node=[];
                    if(obj.RoadType==1)
                        road=roads(obj.RoadIndex);
                        [~,connRoads]=road.getNeighbouringRoads();
                        nodesSub=[nodes(road.StartNodeIndex);...
                        nodes(road.EndNodeIndex)];
                    elseif(obj.RoadType==2)
                        node=nodes(obj.RoadIndex);
                        [~,connRoads]=node.getNeighbouringRoads();
                        nodesSub=nodes(obj.RoadIndex);
                    end

                    roadsSub=roads(1:length(connRoads));
                    indexes=connRoads.values();
                    for indx=1:length(connRoads)
                        roadsSub(indx)=roads(indexes{indx});
                    end
                    [rdID,rdIndx,rdType,laneType]=...
                    roadUtils.pointToRoadLookup(point,...
                    roadsSub,nodesSub);
                    if(rdID~=-1)
                        if(obj.RoadType==1)
                            road=roads(obj.RoadIndex);
                            road.removeActor(obj);
                            roads(obj.RoadIndex)=road;
                        elseif(obj.RoadType==2)
                            node=nodes(obj.RoadIndex);
                            node.removeActor(obj);
                            nodes(obj.RoadIndex)=node;
                        end
                        obj.RoadID=rdID;
                        obj.RoadIndex=rdIndx;
                        obj.RoadType=rdType;
                        obj.LaneType=laneType;
                        if(obj.RoadType==1)
                            road=roads(obj.RoadIndex);
                            road.appendActor(obj);
                            roads(obj.RoadIndex)=road;
                        elseif(obj.RoadType==2)
                            node=nodes(obj.RoadIndex);
                            node.appendActor(obj);
                            nodes(obj.RoadIndex)=node;
                        end
                        return;
                    else
                        [rdID,rdIndx,rdType,laneType]=...
                        roadUtils.pointToRoadLookup(point,...
                        roads,nodes);
                        if(obj.RoadType==1)
                            road=roads(obj.RoadIndex);
                            road.removeActor(obj);
                            roads(obj.RoadIndex)=road;
                        elseif(obj.RoadType==2)
                            node=nodes(obj.RoadIndex);
                            node.removeActor(obj);
                            nodes(obj.RoadIndex)=node;
                        end
                        obj.RoadID=rdID;
                        obj.RoadIndex=rdIndx;
                        obj.RoadType=rdType;
                        obj.LaneType=laneType;
                        if(rdID~=-1&&rdIndx~=1)
                            if(obj.RoadType==1)
                                road=roads(obj.RoadIndex);
                                road.appendActor(obj);
                                roads(obj.RoadIndex)=road;
                            elseif(obj.RoadType==2)
                                node=nodes(obj.RoadIndex);
                                node.appendActor(obj);
                                nodes(obj.RoadIndex)=node;
                            end
                        else
                            road=roads(1);
                            road.appendActor(obj);
                            roads(1)=road;
                        end
                        return;
                    end
                end
            end

        end
        function obj=updateMotionModelInput(obj)

            obj.Pose.Position.X=obj.Path.SampledWaypoints(1,1);
            obj.Pose.Position.Y=obj.Path.SampledWaypoints(1,2);
            diff=obj.Path.SampledWaypoints(2,:)-obj.Path.SampledWaypoints(2,:);
            obj.Pose.Orientation.Yaw=atan2(diff(2),diff(1));
            obj.MotionModel.Pose=obj.Pose;
            obj.MotionModel.LastPose=obj.Pose;
            obj.MotionModel.Path=obj.Path;
            obj.MotionModel.Speed=obj.Path.Speed(1);
            obj.MotionModel.InitialSpeed=obj.Path.Speed(1);
            obj.MotionModel.ScaledSpeed=obj.Path.Speed(1);
            obj.Geometry=obj.Geometry.updateVertices(obj.Pose);
        end
        function obj=recoverFromZeroSpeed(obj)











            if(isempty(obj.CollisionBlock.AgentsInCollision.position))

                obj.Speed=obj.InitialSpeed;
            end
        end
        function obj=updateGeometry(obj,varargin)

            obj.Geometry=obj.Geometry.updateParams(varargin{:});
        end
        function data=getStruct(obj)

        end

    end
end

