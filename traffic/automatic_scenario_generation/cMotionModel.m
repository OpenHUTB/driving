classdef(Abstract)cMotionModel





    properties(Access=public,Hidden=true)

        Pose(1,1)cPose;

        LastPose(1,1)cPose;

        TimeStamp(1,1)double{mustBeNonNan,mustBeFinite,...
        mustBeNonnegative}=0;

        LastTimeStamp(1,1)double{mustBeNonNan,mustBeFinite,...
        mustBeNonnegative}=0;
    end
    properties(SetAccess=public,Hidden=true)

        Mass(1,1)double{mustBeNonNan,mustBeFinite,...
        mustBePositive}=1200;

        Inertia(1,1)double{mustBeNonNan,mustBeFinite,...
        mustBePositive}=1900;
    end
    properties(Access=private,Hidden=true)

        InitialPose=0;
    end
    methods(Access=public,Hidden=true)
        function obj=cMotionModel(varargin)

            if(nargin>=1)
                actor=varargin{1};
                obj.Pose=cPose([actor.PositionX,actor.PositionY...
                ,actor.PositionZ],[actor.Yaw...
                ,actor.Pitch,actor.Roll]);
                obj.LastPose=obj.Pose;
                obj.InitialPose=obj.Pose;
            else
                obj.Pose=cPose();
                obj.LastPose=obj.Pose;
                obj.InitialPose=obj.Pose;
            end
        end
        function obj=reset(obj)

            obj.Pose=obj.InitialPose;
            obj.LastPose=obj.InitialPose;
            obj.TimeStamp=0;
            obj.LastTimeStamp=0;
        end
        function obj=updateParams(obj,varargin)


            parser=inputParser;
            addOptional(parser,'Mass',-1);
            addOptional(parser,'Inertia',-1);
            parse(parser,varargin{:});
            results=parser.Results;
            if(results.Mass~=-1&&results.Mass>0)
                obj.Mass=results.Mass;
            end
            if(results.Inertia~=-1&&results.Inertia>0)
                obj.Inertia=results.Inertia;
            end
        end

    end
end

