function [roadjson1,roadjson2] = trafficData2(rrProjPath, rrScenarioPath,workPath)

rrApp = roadrunner(rrProjPath, InstallationFolder=workPath);

% 打开现有方案
openScenario(rrApp, rrScenarioPath);

% 将场景加载到 RoadRunner 场景中后，通过使用 createSimulation函数创建模拟对象来自动执行模拟任务。模拟对象使您能够以编程方式与方案模拟进行交互。
% 创建模拟对象并设置最大模拟时间(s)
rrSim = createSimulation(rrApp);
maxSimulationTimeSec = 10;
set(rrSim, 'MaxSimulationTime', maxSimulationTimeSec);
% 加快场景模拟速度
set(rrSim, StepSize= 1);
set(rrSim,SimulationPace=20); 
% 开启模拟日志
set(rrSim, 'Logging', 'on');

% 开始模拟并等待模拟完成
set(rrSim, 'SimulationCommand', 'Start');
while strcmp(get(rrSim, 'SimulationStatus'), 'Running')
    pause(1);
end

% 获取模拟日志
rrLog = get(rrSim, 'SimulationLog');
%案例分析
% 包含四个演员。红色轿车已设置ID为 1，白色轿车已设置ID为 2。从模拟日志中获取这些参与者的记录速度。此外，从模拟日志中获取相应的模拟时间。
velocityAgent1 = get(rrLog,'Velocity','ActorID',1);
velocityAgent2 = get(rrLog,'Velocity','ActorID',2);
velocityAgent3 = get(rrLog,'Velocity','ActorID',3);
velocityAgent4 = get(rrLog,'Velocity','ActorID',4);

time = [velocityAgent1.Time];  %获取时间线


% 获取高清地图规范
hdMap = getMap(rrSim);
lanes = hdMap.map.lanes;

% 绘制车道和车辆位置
% figure;
% hold on;
for i = 1:numel(lanes)
    control_points = lanes(i).geometry.values;
    x_coordinates = arrayfun(@(cp) cp.x, control_points);
    y_coordinates = arrayfun(@(cp) cp.y, control_points);
    plot(x_coordinates, y_coordinates, 'black');
end


numActors = 28;
actorPositions = cell(1, numActors);

% 获取车辆初始速度
vels=zeros(1,numActors);
for actorID=1:numActors
    velocityAgent=get(rrLog,'Velocity','ActorID',actorID);
    vel=velocityAgent(1).Velocity;
    speed=norm(vel,2);
%     disp(speed);
    vels(actorID)=speed;
end

%设置统计时间范围
smin = 3.000000;
smax = 5.000000;

%获取车辆在某秒内的速度示例
% 获取特定时刻的速度数据
% 计算区域平均速度
avespeed=0;
for targetTime=smin:smax
vels = zeros(numActors, 1);
for actorID = 1:numActors
    velocityAgent = get(rrLog, 'Velocity', 'ActorID', actorID);
    
    % 寻找最接近目标时间的时间戳
    [~, idx] = min(abs([velocityAgent.Time] - targetTime));
    
    % 获取速度数据
    vel = velocityAgent(idx).Velocity;
    speed = norm(vel, 2);
    vels(actorID) = speed;
%     disp(['Actor ' num2str(actorID) ' velocity at ' num2str(targetTime) ' seconds: ' num2str(speed)]);
  if actorID==numActors
      avespeed=avespeed+mean(vels);
  end
end
end
avespeed=avespeed/(smax-smin+1);
%%计算区域拥堵指数:
%1、区域内车辆密度：numberAcors(暂时使用车辆数量)  2、区域内平均车速  3、区域内道路的容量：在一定时间内该区域最多容纳的车辆数量
%拥堵指数=（1-平均车速/最大车速）*(区域车辆密度/道路容量)
%假设该区域的道路容量为40
wayc=40;
for actorID = 1:numActors
    poseActor = rrLog.get('Pose', 'ActorID', actorID);
    position_x = arrayfun(@(x) x.Pose(1, 4), poseActor);
    position_y = arrayfun(@(x) x.Pose(2, 4), poseActor);
    actorPositions{actorID} = [position_x', position_y'];
end

for actorID = 1:numActors
    plot(actorPositions{actorID}(:, 1), actorPositions{actorID}(:, 2), 'LineWidth', 2);
end


% 统计路口车辆数量
%岳麓大道-望岳路口
xMin1 = -595.000;
xMax1 = -554.000;
yMin1 = 733;
yMax1 = 820;

%岳麓大道-谷风路口
xMin2 = -22;
xMax2 = 40;
yMin2 = 739;
yMax2 = 779;

%桐梓坡路-望岳路口
xMin3 = -813;
xMax3 = -563;
yMin3 = -246;
yMax3 = -157;

%桐梓坡路-谷风路口
xMin4 = -32;
xMax4 = 39;
yMin4 = -284;
yMax4 = -193;


vehiclesCountArray1 = zeros(1, smax - smin + 1);
vehiclesCountArray2 = zeros(1, smax - smin + 1);
vehiclesCountArray3 = zeros(1, smax - smin + 1);
vehiclesCountArray4 = zeros(1, smax - smin + 1);




% 写入时间戳和位置信息
for timestep = 1:numel(position_x)
    % 获取当前时间戳
    timestamp = time(timestep);
