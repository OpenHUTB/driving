classdef cLane




    properties(Access=public,Hidden=true)

        ID;

        Direction;

        LeftMarkingID;

        LeftMarkingIndex;

        RightMarkingID;

        RightMarkingIndex;

        SpeedLimit=-1;

        Type;

        Width;
    end
    methods(Access=public,Hidden=true)
        function obj=cLane(lane)

            if(strcmpi(lane.Direction,'Forward'))
                obj.Direction=cDirectionOfTravel('Forward');
            elseif(strcmpi(lane.Direction,'Backward'))
                obj.Direction=cDirectionOfTravel('Backward');
            elseif(strcmpi(lane.Direction,'None'))
                obj.Direction=cDirectionOfTravel('None');
            elseif(strcmpi(lane.Direction,'Both'))
                obj.Direction=cDirectionOfTravel('Both');
            else
                obj.Direction=cDirectionOfTravel('Unknown');
            end
            obj.ID=lane.ID;
            obj.Direction=lane.Direction;
            obj.Width=lane.Width;
            obj.LeftMarkingID=lane.LeftMarkingID;
            obj.RightMarkingID=lane.RightMarkingID;
            if(strcmpi(lane.Type,'Shoulder'))
                obj.Type=cLaneType('Shoulder');
            elseif(strcmpi(lane.Type,'Restricted'))
                obj.Type=cLaneType('Restricted');
            elseif(strcmpi(lane.Type,'Parking'))
                obj.Type=cLaneType('Parking');
            elseif(strcmpi(lane.Type,'HOV'))
                obj.Type=cLaneType('HOV');
            elseif(strcmpi(lane.Type,'Express'))
                obj.Type=cLaneType('Express');
            elseif(strcmpi(lane.Type,'Driving'))
                obj.Type=cLaneType('Driving');
            elseif(strcmpi(lane.Type,'Bus'))
                obj.Type=cLaneType('Bus');
            elseif(strcmpi(lane.Type,'Border'))
                obj.Type=cLaneType('Border');
            elseif(strcmpi(lane.Type,'Bicycle'))
                obj.Type=cLaneType('Bicycle');
            elseif(strcmpi(lane.Type,'Pedestrian'))
                obj.Type=cLaneType('Pedestrian');
            else
                obj.Type=cLaneType('Unknown');
            end
        end
        function[color,strength]=getColor(~,lane)

            strength=lane.Strength;
            laneColor=lane.Color.toArray;
            if(~isempty(laneColor))
                color=[laneColor(1),laneColor(2),laneColor(3)];
            else
                color=[0,0,0];
            end
        end
        function data=getStruct(obj)
            data.ID=obj.ID;
            data.Direction=obj.Direction;
            data.LeftMarkingID=obj.LeftMarkingID;
            data.LeftMarkingIndex=obj.LeftMarkingIndex;
            data.RightMarkingID=obj.RightMarkingID;
            data.RightMarkingIndex=obj.RightMarkingIndex;
            data.SpeedLimit=obj.SpeedLimit;
            data.Type=obj.Type;
            data.Width=obj.Width;
        end

    end
end

