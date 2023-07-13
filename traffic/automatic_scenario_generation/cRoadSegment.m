classdef cRoadSegment





    properties(Access=public,Hidden=true)

        AccumulatedWidth(1,1)double{mustBeNonNan,mustBeFinite,...
        mustBeNonnegative}=0;

        AccumulatedLength(1,1)double{mustBeNonNan,mustBeFinite,...
        mustBeNonnegative}=0;

        BankingAngles;

        ID(1,1)int32{mustBeNonNan,mustBeFinite,...
        mustBeGreaterThan(ID,-2)}=-1;

        Index(1,1)int32{mustBeNonNan,mustBeFinite,...
        mustBeNonnegative}=0;

        CentersX(1,:)double{mustBeNonNan,mustBeFinite};

        CentersY(1,:)double{mustBeNonNan,mustBeFinite};

        CentersZ(1,:)double{mustBeNonNan,mustBeFinite};

        Lanes;

        LaneMarking;

        FwdLaneDist;

        BkdLaneDist;

    end
    methods(Access=public,Hidden=true)
        function obj=cRoadSegment(roadSegment,index)



            obj.ID=roadSegment.ID;
            obj.CentersX=roadSegment.CentersX.toArray;
            obj.CentersY=roadSegment.CentersY.toArray;
            obj.CentersZ=roadSegment.CentersZ.toArray;
            obj.BankingAngles=roadSegment.BankingAngles.toArray;
            obj.AccumulatedLength=0;
            for indx=1:length(obj.CentersX)-1
                point1=[obj.CentersX(indx),obj.CentersY(indx)...
                ,obj.CentersZ(indx)];
                point2=[obj.CentersX(indx+1),obj.CentersY(indx+1)...
                ,obj.CentersZ(indx+1)];
                diff=point2-point1;
                dist=norm(diff);
                obj.AccumulatedLength=obj.AccumulatedLength+dist;
            end
            lanes=roadSegment.Lanes.toArray;
            lanesTemp=cLane.empty(length(lanes),0);
            lanesColor=zeros(length(lanes),3);
            lanesStrength=zeros(length(lanes),1);
            for indx=1:length(lanes)
                lanesTemp(indx)=cLane(lanes(indx));
                [lanesColor(indx,:),lanesStrength(indx)]=...
                lanesTemp(indx).getColor(lanes(indx));
            end
            laneMarking=roadSegment.LaneMarkings.toArray;
            laneMarkingTemp=cLaneMarking.empty(length(laneMarking),0);
            for indx=1:length(laneMarking)
                laneMarkingTemp(indx)=cLaneMarking(laneMarking(indx));
            end

            for indx=1:length(laneMarking)
                if(indx==1)
                    laneMarkingTemp(1).Color=lanesColor(1,:);
                    laneMarkingTemp(1).Strength=lanesStrength(1);
                elseif(indx==length(laneMarking))
                    laneMarkingTemp(end).Color=lanesColor(end,:);
                    laneMarkingTemp(end).Strength=lanesStrength(end);
                else
                    laneMarkingTemp(indx).Color=(lanesColor(indx-1,:)+lanesColor(indx,:))/2;
                    laneMarkingTemp(indx).Strength=(lanesStrength(indx-1)+lanesStrength(indx))/2;
                end
            end
            obj.LaneMarking=laneMarkingTemp;

            for indx=1:length(lanes)
                lanesTemp(indx)=cLane(lanes(indx));
                leftMarkingID=lanesTemp(indx).LeftMarkingID;
                rightMarkingID=lanesTemp(indx).RightMarkingID;
                for subIndx=1:length(laneMarkingTemp)
                    laneMarkingVal=laneMarkingTemp(subIndx);
                    if(leftMarkingID==laneMarkingVal.ID)
                        lanesTemp(indx).LeftMarkingIndex=subIndx;
                    end
                    if(rightMarkingID==laneMarkingVal.ID)
                        lanesTemp(indx).RightMarkingIndex=subIndx;
                    end
                end
            end
            obj.Lanes=lanesTemp;
            obj=obj.aggregateRoadCenters();
            obj.Index=index;
        end
        function obj=setLanesPositions(obj)


            numOfLanes=length(obj.Lanes);
            AccumulatedWidth=zeros(2*numOfLanes,1);
        end
        function obj=aggregateRoadCenters(obj)

            laneCount=length(obj.Lanes);
            fLaneDist=zeros(1,2*laneCount);
            bLaneDist=zeros(1,2*laneCount);
            fLaneCount=laneCount;
            bLaneCount=0;
            fLaneWidth=0;
            bLaneWidth=0;
            bCounter=0;
            fCounter=0;
            width=0;
            for indx=1:laneCount
                width=width+obj.Lanes(indx).Width;
                if(~(strcmpi(obj.Lanes(indx).Type,'Shoulder')||...
                    strcmpi(obj.Lanes(indx).Type,'Unsupported')||...
                    strcmpi(obj.Lanes(indx).Type,'Unknown')))
                    if(strcmpi(obj.Lanes(indx).Direction,'Backward')||...
                        strcmpi(obj.Lanes(indx).Direction,'Both'))
                        bLaneCount=indx;
                    end
                end
            end































        end
        function data=getStruct(obj)
            data.AccumulatedWidth=obj.AccumulatedWidth;
            data.AccumulatedLength=obj.AccumulatedLength;
            data.BankingAngles=obj.BankingAngles;
            data.ID=obj.ID;
            data.Index=obj.Index;
            data.CentersX=obj.CentersX;
            data.CentersY=obj.CentersY;
            data.CentersZ=obj.CentersZ;
            data.LaneMarking=obj.LaneMarking;
            data.AccumulatedWidth=obj.AccumulatedWidth;
            data.FwdLaneDist=obj.FwdLaneDist;
            data.BkdLaneDist=obj.BkdLaneDist;
            if(~isempty(obj.Lanes))
                lanesTemp=struct(obj.Lanes(1).getStruct());
            else
                lanesTemp=struct([]);
            end
            for idx=1:length(obj.Lanes)
                lane=obj.Lanes(idx);
                lanesTemp(idx)=lane.getStruct();
            end
            data.Lanes=lanesTemp;
        end
    end
end

