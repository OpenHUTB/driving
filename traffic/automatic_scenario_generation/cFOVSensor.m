classdef cFOVSensor
    properties(Access=public,Hidden=true)

        % 隐藏ID属性 
        ID;

        % 隐藏 AgentsInFOV 属性,用于存储视野范围内的agent信息
        AgentsInFOV=struct('ID',[],'Position',[],'Speed',[],...
        'Yaw',[],'Length',[],'Width',[],...
        'Boundary',[]);

        % 隐藏 AgentsInNghbrhd 属性,用于存储邻域范围内的agent信息
        AgentsInNghbrhd=struct('ID',[],'Position',[],'Speed',[],...
        'Yaw',[],'Length',[],'Width',[],...
        'Boundary',[]);

        % 隐藏FOV属性,用于存储视野范围多边形
        FOV=[];

        % 隐藏FOVNeigh属性,用于存储邻域范围多边形 
        FOVNeigh=[];

        % 隐藏FOVDist属性,视野距离
        FOVDist=40;
        % 隐藏FOVNeighbourDist属性,邻域距离
        FOVNeighbourDist=15;
        % 隐藏FOVAngle属性,视野角度 
        FOVAngle=20*pi/180;
    end
    methods(Access=public,Hidden=true)
        function obj=cFOVSensor(ID,pose)
            % 获取姿态角yaw
            yaw=pose.Orientation.Yaw;
            % 获取姿态角yaw
            sensorSweep=yaw-obj.FOVAngle...
            :obj.FOVAngle/5:...
            yaw+obj.FOVAngle;

            % 获取位置坐标
            position=[pose.Position.X,pose.Position.Y];
            % 计算FOV多边形顶点 
            polyX=position(1)+obj.FOVDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVDist*sin(sensorSweep);

            % 构建FOV多边形
            obj.FOV=[position;[polyX',polyY'];position];

            % 类似计算邻域FOV
            polyX=position(1)+obj.FOVNeighbourDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVNeighbourDist*sin(sensorSweep);

            obj.FOVNeigh=[position;[polyX',polyY'];position];
            % 设置ID 
            obj.ID=ID;
        end

        % 返回障碍物信息 
        function obstacles=getObstaclesInFOV(~)

            obstacles=1;
        end

        % 返回视野范围内的车辆信息
        function agents=getVehiclesInFOV(obj)
            agents=obj.AgentsInFOV;
        end

        % 返回邻域范围内的车辆信息
        function agents=getVehiclesInNeighbourhood(obj)
            agents=obj.AgentsInNghbrhd;
        end

        function obj=updateFOVPolygon(obj,pose,futureYaw)
            % 获取未来姿态角 
            yaw=futureYaw;
            % 生成扫描方位角数组
            sensorSweep=yaw-obj.FOVAngle...
            :obj.FOVAngle/5:...
            yaw+obj.FOVAngle;

            % 获取位置坐标
            position=[pose.Position.X,pose.Position.Y];

            % 计算FOV多边形顶点
            polyX=position(1)+obj.FOVDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVDist*sin(sensorSweep);

            % 更新FOV多边形
            obj.FOV=[position;[polyX',polyY'];position];

            % 同样更新邻域FOV多边形
            polyX=position(1)+obj.FOVNeighbourDist*cos(sensorSweep);
            polyY=position(2)+obj.FOVNeighbourDist*sin(sensorSweep);

            obj.FOVNeigh=[position;[polyX',polyY'];position];
        end

        function obj=assignDetectedActors(obj,detectedActors,actor)
            % 获取自身的actor的姿态数据
            pose=actor.MotionModel.Pose;
            % 提取位置坐标
            position=[pose.Position.X,pose.Position.Y];
            % 提取位置坐标           
            yaw=pose.Orientation.Yaw;
            % 初始化要检查的点
            ptsToCheck=zeros(3*length(detectedActors),2);
            % 将每个detected actors的三个顶点添加到ptsToCheck中
            for idx=1:3:3*length(detectedActors)
                % 计算当前actor的索引
                i=((idx-1)/3)+1;
                
                % 添加当前actor的3个顶点到ptsToCheck
                % 顶点坐标存储在Boundary属性中 
                ptsToCheck(idx,:)=detectedActors(i).Boundary(1,:);
                % 添加第二个顶点
                ptsToCheck(idx+1,:)=detectedActors(i).Boundary(2,:);
                % 添加第三个顶点
                ptsToCheck(idx+2,:)=detectedActors(i).Boundary(3,:);
            end

            % 使用多边形内测试判断点是否在FOV内
            actorFOVIdx=inpolygon(ptsToCheck(:,1),ptsToCheck(:,2),...
            obj.FOV(:,1),obj.FOV(:,2));
            % 初始化存储处理后的actors 
            detectedActorsProc=detectedActors;
            
            % 计数器
            count=0;
            % 循环每个actor的3个顶点
            for idx=1:3:3*length(detectedActors)
                % 计算当前actor索引
                index=((idx-1)/3)+1;
                % 获取当前actor的位置
                positionActor=detectedActors(index).Position;
                % 计算与自身的相对位置
                diff=positionActor-position;
                % 计算目标朝向角
                yawTgt=atan2(diff(2),diff(1));
                % 计算与自身朝向角的差值 
                yawDiff1=yaw-yawTgt;
                yawDiff2=(yaw+2*pi)-yawTgt;
                yawDiff3=(yaw-2*pi)-yawTgt;
                % 判断角度差是否在FOV内 
                yawTgtAligned=abs(yawDiff1)<obj.FOVAngle||...
                abs(yawDiff2)<obj.FOVAngle||...
                abs(yawDiff3)<obj.FOVAngle;
                % 如果顶点在FOV内且不是自身,计数加1 
                if((actorFOVIdx(idx)==1||actorFOVIdx(idx+1)==1||...
                    actorFOVIdx(idx+2)==1)&&...
                    detectedActors(index).ID~=obj.ID&&yawTgtAligned)
                    count=count+1;
                    detectedActorsProc(count)=detectedActors(index);
                end
            end
         
            % 裁剪结果数组
            detectedActorsProc=detectedActorsProc(1:count);

            % 如果有检测到的actors
            if(~isempty(detectedActorsProc))
                % 初始化AgentsInFOV属性中的数组
                obj.AgentsInFOV.ID=zeros(count,1);
                obj.AgentsInFOV.Position=zeros(count,2);
                obj.AgentsInFOV.Speed=zeros(count,1);
                obj.AgentsInFOV.PrevSpeed=zeros(count,1);
                obj.AgentsInFOV.Yaw=zeros(count,1);
                obj.AgentsInFOV.Length=zeros(count,1);
                obj.AgentsInFOV.Width=zeros(count,1);
                obj.AgentsInFOV.Boundary=zeros(3*count,2);
                % 填充数据
                for indx=1:count
                    obj.AgentsInFOV.ID(indx)=...
                    detectedActorsProc(indx).ID;
                    obj.AgentsInFOV.Position(indx,:)=...
                    detectedActorsProc(indx).Position;
                    obj.AgentsInFOV.Speed(indx)=...
                    detectedActorsProc(indx).Speed;
                    
                     % 如果ID更小,使用上一帧速度
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
                     
                    % 存储三个顶点  
                    obj.AgentsInFOV.Boundary(indx,:)=...
                    detectedActorsProc(indx).Boundary(1,:);
                    obj.AgentsInFOV.Boundary(indx+1,:)=...
                    detectedActorsProc(indx).Boundary(2,:);
                    obj.AgentsInFOV.Boundary(indx+2,:)=...
                    detectedActorsProc(indx).Boundary(3,:);
                end
            else
                % 存储三个顶点  
                obj.AgentsInFOV.ID=[];
                obj.AgentsInFOV.Position=[];
                obj.AgentsInFOV.Speed=[];
                obj.AgentsInFOV.Yaw=[];
                obj.AgentsInFOV.Length=[];
                obj.AgentsInFOV.Width=[];
                obj.AgentsInFOV.Boundary=[];
            end

            %如果有预测的行驶路径
            if(~isempty(actor.MotionModel.LookAheadPath.Left))
                % 获取左右路径线 
                leftSidePath=actor.MotionModel.LookAheadPath.Left;
                rightSidePath=actor.MotionModel.LookAheadPath.Right;
                % 获取左右路径线 
                polygon=[leftSidePath;rightSidePath(end:-1:1,:)];
                % 使用多边形内测试
                checkTry=inpolygon(ptsToCheck(:,1),...
                ptsToCheck(:,2),polygon(:,1),polygon(:,2));
            else
                % 否则使用默认的邻域FOV多边形
                checkTry=inpolygon(ptsToCheck(:,1),...
                ptsToCheck(:,2),obj.FOVNeigh(:,1),obj.FOVNeigh(:,2));

            end


            % 初始化结果数组
            detectedActorsProc=detectedActors;
            count=0;
            % 循环每个actor的3个顶点 
            for idx=1:3:3*length(detectedActors)
                % 计算当前actor的索引 
                index=((idx-1)/3)+1;
                % 获取当前actor的位置
                positionActor=detectedActors(index).Position;
                % 计算与自身的相对位置
                diff=positionActor-position;
                % 计算朝向角度
                yawTgt=atan2(diff(2),diff(1));
                % 计算与自身朝向差角
                yawDiff1=yaw-yawTgt;
                yawDiff2=(yaw+2*pi)-yawTgt;
                yawDiff3=(yaw-2*pi)-yawTgt;
                % 判断是否在FOV内
                yawTgtAligned=abs(yawDiff1)<obj.FOVAngle||...
                abs(yawDiff2)<obj.FOVAngle||...
                abs(yawDiff3)<obj.FOVAngle;
                % 如果顶点在邻域内且不是自身,计数加1
                if((checkTry(idx)==1||...
                    checkTry(idx+1)==1||...
                    checkTry(idx+2)==1)&&...
                    detectedActors(index).ID~=obj.ID&&yawTgtAligned)
                    count=count+1;
                    detectedActorsProc(count)=detectedActors(index);
                end
            end
            % 裁剪结果数组
            detectedActorsProc=detectedActorsProc(1:count);
            % 如果有检测到的actors
            if(~isempty(detectedActorsProc))
                % 初始化属性数组
                obj.AgentsInNghbrhd.ID=zeros(count,1);
                obj.AgentsInNghbrhd.Position=zeros(count,2);
                obj.AgentsInNghbrhd.Speed=zeros(count,1);
                obj.AgentsInNghbrhd.Yaw=zeros(count,1);
                obj.AgentsInNghbrhd.Length=zeros(count,1);
                obj.AgentsInNghbrhd.Width=zeros(count,1);
                obj.AgentsInNghbrhd.Boundary=zeros(3*count,2);
                % 结果计数器
                counter=1;
                % 填充数据
                for indx=1:count
                    obj.AgentsInNghbrhd.ID(counter)=...
                    detectedActorsProc(indx).ID;
                    obj.AgentsInNghbrhd.Position(counter,:)=...
                    detectedActorsProc(indx).Position;
                    obj.AgentsInNghbrhd.Speed(counter)=...
                    detectedActorsProc(indx).Speed;
                    % 使用上一帧速度
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
                    % 存储边界点
                    obj.AgentsInNghbrhd.Boundary(counter,:)=...
                    detectedActorsProc(indx).Boundary(1,:);
                    obj.AgentsInNghbrhd.Boundary(counter+1,:)=...
                    detectedActorsProc(indx).Boundary(2,:);
                    obj.AgentsInNghbrhd.Boundary(counter+2,:)=...
                    detectedActorsProc(indx).Boundary(3,:);
                    % 更新计数器
                    counter=counter+1;
                end
            else
                % 否则清空属性
                obj.AgentsInNghbrhd.ID=[];
                obj.AgentsInNghbrhd.Position=[];
                obj.AgentsInNghbrhd.Speed=[];
                obj.AgentsInNghbrhd.Yaw=[];
                obj.AgentsInNghbrhd.Length=[];
                obj.AgentsInNghbrhd.Width=[];
                obj.AgentsInNghbrhd.Boundary=[];
            end
        end
        % 查询邻域范围是否为空闲
        function move=queryFreeSpace(obj)
            % 如果邻域内没有其他agents
            if(isempty(obj.AgentsInNghbrhd))
                % 空间为空闲
                move=true;
            else
                % 否则空间被占用
                move=false;
            end
        end
    end
end
end