%     vels = zeros(1, numActors);
    for actorID = 1:numActors
     % 检查当前时间戳是否在指定的时间范围内
        if timestamp >= smin && timestamp <= smax
          % 统计各个路口的车辆数目,

           vehiclesInInterestArea1 = 0;
           vehiclesInInterestArea2 = 0;
           vehiclesInInterestArea3 = 0;
           vehiclesInInterestArea4 = 0;
          for actorID = 1:numActors
            %岳麓大道-望岳路口
            if actorPositions{actorID}(timestep, 1) >= xMin1 && actorPositions{actorID}(timestep, 1) <= xMax1 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin1 && actorPositions{actorID}(timestep, 2) <= yMax1
                vehiclesInInterestArea1 = vehiclesInInterestArea1 + 1;
                
            end

            %岳麓大道-谷风路口
            if actorPositions{actorID}(timestep, 1) >= xMin2 && actorPositions{actorID}(timestep, 1) <= xMax2 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin2 && actorPositions{actorID}(timestep, 2) <= yMax2
                vehiclesInInterestArea2 = vehiclesInInterestArea2 + 1;               
            end

            %桐梓坡路-望岳路口
            if actorPositions{actorID}(timestep, 1) >= xMin3 && actorPositions{actorID}(timestep, 1) <= xMax3 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin3 && actorPositions{actorID}(timestep, 2) <= yMax3
                vehiclesInInterestArea3 = vehiclesInInterestArea3 + 1;
            end

            %桐梓坡路-谷风路口
            if actorPositions{actorID}(timestep, 1) >= xMin4 && actorPositions{actorID}(timestep, 1) <= xMax4 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin4 && actorPositions{actorID}(timestep, 2) <= yMax4
                vehiclesInInterestArea4 = vehiclesInInterestArea4 + 1;
            end    
        end
       index = round(timestamp - smin + 1);
       vehiclesCountArray1(index) = vehiclesInInterestArea1;
       vehiclesCountArray2(index) = vehiclesInInterestArea2;
       vehiclesCountArray3(index) = vehiclesInInterestArea3;
       vehiclesCountArray4(index) = vehiclesInInterestArea4;

       end
       end
    end

% 计算第smin秒-第smax秒内的平均车流量（向下取整）
ave1 = ceil(sum(vehiclesCountArray1)/(smax-smin+1));
ave2 = ceil(sum(vehiclesCountArray2)/(smax-smin+1));
ave3 = ceil(sum(vehiclesCountArray3)/(smax-smin+1));
ave4 = ceil(sum(vehiclesCountArray4)/(smax-smin+1));

%拥堵指数
 Congestion=(numActors/wayc)*(1-avespeed/vels(1));

%得到路口区域中心点坐标
x1=round((xMin1+xMax1)/2,3);
y1=round((yMin1+yMax1)/2,3);
x2=round((xMin2+xMax2)/2,3);
y2=round((yMin2+yMax2)/2,3);
x3=round((xMin3+xMax3)/2,3);
y3=round((yMin3+yMax3)/2,3);
x4=round((xMin4+xMax4)/2,3);
y4=round((yMin4+yMax4)/2,3);
%将相对坐标转换成经纬度，根据GitHub上所提供的道路BD09百度坐标系转换的经纬度信息
% 暂时将roadrunner中点(0,0,0)的经纬度坐标(lat,lon)为(28.2546737,112.9005619)
%采取计算经纬度相对于原点变换的方式去获取
lat0 = 28.2546737; 
lon0 = 112.9005619; 
% 地球半径（单位：米）
earth_radius = 6378137;

% 转换
lat1 = lat0 + (y1 / earth_radius) * (180 / pi);
lon1 = lon0 + (x1 / (earth_radius * cosd(lat0))) * (180 / pi);
lat2 = lat0 + (y2 / earth_radius) * (180 / pi);
lon2 = lon0 + (x2 / (earth_radius * cosd(lat0))) * (180 / pi);
lat3 = lat0 + (y3 / earth_radius) * (180 / pi);
lon3 = lon0 + (x3 / (earth_radius * cosd(lat0))) * (180 / pi);
lat4 = lat0 + (y4 / earth_radius) * (180 / pi);
lon4 = lon0 + (x4 / (earth_radius * cosd(lat0))) * (180 / pi);
%返回数据
road1=struct();
road2=struct();
road3=struct();
road4=struct();

road1.name="岳麓大道-望岳路口";
road2.name="岳麓大道-谷风路口";
road3.name="桐梓坡路-望岳路口";
road4.name="桐梓坡路-谷风路口";

road1.Coordinate=struct('lat',lat1,'lon',lon1);
road2.Coordinate=struct('lat',lat2,'lon',lon2);
road3.Coordinate=struct('lat',lat3,'lon',lon3);
road4.Coordinate=struct('lat',lat4,'lon',lon4);

road1.datatype="路口车流量";
road2.datatype="路口车流量";
road3.datatype="路口车流量";
road4.datatype="路口车流量";

road1.volume=ave1;
road2.volume=ave2;
road3.volume=ave3;
road4.volume=ave4;

Road.id=2;
Road.vehiclenumber=numActors;
Road.avespeed=avespeed;
Road.Congestion= Congestion;
road={road1,road2,road3,road4};

road=jsonencode(road);
Road=jsonencode(Road);
% disp(Road);
% 停止与 RoadRunner 场景交互，并关闭应用程序
roadjson1=road;
roadjson2=Road;
close(rrApp);
close all;

end
