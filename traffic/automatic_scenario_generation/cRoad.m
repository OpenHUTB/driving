classdef cRoad




    properties

        Actors;

        StaticObjects;

        MovableObjects;

        DynamicObjects;

        ConnectedRoads;

        ID;

        Index;

        Name;

        Weight;

        Direction;

        StartNode;

        StartNodeIndex;

        EndNode;

        EndNodeIndex;

        RoadSegments;

        RoadSegmentsPolygon;

        SpeedLimit=-1;
    end
    methods
        function obj=cRoad(road,index)

            if(~isa(road,'driving.roadnetwork.Road'))
                obj.ID=-1;
                obj.Index=index;
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
                obj.Name='';
                obj.Weight=intmax;
                obj.Direction=cDirectionOfTravel('Unknown');
                obj.RoadSegments=cRoadSegment.empty(1,0);
                return;
            end
            obj.ID=road.ID;
            obj.Name=road.Name;
            obj.Weight=road.Weight;
            if(strcmpi(road.Direction,'Forward'))
                obj.Direction=cDirectionOfTravel('Forward');
            elseif(strcmpi(road.Direction,'Backward'))
                obj.Direction=cDirectionOfTravel('Backward');
            elseif(strcmpi(road.Direction,'None'))
                obj.Direction=cDirectionOfTravel('None');
            elseif(strcmpi(road.Direction,'Both'))
                obj.Direction=cDirectionOfTravel('Both');
            else
                obj.Direction=cDirectionOfTravel('Unknown');
            end

            obj.StartNode=road.StartNode.ID;
            obj.EndNode=road.EndNode.ID;

            roadSegments=road.RoadSegments.toArray;
            roadSegmentsTemp=cRoadSegment.empty(length(roadSegments),0);
            for indx=1:length(roadSegments)
                roadSegmentsTemp(indx)=cRoadSegment(roadSegments(...
                indx),indx);
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
            obj.Index=index;
        end
        function obj=updateRoadSegmentPolygon(obj)

            segmentsInRoad=obj.RoadSegments;
            shiftedLeft=[];
            shiftedRight=[];
            centersPoints=[];
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
                shiftedLeft=[shiftedLeft;shiftedPathLeft];
                shiftedRight=[shiftedRight;shiftedPathRight];
                centersPoints=centers;
            end
            obj.RoadSegmentsPolygon.ShiftedLeft=shiftedPathLeft;
            obj.RoadSegmentsPolygon.CenterPoints=centersPoints;
            obj.RoadSegmentsPolygon.ShiftedRight=shiftedRight;
        end
        function obj=updateNodeIndexes(obj,Nodes)

            startNodeData=obj.StartNode;
            endNodeData=obj.EndNode;
            for indx=1:length(Nodes)
                element=Nodes(indx);
                if(element.ID==startNodeData)
                    obj.StartNodeIndex=indx;
                end
                if(element.ID==endNodeData)
                    obj.EndNodeIndex=indx;
                end
            end
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
                obj.StaticObjects(object.ID)=object.Index;
            elseif(strcmpi(type,"Movable"))
                obj.MovableObjects(object.ID)=object.Index;
            elseif(strcmpi(type,"Dynamic"))
                obj.DynamicObjects(object.ID)=object.Index;
            end
        end
        function obj=removeObject(obj,object,type)

            if(strcmpi(type,"Static")&&...
                obj.StaticObjects.isKey(object.ID))
                obj.StaticObjects.remove(object.ID);
            elseif(strcmpi(type,"Movable")&&...
                obj.MovableObjects.isKey(object.ID))
                obj.MovableObjects.remove(object.ID);
            elseif(strcmpi(type,"Dynamic")&&...
                obj.DynamicObjects.isKey(object.ID))
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
        function[nodes,roads]=getNeighbouringRoads(obj)


            roads=obj.ConnectedRoads;
            nodes=[obj.StartNode,obj.EndNode];
        end
        function obj=assignConnectedRoads(obj,nodes)


            startNodeTemp=nodes(obj.StartNodeIndex);
            endNodeTemp=nodes(obj.EndNodeIndex);
            roads=[startNodeTemp.IncomingRoads...
            ,startNodeTemp.OutgoingRoads...
            ,endNodeTemp.IncomingRoads...
            ,endNodeTemp.OutgoingRoads];
            roadsIndex=[startNodeTemp.IncomingRoadsIndex...
            ,startNodeTemp.OutgoingRoadsIndex...
            ,endNodeTemp.IncomingRoadsIndex...
            ,endNodeTemp.OutgoingRoadsIndex];
            for indx=1:length(roads)
                element=roads(indx);
                if(obj.ConnectedRoads.isKey(element)==0)
                    obj.ConnectedRoads(element)=roadsIndex(indx);
                end
            end
        end
        function data=getStruct(obj)
            data.Actors=obj.Actors;
            data.StaticObjects=obj.StaticObjects;
            data.MovableObjects=obj.MovableObjects;
            data.DynamicObjects=obj.DynamicObjects;
            data.ConnectedRoads=obj.ConnectedRoads;
            data.ID=obj.ID;
            data.Index=obj.Index;
            data.Name=obj.Name;
            data.Weight=obj.Weight;
            data.Direction=obj.Direction;
            data.StartNode=obj.StartNode;
            data.StartNodeIndex=obj.StartNodeIndex;
            data.EndNode=obj.EndNode;
            data.EndNodeIndex=obj.EndNodeIndex;
            data.SpeedLimit=obj.SpeedLimit;

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

