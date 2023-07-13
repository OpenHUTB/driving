classdef simpleMotionModel<cMotionModel




    properties(Access=public)

        Path;

        Scale(1,1)double=1;

        ScaleCumulative(1,1)double=1;

        CumulativeLength=0;

        Speed(1,1)double=0;

        State=true;

        InitialSpeed(1,1)double=0;

        ScaledSpeed(1,1)double=0;

        LastSpeed(1,1)double=0;

        OverrideSpeed=0;

        Accel=0;

        AngVelocity=0;

        AngAccel=0;

        LookAheadPath=struct('Left',[],'Right',[],'Center',[]);

        LookAheadDist=16;

        LookAheadWidth=2;

        FutureYaw=0;

        FutureYawDist=2.5;

        Counter=0;
    end
    properties(SetAccess=private)

        Velocity=[0,0,0];
    end
    methods(Access=public)
        function obj=simpleMotionModel(actor)

            obj@cMotionModel(actor);
        end
        function obj=update(obj,time)

            if(obj.State~=false&&obj.queryFreeSpace())
                obj=obj.selectSpeed();
                obj=obj.accumulateTime(time);
            end





        end
        function obj=selectSpeed(obj)

            index=obj.Path.Index;
            velIndx=floor(index/obj.Path.PtNum);
            if(velIndx<=0)
                xIndx=1;
                yIndx=2;
            else
                xIndx=velIndx;
                yIndx=velIndx+1;
            end
            intialVel=obj.Path.Speed(xIndx);
            finalVel=obj.Path.Speed(yIndx);
            distInit=obj.Path.PathLen(xIndx);
            distFinal=obj.Path.PathLen(yIndx);
            distDiff=distFinal-distInit;
            distTravelled=obj.CumulativeLength;
            if(intialVel~=finalVel)
                accelVal=(finalVel*finalVel-intialVel*intialVel)/...
                (2*distDiff);
                vel=sqrt(intialVel*intialVel+2*accelVal*distTravelled);
            else
                accelVal=0;
                vel=intialVel;
            end
            obj.Accel=accelVal;
            obj.Speed=vel;
            obj.ScaledSpeed=obj.Scale*obj.ScaledSpeed;
            if(obj.ScaleCumulative==0)
                obj.ScaleCumulative=obj.Scale;
            else
                obj.ScaleCumulative=obj.ScaleCumulative*obj.Scale;
            end
            obj.LastSpeed=obj.ScaledSpeed;
            obj.ScaledSpeed=max(obj.ScaledSpeed,0.01);
            obj.ScaledSpeed=min(obj.ScaledSpeed,1.7*obj.Speed);
            if(obj.ScaledSpeed<=0.03)
                obj.Counter=obj.Counter+1;
            else
                obj.Counter=0;
            end
        end
        function obj=accumulateTime(obj,time)


            delta=time-obj.TimeStamp;
            obj.TimeStamp=time;
            if(obj.OverrideSpeed==1)
                distDelta=obj.ScaledSpeed*delta;
            else
                distDelta=obj.Speed*delta;
            end
            pathSize=size(obj.Path.SampledWaypoints,1);
            totalDistTravelled=obj.CumulativeLength+distDelta;
            obj.CumulativeLength=totalDistTravelled;


            selectedIdx=obj.Path.Index;
            if(totalDistTravelled>=obj.Path.PathLen(end))
                obj.State=false;
                position=obj.Path.SampledWaypoints(end,:);
                obj.LookAheadPath=struct('Left',[],'Right',[],'Center',[]);
                obj.LastPose=obj.Pose;
                obj.Pose.Position.X=position(1);
                obj.Pose.Position.Y=position(2);
                obj.Pose.Orientation.Yaw=obj.Path.Yaw(end,:);
                obj.FutureYaw=obj.Path.Yaw(end,:);
                obj.Path.Index=pathSize;
                return;
            end
            for idx=obj.Path.Index:pathSize
                if(totalDistTravelled<obj.Path.PathLen(idx))
                    selectedIdx=idx-1;
                    break;
                end
            end
            yawIndx=selectedIdx;
            for idx=selectedIdx:pathSize
                if(totalDistTravelled+obj.FutureYawDist<obj.Path.PathLen(idx))
                    yawIndx=idx-1;
                    break;
                end
            end
            if(selectedIdx<=1)
                selectedIdx=1;
            elseif(selectedIdx>=pathSize)
                selectedIdx=pathSize-1;
            end
            if(totalDistTravelled+obj.FutureYawDist>obj.Path.PathLen(end))
                yawIndx=length(obj.Path.PathLen);
            end
            if(totalDistTravelled<=0)
                return;
            end
            distDiff=totalDistTravelled-obj.Path.PathLen(selectedIdx);
            startDist=obj.Path.PathLen(selectedIdx);
            startPoint=obj.Path.SampledWaypoints(selectedIdx,:);
            startYaw=obj.Path.Yaw(selectedIdx,:);
            endDist=obj.Path.PathLen(selectedIdx+1);
            endPoint=obj.Path.SampledWaypoints(selectedIdx+1,:);
            endYaw=obj.Path.Yaw(selectedIdx,:);
            prop=distDiff/(endDist-startDist);
            position=(1-prop)*startPoint+prop*endPoint;
            yaw=(1-prop)*startYaw+prop*endYaw;
            obj.FutureYaw=obj.Path.Yaw(yawIndx);
            obj.LastPose=obj.Pose;
            obj.Pose.Position.X=position(1);
            obj.Pose.Position.Y=position(2);
            obj.Pose.Orientation.Yaw=yaw;
            obj.Path.Index=selectedIdx;
        end
        function obj=updateLookAheadPolygon(obj,width)

            if(obj.State==false)
                return;
            end
            lookAheadDistance=obj.CumulativeLength+obj.LookAheadDist;
            lookAheadIdx=obj.Path.Index;
            pathSize=size(obj.Path.SampledWaypoints,1);
            for idx=obj.Path.Index:pathSize
                if(lookAheadDistance<obj.Path.PathLen(idx))
                    lookAheadIdx=idx-1;
                    break;
                end
            end
            if(lookAheadDistance>obj.Path.PathLen(end))
                lookAheadIdx=length(obj.Path.PathLen);
            end
            selectedIdx=obj.Path.Index;
            obj.LookAheadPath.Center=obj.Path.SampledWaypoints(selectedIdx:lookAheadIdx,:);
            if(selectedIdx<lookAheadIdx)
                obj.LookAheadPath.Left=mathUtils.shiftPoints(obj.LookAheadPath.Center,obj.LookAheadWidth*width,1);
                obj.LookAheadPath.Right=mathUtils.shiftPoints(obj.LookAheadPath.Center,obj.LookAheadWidth*width,-1);
            end
        end
        function move=queryFreeSpace(obj)

            if(obj.Path.Index<size(obj.Path.SampledWaypoints,1)&&obj.State)
                move=true;
            else
                move=false;
            end
        end
        function obj=reset(obj)

            obj=reset@cMotionModel(obj);
            obj.CumulativeLength=0;
            obj.Index=1;
            obj.Speed=obj.InitialSpeed;
            obj.State=true;
            obj.ScaledSpeed=obj.InitialSpeed;
            obj.Accel=0;
            obj.AngVelocity=0;
            obj.AngAccel=0;
        end
    end
end

