classdef cCollisionDetection




    properties(Access=public)

        AgentsInCollision=struct('ID',[],'Position',[],'Speed',...
        [],'Yaw',[],'Length',[],...
        'Width',[],'Boundary',[]);

        AgentsInBLCollision=struct('ID',[],'Position',[],'Speed',...
        [],'Yaw',[],'Length',[],...
        'Width',[],'Boundary',[]);
    end
    methods(Access=public)
        function obj=cCollisionDetection(varargin)

        end
        function obj=checkInCollision(obj,vehicle,agentsInView)


            agentsFOV=agentsInView;
            if(~isempty(agentsFOV.Position))

                tgtActorsLength=agentsFOV.Length;
                minkowskiSum=obj.getMinkowskiSum(...
                vehicle.Geometry.Length/2,tgtActorsLength/2);

                po=agentsFOV.Position;


                tgtVehicleSpeed=agentsFOV.Speed;

                vo=[tgtVehicleSpeed.*cos(agentsFOV.Yaw)...
                ,tgtVehicleSpeed.*sin(agentsFOV.Yaw)];
                pe=[vehicle.Pose.Position.X,vehicle.Pose.Position.Y];
                speed=vehicle.MotionModel.ScaledSpeed;
                ve=[speed*cos(vehicle.Pose.Orientation.Yaw)...
                ,speed*sin(vehicle.Pose.Orientation.Yaw)];


                if(speed<=0.0001)
                    ve=[0,0];
                end
                lowVelInd=find(agentsFOV.Speed<=0.02);
                if(~isempty(lowVelInd))
                    for indx=1:length(lowVelInd)
                        vo(lowVelInd(indx),:)=[0,0];
                    end
                end


                collisionValues=obj.checkWithCollisionCone(po,vo,...
                pe,ve,minkowskiSum);

                obj.AgentsInCollision.ID=...
                agentsFOV.ID(collisionValues<0,:);
                obj.AgentsInCollision.Position=...
                agentsFOV.Position(collisionValues<0,:);
                obj.AgentsInCollision.Speed=...
                agentsFOV.Speed(collisionValues<0);
                obj.AgentsInCollision.Yaw=...
                agentsFOV.Yaw(collisionValues<0);
                obj.AgentsInCollision.Length=...
                agentsFOV.Length(collisionValues<0);
                obj.AgentsInCollision.Width=...
                agentsFOV.Width(collisionValues<0);
            else

                obj.AgentsInCollision.ID=[];
                obj.AgentsInCollision.Position=[];
                obj.AgentsInCollision.Speed=[];
                obj.AgentsInCollision.Yaw=[];
                obj.AgentsInCollision.Length=[];
                obj.AgentsInCollision.Width=[];

                obj.AgentsInBLCollision.ID=[];
                obj.AgentsInBLCollision.Position=[];
                obj.AgentsInBLCollision.Speed=[];
                obj.AgentsInBLCollision.Yaw=[];
                obj.AgentsInBLCollision.Length=[];
                obj.AgentsInBLCollision.Width=[];
            end
        end
    end
    methods(Access=public)
        function out=getMinkowskiSum(~,radius1,radius2)

            out=radius1+radius2;
        end
        function collisionConeValues=checkWithCollisionCone(~,po,vo,pe,ve,minkowskiSum)








            xNonEgo=po(:,1);
            yNonEgo=po(:,2);
            xNonEgoDot=vo(:,1);
            yNonEgoDot=vo(:,2);
            xEgo=pe(1);
            yEgo=pe(2);
            xEgoDot=ve(1);
            yEgoDot=ve(2);
            a=(-minkowskiSum.^2).*(xEgoDot.^2+yEgoDot.^2)+...
            ((xEgo-xNonEgo).*yEgoDot+xEgoDot.*(-yEgo+yNonEgo)).^2;
            b=2.*((-((xEgo-xNonEgo).*yEgoDot+...
            xEgoDot.*(-yEgo+yNonEgo))).*(xNonEgoDot.*(-yEgo+yNonEgo)...
            +(xEgo-xNonEgo).*yNonEgoDot)+...
            minkowskiSum.^2.*(xEgoDot.*xNonEgoDot+yEgoDot.*yNonEgoDot));
            c=(xNonEgoDot.*(yEgo-yNonEgo)+...
            (-xEgo+xNonEgo).*yNonEgoDot).^2-...
            minkowskiSum.^2.*(xNonEgoDot.^2+yNonEgoDot.^2);
            collisionConeValues=a+b+c;
        end
    end
end