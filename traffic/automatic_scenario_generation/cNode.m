classdef cNode




    properties(Access=public,Hidden=true)

        Actors containers.Map;

        StaticObjects containers.Map;

        MovableObjects containers.Map;

        DynamicObjects containers.Map;

        ID(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        Index(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        IncomingRoads;

        IncomingRoadsIndex;

        Name(1,:)char;

        OutgoingRoads;

        OutgoingRoadsIndex;

        Position(1,1)cVector;

        RoadSegments;

        SpeedLimit=-1;

        NodeSegmentsPolygon;

        ConnectedRoads containers.Map;
    end

    methods(Access=public,Hidden=true)
        function obj=cNode(inputNode,index)

            obj.ID=inputNode.ID;
            obj.Name=inputNode.Name;
            posX=inputNode.PositionX;
            posY=inputNode.PositionY;
            posZ=inputNode.PositionZ;
            obj.Position=cVector(posX,posY,posZ);
            obj.Index=uint32(index);
            outgoingRoads=inputNode.OutgoingRoads.toArray;
            outgoingRoadsTemp=uint32.empty(length(outgoingRoads),0);
            for indx=1:length(outgoingRoads)
                outgoingRoadsTemp(indx)=outgoingRoads(indx).ID;
            end
            obj.OutgoingRoads=outgoingRoadsTemp;

            incomingRoads=inputNode.IncomingRoads.toArray;
            incomingRoadsTemp=uint32.empty(length(incomingRoads),0);
            for indx=1:length(incomingRoads)
                incomingRoadsTemp(indx)=incomingRoads(indx).ID;
            end
            obj.IncomingRoads=incomingRoadsTemp;

            roadSegmentsArr=inputNode.RoadSegments.toArray;
            roadSegmentsTemp=cRoadSegment.empty(length(roadSegmentsArr),0);
            for indx=1:length(roadSegmentsArr)
                roadSegmentsTemp(indx)=cRoadSegment(roadSegmentsArr(indx),indx);
            end
            obj.RoadSegments=roadSegmentsTemp;
            obj=obj.updateRoadSegmentPolygon();
            obj.ConnectedRoads=containers.Map('KeyType','int32',...
            'ValueType','int32');
            obj.Actors=containers.Map('KeyType','int32',...
            'ValueType','int32');
            obj.StaticObjects=containers.Map('KeyType','int32',...
            'ValueType','int32');
            obj.MovableObjects=containers.Map('KeyType','int32',...
            'ValueType','int32');
            obj.DynamicObjects=containers.Map('KeyType','int32',...
            'ValueType','int32');
        end
        function obj=updateRoadSegmentPolygon(obj)

            segmentsInRoad=obj.RoadSegments;
            data=struct('ShiftedLeft',[],'CenterPoints',[],...
            'ShiftedRight',[]);
            for indx=1:length(segmentsInRoad)
                lanes=segmentsInRoad(indx).Lanes;
                centersX=segmentsInRoad(indx).CentersX;
                centersY=segmentsInRoad(indx).CentersY;
                centersZ=segmentsInRoad(indx).CentersZ;
                laneCount=length(lanes);
                laneWidthLeft=0;
                laneWidthRight=0;
                laneCountLeft=0;
                laneCountRight=0;
                maxVal=max(centersZ);
                minVal=min(centersZ);
                for subIndx=1:laneCount
                    if(lanes(subIndx).Direction=='Forward'||...
                        lanes(subIndx).Direction=='Both')
                        laneWidthLeft=laneWidthLeft+...
                        lanes(subIndx).Width;
                    end
                    if(lanes(subIndx).Direction=='Backward'||...
                        lanes(subIndx).Direction=='Both')
                        laneWidthRight=laneWidthRight+...
                        lanes(subIndx).Width;
                    end
                    if(lanes(subIndx).Type=='Driving')
                        laneCountRight=laneCountRight+1;
                    else
                        laneCountLeft=laneCountLeft+1;
                    end
                end
                centers=[centersX',centersY',centersZ'];
                if(laneWidthRight==0)
                    laneWidthRight=laneWidthLeft;
                end
                if(laneWidthLeft==0)
                    laneWidthLeft=laneWidthRight;
                end
                shiftedPathLeft=mathUtils.shiftPoints(centers,...
                1.05*laneWidthLeft,-1);
                shiftedPathRight=mathUtils.shiftPoints(centers,...
                1.05*laneWidthRight,1);
                dataTemp.ShiftedLeft=shiftedPathLeft;
                dataTemp.CenterPoints=centers;
                dataTemp.ShiftedRight=shiftedPathRight;
                data=[data;dataTemp];
            end
            obj.NodeSegmentsPolygon=data;
        end
        function obj=appendActor(obj,actor)

            if(~obj.Actors.isKey(actor.ID))
                obj.Actors(actor.ID)=actor.Index;
            end
        end
        function obj=removeActor(obj,actor)

            if(obj.Actors.isKey(actor.ID))
                obj.Actors.remove(actor.ID);
            end
        end
        function actors=getActors(obj)

            actors=obj.Actors;
        end
        function obj=appendObject(obj,object,type)

            if(strcmpi(type,"Static"))
                obj.StaticObjects(object.ID)=object.index;
            elseif(strcmpi(type,"Movable"))
                obj.MovableObjects(object.ID)=object.index;
            elseif(strcmpi(type,"Dynamic"))
                obj.DynamicObjects(object.ID)=object.index;
            end
        end
        function obj=removeObject(obj,object,type)

            if(strcmpi(type,"Static")&&...
                obj.StaticObjects.isKey(object.ID))
                obj.StaticObjects.remove(object.ID);
            elseif(strcmpi(type,"Movable")&&...
                obj.StaticObjects.isKey(object.ID))
                obj.MovableObjects.remove(object.ID);
            elseif(strcmpi(type,"Dynamic")&&...
                obj.StaticObjects.isKey(object.ID))
                obj.DynamicObjects.remove(object.ID);
            end
        end
        function objects=getObjects(obj,type)

            if(strcmpi(type,"Static"))
                objects=obj.StaticObjects;
            elseif(strcmpi(type,"Movable"))
                objects=obj.MovableObjects;
            elseif(strcmpi(type,"Dynamic"))
                objects=obj.DynamicObjects;
            end
        end
        function[nodes,roads]=getNeighbouringRoadsByDist(obj,dist,actorPos,nodes,roads)


            diff=obj.Position-ActorPos;
        end
        function[nodes,roads]=getNeighbouringRoads(obj)

            roads=obj.ConnectedRoads;
            nodes=[obj.ID];
        end
        function obj=assignConnectedRoads(obj,nodes,roads)


            roads=[obj.OutgoingRoads,obj.IncomingRoads];
            roadsIndex=[obj.IncomingRoadsIndex,obj.OutgoingRoadsIndex];
            for indx=1:length(roads)
                element=roads(indx);
                if(obj.ConnectedRoads.isKey(element)==0)
                    obj.ConnectedRoads(element)=roadsIndex(indx);
                end
            end
        end
        function obj=updateRoadSegments(obj,roadSegments)

            roadArr=cRoad.empty(length(roadSegments),0);
        end
        function obj=updateRoadIndexes(obj,roadsMap)


            incomingRoadsIDs=obj.IncomingRoads;
            incomingRoadsIndexes=incomingRoadsIDs;
            for indx=1:length(incomingRoadsIDs)
                element=incomingRoadsIDs(indx);
                if(roadsMap.isKey(element))
                    incomingRoadsIndexes(indx)=roadsMap(element);
                else
                    disp("No such road found.");
                end
            end
            outgoingRoadsIDs=obj.OutgoingRoads;
            outgoingRoadsIndexes=outgoingRoadsIDs;
            for indx=1:length(outgoingRoadsIDs)
                element=outgoingRoadsIDs(indx);
                if(roadsMap.isKey(element))
                    outgoingRoadsIndexes(indx)=roadsMap(element);
                else
                    disp("No such road found.");
                end
            end
            obj.IncomingRoadsIndex=incomingRoadsIndexes;
            obj.OutgoingRoadsIndex=outgoingRoadsIndexes;
        end
        function data=getStruct(obj)
            data.Actors=obj.Actors;
            data.StaticObjects=obj.StaticObjects;
            data.MovableObjects=obj.MovableObjects;
            data.DynamicObjects=obj.DynamicObjects;
            data.ID=obj.ID;
            data.Index=obj.Index;
            data.Name=obj.Name;
            data.IncomingRoads=obj.IncomingRoads;
            data.IncomingRoadsIndex=obj.IncomingRoadsIndex;
            data.OutgoingRoads=obj.OutgoingRoads;
            data.OutgoingRoadsIndex=obj.OutgoingRoadsIndex;
            data.ConnectedRoads=obj.ConnectedRoads;
            data.SpeedLimit=obj.SpeedLimit;
            data.Position=obj.Position.getStruct();

            if(~isempty(obj.RoadSegments))
                roadSegmentsTemp=struct(obj.RoadSegments(1).getStruct());
            else
                roadSegmentsTemp=struct([]);
            end
            for idx=1:length(obj.RoadSegments)
                roadSegment=obj.RoadSegments(idx);
                roadSegmentsTemp(idx)=roadSegment.getStruct();
            end
            data.RoadSegments=roadSegmentsTemp;
        end
    end
end

