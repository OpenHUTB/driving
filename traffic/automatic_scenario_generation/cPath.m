classdef cPath




    properties(SetAccess=private,Hidden=true)

        InputWaypoints=[];

        SampledWaypoints=[];

        Speed double{mustBeFinite,mustBeNonNan}=[];

        WaitTime=[];

        Yaw=[];

        InitialYaw(1,1)double{mustBeFinite,mustBeNonNan}=0;

        Dist=[];

        PathLen=[];

        EntryTime=0;

        ExitTime=inf;

        DefaultSpeed=10;

        PtNum(1,1)uint32{mustBeFinite,mustBeNonNan,mustBePositive}=6;
    end
    properties(Access=private,Hidden=true)

        UpSampledWaypoints=[];

        UpSampledYaw=[];

        UpSampledDist=[];

        UpSampledPathLen=[];

        UpSamplingPtNum=1024;
    end
    properties(Access=public,Hidden=true)

        Index(1,1)uint32{mustBeNonNan,mustBeFinite}=1;

        Time(1,1)double{mustBeNonnegative,mustBeFinite,...
        mustBeNonNan}=0;

        SampleTime(1,1)double{mustBeNonnegative,mustBeFinite,...
        mustBeNonNan}=0;

        AccumDist=0;

        Type=1;
    end

    methods(Access=public,Hidden=true)
        function obj=cPath(varargin)

            if(nargin>=1)

                parser=inputParser;
                addRequired(parser,'Waypoints');
                addRequired(parser,'UpSampledPts');
                addRequired(parser,'Speed');
                addOptional(parser,'EntryTime',0);
                addOptional(parser,'ExitTime',inf);
                addOptional(parser,'WaitTime',0);
                addOptional(parser,'DownSample',6);
                addOptional(parser,'InitialYaw',0);
                addOptional(parser,'SampleTime',0);
                parse(parser,varargin{:});
                results=parser.Results;

                waypoints=results.Waypoints;
                upSampledPts=results.UpSampledPts;
                speedVal=results.Speed;
                entryTime=results.EntryTime;
                exitTime=results.ExitTime;
                waitTime=results.WaitTime;
                downSample=results.DownSample;
                initialYaw=results.InitialYaw;
                sampleTime=results.SampleTime;

                obj.InputWaypoints=waypoints;
                if(isempty(waypoints))
                    obj.Type=0;
                    return;
                end

                if(size(upSampledPts,1)<=1||size(upSampledPts,2)<=2)
                    disp("Invalid upsampled Input.");
                    upSampledPts=[0,0;1,1;];
                end
                obj.UpSampledWaypoints=upSampledPts;
                obj.UpSamplingPtNum=(size(upSampledPts,1)-1)/...
                (size(obj.InputWaypoints,1)-1);
                if(downSample<=obj.UpSamplingPtNum)
                    obj.PtNum=downSample;
                else
                    error("Number of points more than sampled point.");
                end
                obj=obj.setSpeedProfile(speedVal);
                obj.EntryTime=entryTime;
                obj.ExitTime=exitTime;
                obj=obj.setWaitTime(waitTime);
                obj.InitialYaw=initialYaw;
                obj.SampleTime=sampleTime;
                obj=obj.computeDistancesAndYaw();
                obj=obj.downSampleWaypoints();
            end
        end
        function obj=reset(obj)
            obj.Index=1;
            obj.Time=0;
            obj.AccumDist=0;
        end
    end
    methods(Access=private)
        function obj=setSpeedProfile(obj,value)



            if(isscalar(value))
                obj.Speed=value*ones(size(obj.InputWaypoints));
                return;
            end
            if(size(value,1)~=1||size(value,2)~=1)
                disp("Invalid Size.");
                obj.Speed=obj.DefaultSpeed;
                return;
            end
            if(size(value,1)==size(obj.Waypoints,1))
                obj.Speed=value;
                return;
            else
                obj.Speed=obj.DefaultSpeed*ones(size(obj.InputWaypoints));
                disp(["The path doesn't same same number of",...
                " waypoints and speed points."]);
            end
        end
        function obj=setWaitTime(obj,value)





            if(size(value,1)==size(obj.InputWaypoints,1))
                obj.WaitTime=value;
                return;
            elseif(size(value,1)~=0)
                obj.WaitTime=0;
                disp(["The path doesn't same same number of",...
                " waypoints and waiting points."]);
            end
        end
        function obj=downSampleWaypoints(obj)

            pathEnd=length(obj.UpSampledYaw);
            step=obj.UpSamplingPtNum/obj.PtNum;
            indices=1:step:pathEnd;
            indices=floor(indices);
            obj.Yaw=obj.UpSampledYaw(indices);
            obj.Dist=obj.UpSampledDist(indices);
            obj.PathLen=obj.UpSampledPathLen(indices);
            obj.SampledWaypoints=obj.UpSampledWaypoints(indices,:);
        end
        function obj=computeDistancesAndYaw(obj)

            diffVal=diff(obj.UpSampledWaypoints);
            yawTemp=atan2(diffVal(:,2),diffVal(:,1));
            yawTemp=[yawTemp;yawTemp(end)];
            obj.UpSampledYaw=yawTemp;
            distTemp=sqrt(diffVal(:,1).^2+diffVal(:,2).^2);
            distTemp=[0;distTemp];
            obj.UpSampledDist=distTemp;
            obj.UpSampledPathLen=cumsum(distTemp);
        end
    end
end
