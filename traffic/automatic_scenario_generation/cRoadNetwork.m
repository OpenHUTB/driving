classdef cRoadNetwork




    properties(Access=public)

        Actors(1,:)cVehicle;

        StaticObjects(1,:)cActor;

        MovableObjects(1,:)cActor;

        DynamicObjects(1,:)cActor;

        Nodes(1,:)cNode;

        Roads(1,:)cRoad;

        AxesOrientation(1,:)char;
    end
    properties(Hidden=true)

        ActorsMap containers.Map;

        DrivingDir(1,1)int32{mustBeMember(DrivingDir,[-1,1])}=1;

        DynamicObjectsMap containers.Map;

        MovableObjectsMap containers.Map;

        NodesMap containers.Map;

        RoadsMap containers.Map;

        StaticObjectsMap containers.Map;

        RoadGraph;

        EgoActors;

        ActorDetails;

        FigHandle;

        Scenario;

        DebugEnabled=struct('FOV',false,'Coll',false,'SFG',false);
    end
    methods
        function obj=cRoadNetwork(rn)

            obj.ActorsMap=containers.Map('KeyType','uint32',...
            'ValueType','uint32');
            obj.StaticObjectsMap=containers.Map('KeyType','uint32',...
            'ValueType','uint32');
            obj.MovableObjectsMap=containers.Map('KeyType','uint32',...
            'ValueType','uint32');
            obj.DynamicObjectsMap=containers.Map('KeyType','uint32',...
            'ValueType','uint32');
            obj.RoadsMap=containers.Map('KeyType','uint32',...
            'ValueType','uint32');
            obj.NodesMap=containers.Map('KeyType','uint32',...
            'ValueType','uint32');
            obj.RoadGraph=rn.getDigraph();

            if(strcmpi(rn.AxesOrientation,'ISO8855'))
                obj.AxesOrientation='ISO8855';
            elseif(strcmpi(rn.AxesOrientation,'SAEJ670E'))
                obj.AxesOrientation='SAEJ670E';
            end
            roadsVal=rn.Roads.toArray;
            objectsVal=rn.Objects.toArray;
            nodesVal=rn.Nodes.toArray;

            obj=obj.initialiseRoads(roadsVal,nodesVal);

            obj=obj.initialiseNodes(nodesVal);

            for indx=1:length(obj.Roads)
                obj.Roads(indx)=obj.Roads(indx).assignConnectedRoads(...
                obj.Nodes);
            end
            for indx=1:length(obj.Nodes)
                obj.Nodes(indx)=obj.Nodes(indx).assignConnectedRoads(...
                obj.Nodes,obj.Roads);
            end


            obj=obj.initialiseActorAndObjects(objectsVal);
        end
        function obj=initialiseActor(obj,actors)


            actorArr=cVehicle.empty(length(actors),0);
            obj.ActorDetails=repmat(struct('ID',0,'Position',...
            [0,0,0],'Speed',0),length(actors),1);



            actorPosArr=zeros(length(actors),3);
            count=0;
            for indx=1:length(actors)
                actorElement=actors(indx);
                if(strcmpi(actorElement.Type,'Car')||...
                    strcmpi(actorElement.Type,'Truck')||...
                    strcmpi(actorElement.Type,'Bicycle')||...
                    strcmpi(actorElement.Type,'Pedestrian')||...
                    strcmpi(actorElement.Type,'Motorcycle'))
                    count=count+1;
                    actorArr(count)=cVehicle(actorElement,indx);
                    x=actorArr(count).Pose.Position.X;
                    y=actorArr(count).Pose.Position.Y;
                    z=actorArr(count).Pose.Position.Z;
                    actorPosArr(count,:)=[x,y,z];



                    obj.ActorDetails(indx).ID=actorArr(count).ID;
                    obj.ActorDetails(indx).Position=actorPosArr(count,:);
                    obj.ActorDetails(indx).Speed=0;
                    if(obj.ActorsMap.isKey(actorArr(count).ID)==0)
                        obj.ActorsMap(actorArr(count).ID)=count;
                    else
                        error("Duplicate Actor ID.");
                    end
                end
            end
            actorArr=actorArr(1:count);
            actorPosArr=actorPosArr(1:count,:);
            [roadID,roadIndx,roadType,laneType]=...
            roadUtils.pointToRoadLookup(actorPosArr,...
            obj.Roads,obj.Nodes);
            for indx=1:length(actorArr)
                actorArr(indx).RoadID=roadID(indx);
                actorArr(indx).RoadIndex=roadIndx(indx);
                actorArr(indx).RoadType=roadType(indx);
                actorArr(indx).LaneType=laneType(indx);
                if(actorArr(indx).RoadIndex~=-1)
                    road=obj.Roads(actorArr(indx).RoadIndex);
                    road=road.appendActor(actorArr(indx));
                    obj.Roads(actorArr(indx).RoadIndex)=road;
                else
                    road=obj.Roads(1);
                    road=road.appendActor(actorArr(indx));
                    obj.Roads(1)=road;
                end
            end
            obj.Actors=actorArr;
        end
        function obj=initialiseRoads(obj,roadsVal,nodesUEVal)


            roadsArr=cRoad.empty(length(roadsVal)+1,0);
            roadsArr(1)=cRoad(-1,1);
            obj.RoadsMap(-1)=1;
            for indx=2:length(roadsVal)+1
                roadsArr(indx)=cRoad(roadsVal(indx-1),indx);
                roadsArr(indx)=roadsArr(indx).updateNodeIndexes(...
                nodesUEVal);
                if(obj.RoadsMap.isKey(roadsArr(indx).ID)==0)
                    obj.RoadsMap(roadsArr(indx).ID)=indx;
                else
                    error("Duplicate Road ID.");
                end
            end
            obj.Roads=roadsArr';
        end
        function obj=initialiseActorAndObjects(obj,objectsVal)


            obj=obj.initialiseActor(objectsVal);
            staticObjArr=cActor.empty(length(objectsVal),0);
            movableObjArr=cActor.empty(length(objectsVal),0);
            dynamicObjArr=cActor.empty(length(objectsVal),0);
            staticObjectsPosition=zeros(length(objectsVal),3);
            movableObjectsPosition=zeros(length(objectsVal),3);
            dynamicObjectsPosition=zeros(length(objectsVal),3);
            staticCount=0;
            movableCount=0;
            dynamicCount=0;
            for indx=1:length(objectsVal)
                objectElement=objectsVal(indx);
                if(strcmpi(objectElement.Type,'Barrier'))
                    movableCount=movableCount+1;
                    movableObjArr(movableCount)=...
                    cObstacles(objectElement,indx);
                    x=movableObjArr(movableCount).Pose.Position.X;
                    y=movableObjArr(movableCount).Pose.Position.Y;
                    z=movableObjArr(movableCount).Pose.Position.Z;
                    movableObjectsPosition(movableCount,:)=[x,y,z];
                    if(~obj.MovableObjectsMap.isKey(movableObjArr(...
                        movableCount).ID))
                        obj.MovableObjectsMap(movableObjArr(...
                        movableCount).ID)=movableCount;
                    else
                        error("Duplicate Object ID.");
                    end
                elseif(strcmpi(objectElement.Type,'Pole')||...
                    strcmpi(objectElement.Type,'Tree')||...
                    strcmpi(objectElement.Type,'Building'))
                    staticCount=staticCount+1;
                    staticObjArr(staticCount)=...
                    cObject(objectElement,indx);
                    x=staticObjArr(staticCount).Pose.Position.X;
                    y=staticObjArr(staticCount).Pose.Position.Y;
                    z=staticObjArr(staticCount).Pose.Position.Z;
                    staticObjectsPosition(staticCount,:)=[x,y,z];
                    if(~obj.StaticObjectsMap.isKey(staticObjArr(...
                        staticCount).ID))
                        obj.StaticObjectsMap(staticObjArr(...
                        staticCount).ID)=staticCount;
                    else
                        error("Duplicate Object ID.");
                    end
                elseif(strcmpi(objectElement.Type,'TrafficLight'))
                    dynamicCount=dynamicCount+1;
                    dynamicObjArr(dynamicCount)=...
                    cTrafficLight(objectElement,indx);
                    x=dynamicObjArr(dynamicCount).Pose.Position.X;
                    y=dynamicObjArr(dynamicCount).Pose.Position.Y;
                    z=dynamicObjArr(dynamicCount).Pose.Position.Z;
                    dynamicObjectsPosition(dynamicCount,:)=[x,y,z];
                    if(~obj.DynamicObjectsMap.isKey(dynamicObjArr(...
                        dynamicCount).ID))
                        obj.DynamicObjectsMap(dynamicObjArr(...
                        dynamicCount).ID)=dynamicCount;
                    else
                        error("Duplicate Object ID.");
                    end
                elseif(strcmpi(objectElement.Type,'Unknown'))
                    staticCount=staticCount+1;
                    staticObjArr(staticCount)=...
                    cObject(objectElement,indx);
                    x=staticObjArr(staticCount).Pose.Position.X;
                    y=staticObjArr(staticCount).Pose.Position.Y;
                    z=staticObjArr(staticCount).Pose.Position.Z;
                    staticObjectsPosition(staticCount,:)=[x,y,z];
                    if(~obj.StaticObjectsMap.isKey(staticObjArr(...
                        staticCount).ID))
                        obj.StaticObjectsMap(staticObjArr(...
                        staticCount).ID)=staticCount;
                    else
                        error("Duplicate Object ID.");
                    end
                end
            end
            staticObjArr=staticObjArr(1:staticCount);
            movableObjArr=movableObjArr(1:movableCount);
            dynamicObjArr=dynamicObjArr(1:dynamicCount);
            staticObjectsPosition=staticObjectsPosition(1:staticCount,:);
            movableObjectsPosition=movableObjectsPosition(...
            1:movableCount,:);
            dynamicObjectsPosition=dynamicObjectsPosition(...
            1:dynamicCount,:);

            objectsPosition=[staticObjectsPosition;...
            movableObjectsPosition;...
            dynamicObjectsPosition];
            [roadID,roadIndx,roadType,laneType]=...
            roadUtils.pointToRoadLookup(objectsPosition,obj.Roads,...
            obj.Nodes);

            for indx=1:length(objectsPosition)
                road=obj.getRoad(roadID(indx));
                roadIdx=obj.RoadsMap(roadID(indx));
                if(indx<=staticCount)
                    count=indx;
                    staticObjArr(count).RoadID=roadID(indx);
                    staticObjArr(count).RoadIndex=roadIndx(indx);
                    staticObjArr(count).RoadType=roadType(indx);
                    staticObjArr(count).LaneType=laneType(indx);
                    road.appendObject(staticObjArr(count),'Static');
                elseif(indx>staticCount&&indx<=staticCount+...
                    movableCount)
                    count=indx-staticCount;
                    movableObjArr(count).RoadID=roadID(indx);
                    movableObjArr(count).RoadIndex=roadIndx(indx);
                    movableObjArr(count).RoadType=roadType(indx);
                    movableObjArr(count).LaneType=laneType(indx);
                    road.appendObject(movableObjArr(count),'Movable');
                elseif(indx>staticCount+movableCount&&indx<=...
                    staticCount+movableCount+dynamicCount)
                    count=indx-staticCount-movableCount;
                    dynamicObjArr(count).RoadID=roadID(indx);
                    dynamicObjArr(count).RoadIndex=roadIndx(indx);
                    dynamicObjArr(count).RoadType=roadType(indx);
                    dynamicObjArr(count).LaneType=laneType(indx);
                    road.appendObject(dynamicObjArr(count),'Dynamic');
                end
                obj.Roads(roadIdx)=road;
            end
            staticObjArr=staticObjArr(1:staticCount);
            movableObjArr=movableObjArr(1:movableCount);
            dynamicObjArr=dynamicObjArr(1:dynamicCount);
            obj.StaticObjects=staticObjArr';
            obj.MovableObjects=movableObjArr';
            obj.DynamicObjects=dynamicObjArr';
        end
        function obj=initialiseNodes(obj,nodesVal)

            nodesArr=cNode.empty(length(nodesVal),0);
            for indx=1:length(nodesVal)
                nodeData=nodesVal(indx);
                nodesArr(indx)=cNode(nodeData,indx);
                nodesArr(indx)=nodesArr(indx).updateRoadIndexes(...
                obj.RoadsMap);
                if(obj.NodesMap.isKey(nodesArr(indx).ID)==0)
                    obj.NodesMap(nodesArr(indx).ID)=indx;
                else
                    error("Duplicate Node ID.");
                end
            end
            obj.Nodes=nodesArr';
        end
        function obj=update(obj,time)


            roadsArr=obj.Roads;
            nodesArr=obj.Nodes;
            if(obj.DebugEnabled.FOV)
                disp('#########');
                disp(time);
            end
            for indx=1:length(obj.Actors)
                actor=obj.Actors(indx);
                if(obj.DebugEnabled.FOV)
                    disp('************');
                    disp('ActorID');
                    disp(actor.ID);
                end
                if actor.RoadType==2
                    actor.MotionModel.LookAheadWidth=4;
                else
                    actor.MotionModel.LookAheadWidth=2.0;
                end
                actor=actor.updateLookAheadPolygon(actor.Geometry.Width/2);
                detectedActors=obj.getFOVForActor(actor.ID);
                actor.FOVSensor=actor.FOVSensor.assignDetectedActors(...
                detectedActors,actor);
                actor=actor.update(time);
                [actorFuture,roadsArr,nodesArr]=actor.updateRoad(...
                roadsArr,nodesArr);
                x=actorFuture.Pose.Position.X;
                y=actorFuture.Pose.Position.Y;
                z=actorFuture.Pose.Position.Z;



                obj.ActorDetails(indx).ID=actor.ID;
                obj.ActorDetails(indx).Position=[x,y,z];
                obj.ActorDetails(indx).Speed=actorFuture.MotionModel.ScaledSpeed;
                obj.Actors(indx)=actorFuture;
                if(obj.DebugEnabled.FOV)
                    disp('ActorID road');
                    disp(actorFuture.RoadID);
                    disp('ActorID road Index');
                    disp(actorFuture.RoadIndex);
                    disp('ActorID road type');
                    disp(actorFuture.RoadType);
                    disp('ActorID Position');
                    disp(obj.ActorDetails.Position(indx,:));
                    disp('_______________');
                end
            end
            obj.Roads=roadsArr;
            obj.Nodes=nodesArr;
            if(obj.DebugEnabled.FOV)
                obj=obj.plotUpdate(time);
                disp('#########');
                pause(0.01);
            end
        end
        function data=getActorsInfo(obj,ID)

            actor=obj.getActor(ID);
            data.ID=actor.ID;
            data.Position=[actor.MotionModel.Pose.Position.X...
            ,actor.MotionModel.Pose.Position.Y];
            data.Speed=actor.MotionModel.ScaledSpeed;
            data.PrevSpeed=actor.MotionModel.LastSpeed;
            data.Yaw=actor.MotionModel.Pose.Orientation.Yaw;
            data.Length=actor.Geometry.Length;
            data.Width=actor.Geometry.Width;
            data.Boundary=actor.Geometry.Vertices.Boundary;
            data.LaneType=actor.LaneType;
            data.RoadType=actor.RoadType;
        end
        function road=getRoad(obj,roadID)

            roadID=uint32(roadID);
            if(obj.RoadsMap.isKey(roadID)==0)
                error("Invalid Road ID");
            else
                indx=obj.RoadsMap(roadID);
                road=obj.Roads(indx);
            end
        end
        function obj=plot(obj)
            obj.FigHandle=figure('units','normalized','outerposition',[0,0,1,1]);
            axesH=axes(obj.FigHandle);
            set(axesH,'Units','Normalized');
            cla(axesH,'reset');
            plot(obj.Scenario,'Parent',axesH);
            hold(axesH,'on');
            for indx=1:length(obj.Actors)
                obj.Actors(indx).plot(obj.FigHandle,axesH);
            end
            hold(axesH,'off');
        end
        function obj=plotUpdate(obj,time)
            axesH=axes(obj.FigHandle);
            cla(axesH,'reset');

            plot(obj.Scenario,'Parent',axesH);
            hold(axesH,'on');
            for indx=1:length(obj.Actors)
                obj.Actors(indx).plot(obj.FigHandle,axesH);
            end
            for indx=2:length(obj.Roads)
                road=obj.Roads(indx);
                roadSeg=[road.RoadSegments(1).CentersX(1)-2,...
                road.RoadSegments(1).CentersY(1)-2];
                text(roadSeg(1),roadSeg(2),num2str(road.ID));
            end
            for indx=1:length(obj.Nodes)
                node=obj.Nodes(indx);
                nodeSeg=[node.Position.X-2,node.Position.Y-2];
                text(nodeSeg(1),nodeSeg(2),num2str(node.ID));
            end
            text(0,-200,num2str(time));
            hold(axesH,'off');
        end
        function node=getNode(obj,nodeID)

            nodeID=uint32(nodeID);
            if(obj.NodesMap.isKey(nodeID)==0)
                error("Invalid Actor ID");
            else
                indx=obj.NodesMap(nodeID);
                node=obj.Nodes(indx);
            end
        end
        function actor=getActor(obj,actorID)

            actorID=uint32(actorID);
            if(obj.ActorsMap.isKey(actorID)==0)
                error("Invalid Actor ID");
            else
                indx=obj.ActorsMap(actorID);
                actor=obj.Actors(indx);
            end
        end
        function obj=addEgoActors(obj,egoActors)

            obj.EgoActors=egoActors;
        end
        function actorList=getActorsOnRoad(obj,roadID)

            roadID=uint64(roadID);
            if(obj.RoadsMap.isKey(roadID)==0)
                error("Invalid Road ID");
            else
                actorList=obj.Roads(obj.RoadsMap(roadID)).getActors();
            end
        end
        function actorDetails=getActorDetails(obj)

            actorDetails=obj.ActorDetails;
        end
        function actorList=getActorsOnNode(obj,nodeID)

            nodeID=uint64(nodeID);
            if(obj.NodesMap.isKey(nodeID)==0)
                error("Invalid Node ID");
            else
                actorList=obj.Nodes(obj.NodesMap(nodeID)).getActors();
            end
        end
        function obj=setFOVActorParam(obj,actorID,dist,angle)

            actorID=uint64(actorID);
            actor=obj.getActor(actorID);
            dist=uint64(dist);
            if(dist>0)
                actor.FOVDist=dist;
            end
            angle=uint64(angle);
            if(angle>0)
                actor.FOVAngle=angle;
            end
            actorIndx=obj.ActorsMap(actorID);
            obj.Actors(actorIndx)=actor;
        end
        function actorsData=getFOVForActor(obj,actorID)


            detectedActors=[];
            baseActorID=uint64(actorID);
            baseActor=obj.getActor(baseActorID);
            baseRoadIndx=baseActor.RoadIndex;
            baseRoadType=baseActor.RoadType;
            baseRoadID=baseActor.RoadID;
            if(baseRoadType==1)
                road=obj.Roads(baseRoadIndx);
            elseif(baseRoadType==2)
                road=obj.Nodes(baseRoadIndx);
            else
                road=[];
            end
            if(isempty(road))
                actorsData=[];
                return;
            end
            actorInFOV=road.Actors;
            if(obj.DebugEnabled.FOV)
                disp('Base Road ID');
                disp(baseRoadID);
                disp('Base Road Index');
                disp(baseRoadIndx);
                disp('Base Road Type');
                disp(baseRoadType);
                disp('base Actor');
                disp(baseActor);
                disp("Actor on Road");
                disp(actorInFOV.keys);
            end
            actorInFOVKeys=actorInFOV.keys;
            for idx=1:length(actorInFOV)
                actorID=actorInFOVKeys{idx};
                actor=obj.getActor(actorID);
                if(obj.DebugEnabled.FOV)
                    disp('target Actor');
                    disp(actor);
                end
                if(obj.checkCondition(actor,baseActor))
                    detectedActors=[detectedActors,actorID];
                end
            end
            [connNodesID,connRoadsMap]=road.getNeighbouringRoads();
            if(obj.DebugEnabled.FOV)
                disp('detectedActors');
                disp(detectedActors);
                disp("ConnecteInfo");
                disp(connNodesID);
                disp(connRoadsMap.keys());
            end
            for idx=1:length(connNodesID)
                if(baseRoadIndx==connNodesID(idx)&&baseRoadType==2)
                    continue;
                else
                    node=obj.getNode(connNodesID(idx));
                    actorInFOV=node.Actors;
                    if(obj.DebugEnabled.FOV)
                        disp("Node");
                        disp(node.ID);
                        disp("Actors");
                        disp(actorInFOV.keys);
                    end
                    actorInFOVKeys=actorInFOV.keys;
                    for subIdx=1:length(actorInFOV)
                        actorID=actorInFOVKeys{subIdx};
                        actor=obj.getActor(actorID);
                        if(obj.checkCondition(actor,baseActor))
                            detectedActors=[detectedActors,actorID];
                        end
                    end
                end
            end
            roadIds=connRoadsMap.keys();
            for idx=1:connRoadsMap.Count
                if(baseRoadID==roadIds{idx}&&baseRoadType==1)
                    continue;
                else
                    road=obj.getRoad(roadIds{idx});
                    actorInFOV=road.Actors;
                    if(obj.DebugEnabled.FOV)
                        disp("road");
                        disp(road.ID);
                        disp("Actors");
                        disp(actorInFOV.keys);
                    end
                    actorInFOVKeys=actorInFOV.keys;
                    for subIdx=1:length(actorInFOV)
                        actorID=actorInFOVKeys{subIdx};
                        actor=obj.getActor(actorID);
                        if(obj.checkCondition(actor,baseActor))
                            detectedActors=[detectedActors,actorID];
                        end
                    end
                end
            end
            if(obj.DebugEnabled.FOV)
                disp('Detected Actor ID');
                disp(detectedActors);
                disp('_______________');
            end
            if(~isempty(detectedActors))
                actorsData(1)=obj.getActorsInfo(detectedActors(1));
            else
                actorsData=[];
            end


            for idx=2:length(detectedActors)
                actorsData(idx)=obj.getActorsInfo(detectedActors(idx));
            end
        end
        function flag=checkCondition(~,actor,baseActor)


            basePos=[baseActor.Pose.Position.X,baseActor.Pose.Position.Y];
            dist=baseActor.FOVSensor.FOVDist;
            pos=[actor.Pose.Position.X,actor.Pose.Position.Y];
            pos1=actor.Geometry.Vertices.Upper;
            pos2=actor.Geometry.Vertices.Lower;
            flag=false;
            if((norm(pos-basePos)<=dist||...
                norm(pos1-basePos)<=dist||...
                norm(pos2-basePos)<=dist)&&...
                actor.ID~=baseActor.ID&&...
                actor.MotionModel.queryFreeSpace())
                flag=true;









            end
        end
        function data=getStruct(obj)

            data.StaticObjectsMap=obj.StaticObjectsMap;
            data.MovableObjectsMap=obj.MovableObjectsMap;
            data.DynamicObjectsMap=obj.DynamicObjectsMap;
            data.ActorsMap=obj.ActorsMap;
            data.RoadsMap=obj.RoadsMap;
            data.NodesMap=obj.NodesMap;
            data.RoadGraph=obj.RoadGraph;
            data.AxesOrientation=obj.AxesOrientation;
            data.DrivingDir=obj.DrivingDir;

            if(~isempty(obj.Actors))
                actorsTemp=struct(obj.Actors(1).getStruct());
            else
                actorsTemp=struct([]);
            end
            for idx=1:length(obj.Actors)
                actor=obj.Actors(idx);
                actorsTemp(idx)=actor.getStruct();
            end
            data.actors=actorsTemp;

            if(~isempty(obj.Roads))
                roadsTemp=struct(obj.Roads(1).getStruct());
            else
                roadsTemp=struct([]);
            end
            for idx=1:length(obj.Roads)
                road=obj.Roads(idx);
                roadsTemp(idx)=road.getStruct();
            end
            data.roads=roadsTemp;

            if(~isempty(obj.Nodes))
                nodesTemp=struct(obj.Nodes(1).getStruct());
            else
                nodesTemp=struct([]);
            end
            for idx=1:length(obj.Nodes)
                node=obj.Nodes(idx);
                nodesTemp(idx)=node.getStruct();
            end
            data.nodes=nodesTemp;
        end
        function data=getAxes(obj)
            data=obj.AxesOrientation;
            if(strcmpi(data,'ISO8855'))
                data=uint64(1);
            else
                data=uint64(2);
            end
        end
    end
end
