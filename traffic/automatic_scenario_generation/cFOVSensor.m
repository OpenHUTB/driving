classdef cFOVSensor




    properties(Access=public,Hidden=true)

        ID;

        AgentsInFOV=struct('ID',[],'Position',[],'Speed',[],...
        'Yaw',[],'Length',[],'Width',[],...
        'Boundary',[]);
        AgentsInNghbrhd=struct('ID',[],'Position',[],'Speed',[],...
        'Yaw',[],'Length',[],'Width',[],...
        'Boundary',[]);

        FOV=[];

        FOVNeigh=[];

        FOVDist=40;
        FOVNeighbourDist=15;

        FOVAngle=20*pi/180;
    end
    methods(Access=public,Hidden=true)
        function obj=cFOVSensor(ID,pose)

            yaw=pose.Orientation.Yaw;
            sensorSweep=yaw-obj.FOVAngle...
            :obj.FOVAngle/5:...
            yaw+obj.FOVAngle;

            position=[pose.Position.X,pose.Position.Y];
            polyX=position(1)+obj.FOVDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVDist*sin(sensorSweep);


            obj.FOV=[position;[polyX',polyY'];position];


            polyX=position(1)+obj.FOVNeighbourDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVNeighbourDist*sin(sensorSweep);

            obj.FOVNeigh=[position;[polyX',polyY'];position];
            obj.ID=ID;
        end

        function obstacles=getObstaclesInFOV(~)

            obstacles=1;
        end

        function agents=getVehiclesInFOV(obj)
            agents=obj.AgentsInFOV;
        end

        function agents=getVehiclesInNeighbourhood(obj)
            agents=obj.AgentsInNghbrhd;
        end

        function obj=updateFOVPolygon(obj,pose,futureYaw)
            yaw=futureYaw;
            sensorSweep=yaw-obj.FOVAngle...
            :obj.FOVAngle/5:...
            yaw+obj.FOVAngle;


            position=[pose.Position.X,pose.Position.Y];

            polyX=position(1)+obj.FOVDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVDist*sin(sensorSweep);


            obj.FOV=[position;[polyX',polyY'];position];


            polyX=position(1)+obj.FOVNeighbourDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVNeighbourDist*sin(sensorSweep);

            obj.FOVNeigh=[position;[polyX',polyY'];position];
        end

        function obj=assignDetectedActors(obj,detectedActors,actor)


            pose=actor.MotionModel.Pose;
            position=[pose.Position.X,pose.Position.Y];
            yaw=pose.Orientation.Yaw;
            ptsToCheck=zeros(3*length(detectedActors),2);
            for idx=1:3:3*length(detectedActors)
                i=((idx-1)/3)+1;
                ptsToCheck(idx,:)=detectedActors(i).Boundary(1,:);
                ptsToCheck(idx+1,:)=detectedActors(i).Boundary(2,:);
                ptsToCheck(idx+2,:)=detectedActors(i).Boundary(3,:);
            end

            actorFOVIdx=inpolygon(ptsToCheck(:,1),ptsToCheck(:,2),...
            obj.FOV(:,1),obj.FOV(:,2));
            detectedActorsProc=detectedActors;
            count=0;
            for idx=1:3:3*length(detectedActors)
                index=((idx-1)/3)+1;
                positionActor=detectedActors(index).Position;
                diff=positionActor-position;
                yawTgt=atan2(diff(2),diff(1));
                yawDiff1=yaw-yawTgt;
                yawDiff2=(yaw+2*pi)-yawTgt;
                yawDiff3=(yaw-2*pi)-yawTgt;
                yawTgtAligned=abs(yawDiff1)<obj.FOVAngle||...
                abs(yawDiff2)<obj.FOVAngle||...
                abs(yawDiff3)<obj.FOVAngle;
                if((actorFOVIdx(idx)==1||actorFOVIdx(idx+1)==1||...
                    actorFOVIdx(idx+2)==1)&&...
                    detectedActors(index).ID~=obj.ID&&yawTgtAligned)
                    count=count+1;
                    detectedActorsProc(count)=detectedActors(index);
                end
            end
            detectedActorsProc=detectedActorsProc(1:count);

            if(~isempty(detectedActorsProc))
                obj.AgentsInFOV.ID=zeros(count,1);
                obj.AgentsInFOV.Position=zeros(count,2);
                obj.AgentsInFOV.Speed=zeros(count,1);
                obj.AgentsInFOV.PrevSpeed=zeros(count,1);
                obj.AgentsInFOV.Yaw=zeros(count,1);
                obj.AgentsInFOV.Length=zeros(count,1);
                obj.AgentsInFOV.Width=zeros(count,1);
                obj.AgentsInFOV.Boundary=zeros(3*count,2);
                for indx=1:count
                    obj.AgentsInFOV.ID(indx)=...
                    detectedActorsProc(indx).ID;
                    obj.AgentsInFOV.Position(indx,:)=...
                    detectedActorsProc(indx).Position;
                    obj.AgentsInFOV.Speed(indx)=...
                    detectedActorsProc(indx).Speed;
                    if(detectedActorsProc(indx).ID<actor.ID)
                        obj.AgentsInFOV.Speed(indx)=...
                        detectedActorsProc(indx).PrevSpeed;
                    end
                    obj.AgentsInFOV.Yaw(indx)=...
                    detectedActorsProc(indx).Yaw;
                    obj.AgentsInFOV.Length(indx)=...
                    detectedActorsProc(indx).Length;
                    obj.AgentsInFOV.Width(indx)=...
                    detectedActorsProc(indx).Width;
                    obj.AgentsInFOV.Boundary(indx,:)=...
                    detectedActorsProc(indx).Boundary(1,:);
                    obj.AgentsInFOV.Boundary(indx+1,:)=...
                    detectedActorsProc(indx).Boundary(2,:);
                    obj.AgentsInFOV.Boundary(indx+2,:)=...
                    detectedActorsProc(indx).Boundary(3,:);
                end
            else
                obj.AgentsInFOV.ID=[];
                obj.AgentsInFOV.Position=[];
                obj.AgentsInFOV.Speed=[];
                obj.AgentsInFOV.Yaw=[];
                obj.AgentsInFOV.Length=[];
                obj.AgentsInFOV.Width=[];
                obj.AgentsInFOV.Boundary=[];
            end
            if(~isempty(actor.MotionModel.LookAheadPath.Left))
                leftSidePath=actor.MotionModel.LookAheadPath.Left;
                rightSidePath=actor.MotionModel.LookAheadPath.Right;
                polygon=[leftSidePath;rightSidePath(end:-1:1,:)];
                checkTry=inpolygon(ptsToCheck(:,1),...
                ptsToCheck(:,2),polygon(:,1),polygon(:,2));
            else
                checkTry=inpolygon(ptsToCheck(:,1),...
                ptsToCheck(:,2),obj.FOVNeigh(:,1),obj.FOVNeigh(:,2));

            end



            detectedActorsProc=detectedActors;
            count=0;
            for idx=1:3:3*length(detectedActors)
                index=((idx-1)/3)+1;
                positionActor=detectedActors(index).Position;
                diff=positionActor-position;
                yawTgt=atan2(diff(2),diff(1));
                yawDiff1=yaw-yawTgt;
                yawDiff2=(yaw+2*pi)-yawTgt;
                yawDiff3=(yaw-2*pi)-yawTgt;
                yawTgtAligned=abs(yawDiff1)<obj.FOVAngle||...
                abs(yawDiff2)<obj.FOVAngle||...
                abs(yawDiff3)<obj.FOVAngle;












                if((checkTry(idx)==1||...
                    checkTry(idx+1)==1||...
                    checkTry(idx+2)==1)&&...
                    detectedActors(index).ID~=obj.ID&&yawTgtAligned)
                    count=count+1;
                    detectedActorsProc(count)=detectedActors(index);
                end
            end
            detectedActorsProc=detectedActorsProc(1:count);
            if(~isempty(detectedActorsProc))
                obj.AgentsInNghbrhd.ID=zeros(count,1);
                obj.AgentsInNghbrhd.Position=zeros(count,2);
                obj.AgentsInNghbrhd.Speed=zeros(count,1);
                obj.AgentsInNghbrhd.Yaw=zeros(count,1);
                obj.AgentsInNghbrhd.Length=zeros(count,1);
                obj.AgentsInNghbrhd.Width=zeros(count,1);
                obj.AgentsInNghbrhd.Boundary=zeros(3*count,2);
                counter=1;
                for indx=1:count
                    obj.AgentsInNghbrhd.ID(counter)=...
                    detectedActorsProc(indx).ID;
                    obj.AgentsInNghbrhd.Position(counter,:)=...
                    detectedActorsProc(indx).Position;
                    obj.AgentsInNghbrhd.Speed(counter)=...
                    detectedActorsProc(indx).Speed;
                    if(detectedActors(indx).ID<actor.ID)
                        obj.AgentsInFOV.Speed(indx)=...
                        detectedActorsProc(indx).PrevSpeed;
                    end
                    obj.AgentsInNghbrhd.Yaw(counter)=...
                    detectedActorsProc(indx).Yaw;
                    obj.AgentsInNghbrhd.Length(counter)=...
                    detectedActorsProc(indx).Length;
                    obj.AgentsInNghbrhd.Width(counter)=...
                    detectedActorsProc(indx).Width;
                    obj.AgentsInNghbrhd.Boundary(counter,:)=...
                    detectedActorsProc(indx).Boundary(1,:);
                    obj.AgentsInNghbrhd.Boundary(counter+1,:)=...
                    detectedActorsProc(indx).Boundary(2,:);
                    obj.AgentsInNghbrhd.Boundary(counter+2,:)=...
                    detectedActorsProc(indx).Boundary(3,:);
                    counter=counter+1;
                end
            else
                obj.AgentsInNghbrhd.ID=[];
                obj.AgentsInNghbrhd.Position=[];
                obj.AgentsInNghbrhd.Speed=[];
                obj.AgentsInNghbrhd.Yaw=[];
                obj.AgentsInNghbrhd.Length=[];
                obj.AgentsInNghbrhd.Width=[];
                obj.AgentsInNghbrhd.Boundary=[];
            end
        end
        function move=queryFreeSpace(obj)


            if(isempty(obj.AgentsInNghbrhd))
                move=true;
            else
                move=false;
            end
        end
    end
end