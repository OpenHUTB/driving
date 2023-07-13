classdef cActor<matlab.mixin.Heterogeneous





    properties(Access=public,Hidden=true)

        RoadID(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        RoadIndex(1,1)int32{mustBeNonNan,mustBeFinite}=0;

        RoadType(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        LaneType(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        Type(1,1)uint32{mustBeNonNan,mustBeFinite}=0;
    end

    properties(SetAccess=protected,Hidden=true)

        ID(1,1)uint32{mustBeNonNan,mustBeFinite}=0;

        Pose;

        Geometry(1,1)cGeometry;

        Index;

        Name(1,:)char;

        Color(1,3)uint32{mustBeNonNan,mustBeFinite};
    end
    methods(Access=public,Hidden=true)
        function obj=cActor(actor,index)

            obj.ID=actor.ID;
            obj.Name=actor.Name;
            obj.Index=uint32(index);
            obj.Pose=cPose([actor.PositionX,actor.PositionY...
            ,actor.PositionZ],[actor.Yaw...
            ,actor.Pitch,actor.Roll]);
            obj.Geometry=cGeometry('Length',actor.Length,'Width',...
            actor.Width,'Height',actor.Height);
            obj.Color=[actor.Color(1),actor.Color(2),actor.Color(3)];
        end
        function pos=getPosition(obj)

            pos=[obj.Pose.Position.X,obj.Pose.Position.Y...
            ,obj.Pose.Position.Z];
        end
        function pos=getPosition2D(obj)

            pos=[obj.Pose.Position.X,obj.Pose.Position.Y];
        end
        function obj=updateGeometry(obj,varargin)

            obj.Geometry=obj.Geometry.updateParams(varargin{:});
        end
        function data=getStruct(obj)

            data.Color=obj.Color;
            data.Pose=obj.Pose.getStruct();
            data.Geometry=obj.Geometry.getStruct();
            data.FOVDist=obj.FOVDist;
            data.ID=obj.ID;
            data.Index=obj.Index;
            data.Name=obj.Name;
            data.RoadID=obj.RoadID;
            data.RoadIndex=obj.RoadIndex;
            data.RoadType=obj.RoadType;
            data.Type=obj.Type;
        end
    end
end
