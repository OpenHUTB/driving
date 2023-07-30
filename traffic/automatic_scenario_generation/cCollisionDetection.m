classdef cCollisionDetection
    properties(Access=public)
        % 用于存储与其他代理车辆发生碰撞的信息
        AgentsInCollision = struct('ID',[],'Position',[],'Speed',[],'Yaw',[],'Length',[],'Width',[],'Boundary',[]);
        
        % 用于存储与其他代理车辆后方碰撞的信息
        AgentsInBLCollision = struct('ID',[],'Position',[],'Speed',[],'Yaw',[],'Length',[],'Width',[],'Boundary',[]);
    end
    
    methods(Access=public)
        function obj=cCollisionDetection(varargin)
            % cCollisionDetection类的构造函数，暂不需要进行额外的初始化操作
        end
        
        function obj=checkInCollision(obj,vehicle,agentsInView)
            % 检查车辆是否与视野内的其他代理车辆发生碰撞的方法
            
            % 获取视野内其他代理车辆的信息
            agentsFOV = agentsInView;
            
            if(~isempty(agentsFOV.Position))
                % 当视野内有其他代理车辆时
                
                % 获取目标车辆与代理车辆的最小包围矩形的Minkowski Sum
                tgtActorsLength = agentsFOV.Length;
                minkowskiSum = obj.getMinkowskiSum(vehicle.Geometry.Length/2, tgtActorsLength/2);
                
                % 获取视野内其他代理车辆的位置和速度信息
                po = agentsFOV.Position;
                tgtVehicleSpeed = agentsFOV.Speed;
                vo = [tgtVehicleSpeed.*cos(agentsFOV.Yaw), tgtVehicleSpeed.*sin(agentsFOV.Yaw)];
                
                % 获取自车的位置和速度信息
                pe = [vehicle.Pose.Position.X, vehicle.Pose.Position.Y];
                speed = vehicle.MotionModel.ScaledSpeed;
                ve = [speed*cos(vehicle.Pose.Orientation.Yaw), speed*sin(vehicle.Pose.Orientation.Yaw)];
                
                if (speed <= 0.0001)
                    ve = [0, 0];
                end
                
                % 处理低速车辆，将其速度设置为零
                lowVelInd = find(agentsFOV.Speed <= 0.02);
                if (~isempty(lowVelInd))
                    for indx = 1:length(lowVelInd)
                        vo(lowVelInd(indx), :) = [0, 0];
                    end
                end
                
                % 检查碰撞锥体，并获取碰撞结果
                collisionValues = obj.checkWithCollisionCone(po, vo, pe, ve, minkowskiSum);
                
                % 将发生碰撞的代理车辆信息存入AgentsInCollision
                obj.AgentsInCollision.ID = agentsFOV.ID(collisionValues < 0, :);
                obj.AgentsInCollision.Position = agentsFOV.Position(collisionValues < 0, :);
                obj.AgentsInCollision.Speed = agentsFOV.Speed(collisionValues < 0);
                obj.AgentsInCollision.Yaw = agentsFOV.Yaw(collisionValues < 0);
                obj.AgentsInCollision.Length = agentsFOV.Length(collisionValues < 0);
                obj.AgentsInCollision.Width = agentsFOV.Width(collisionValues < 0);
            else
                % 视野内没有其他代理车辆，将结果置为空
                obj.AgentsInCollision.ID = [];
                obj.AgentsInCollision.Position = [];
                obj.AgentsInCollision.Speed = [];
                obj.AgentsInCollision.Yaw = [];
                obj.AgentsInCollision.Length = [];
                obj.AgentsInCollision.Width = [];
                
                obj.AgentsInBLCollision.ID = [];
                obj.AgentsInBLCollision.Position = [];
                obj.AgentsInBLCollision.Speed = [];
                obj.AgentsInBLCollision.Yaw = [];
                obj.AgentsInBLCollision.Length = [];
                obj.AgentsInBLCollision.Width = [];
            end
        end
    end
    
    methods(Access=public)
        function out=getMinkowskiSum(~,radius1,radius2)
            % 计算两个半径的Minkowski Sum的方法
            out=radius1+radius2;
        end
        
        function collisionConeValues=checkWithCollisionCone(~,po,vo,pe,ve,minkowskiSum)
            % 检查碰撞锥体的方法
            
            % 计算碰撞锥体相关的中间变量
            xNonEgo=po(:,1);
            yNonEgo=po(:,2);
            xNonEgoDot=vo(:,1);
            yNonEgoDot=vo(:,2);
            xEgo=pe(1);
            yEgo=pe(2);
            xEgoDot=ve(1);
            yEgoDot=ve(2);
            a = (-minkowskiSum.^2).*(xEgoDot.^2+yEgoDot.^2) + ((xEgo-xNonEgo).*yEgoDot + xEgoDot.*(-yEgo+yNonEgo)).^2;
            b = 2.*((-((xEgo-xNonEgo).*yEgoDot + xEgoDot.*(-yEgo+yNonEgo))).*(xNonEgoDot.*(-yEgo+yNonEgo) + (xEgo-xNonEgo).*yNonEgoDot) + minkowskiSum.^2.*(xEgoDot.*xNonEgoDot + yEgoDot.*yNonEgoDot));
            c = (xNonEgoDot.*(yEgo-yNonEgo) + (-xEgo+xNonEgo).*yNonEgoDot).^2 - minkowskiSum.^2.*(xNonEgoDot.^2 + yNonEgoDot.^2);
            collisionConeValues = a + b + c;
        end
    end
end
