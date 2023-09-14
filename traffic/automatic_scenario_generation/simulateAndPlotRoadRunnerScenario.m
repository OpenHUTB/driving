function [numActors,ave1,ave2,ave3,ave4] = simulateAndPlotRoadRunnerScenario(rrProjPath, rrScenarioPath,workPath)
    % 输入参数 rrProjPath: RoadRunner 项目的路径
    % 输入参数 rrScenarioPath: RoadRunner 场景的路径
    % 输入参数 workPath: RoadRunner软件的运行路径
    

    % 使用 roadrunner 函数创建对象并启动 RoadRunner 方案会话
    rrApp = roadrunner(rrProjPath, InstallationFolder=workPath);

    % 打开现有方案
    openScenario(rrApp, rrScenarioPath);

% 将场景加载到 RoadRunner 场景中后，通过使用 createSimulation函数创建模拟对象来自动执行模拟任务。模拟对象使您能够以编程方式与方案模拟进行交互。
% 创建模拟对象并设置最大模拟时间(s)
rrSim = createSimulation(rrApp);
maxSimulationTimeSec = 30;
set(rrSim, 'MaxSimulationTime', maxSimulationTimeSec);
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
time = [velocityAgent1.Time];
% 该函数将红色轿车和白色轿车的速度作为向量返回，并分别存储在 and 变量中。使用该函数计算每个参与者的速度大小
velMagAgent1 = arrayfun(@(x) norm(x.Velocity,2),velocityAgent1);
velMagAgent2 = arrayfun(@(x) norm(x.Velocity,2),velocityAgent2);
velMagAgent3 = arrayfun(@(x) norm(x.Velocity,2),velocityAgent3);
velMagAgent4 = arrayfun(@(x) norm(x.Velocity,2),velocityAgent4);
% 使用该函数绘制代理速度相对于模拟时间。
% figure
% hold on
% plot(time,velMagAgent1,"r")
% plot(time,velMagAgent2,"b")
% plot(time,velMagAgent1,"g")
% plot(time,velMagAgent2,"k")
% grid on
% title("Agent Velocities from RoadRunner Scenario")
% ylabel("Velocity (m/sec)")
% xlabel("Time (sec)")
% legend("Actor ID = 1","Actor ID = 2","Actor ID = 3","Actor ID = 4")


% 获取高清地图规范
hdMap = getMap(rrSim);
lanes = hdMap.map.lanes;


% 绘制车道和车辆位置
figure;
hold on;
for i = 1:numel(lanes)
    control_points = lanes(i).geometry.values;
    x_coordinates = arrayfun(@(cp) cp.x, control_points);
    y_coordinates = arrayfun(@(cp) cp.y, control_points);
    plot(x_coordinates, y_coordinates, 'black');
end


numActors = 22;
actorPositions = cell(1, numActors);


for actorID = 1:numActors
    poseActor = rrLog.get('Pose', 'ActorID', actorID);
    position_x = arrayfun(@(x) x.Pose(1, 4), poseActor);
    position_y = arrayfun(@(x) x.Pose(2, 4), poseActor);
    actorPositions{actorID} = [position_x', position_y'];
end

for actorID = 1:numActors
    plot(actorPositions{actorID}(:, 1), actorPositions{actorID}(:, 2), 'LineWidth', 2);
end

axis equal;
title('RoadRunner场景中的车辆位置');
ylabel('Y (米)');
xlabel('X (米)');
figure(gcf);

% 统计路口车辆数量

%桐梓坡路-谷风南路口
xMin1 = -50.140;
xMax1 = 39.390;
yMin1 = -281.501;
yMax1 = -199.520;

%桐梓坡路-金星中路路口
xMin2 = 465.640;
xMax2 = 541.370;
yMin2 = -307.555;
yMax2 = -226.760;

%谷风南路-咸嘉湖西路口
xMin3 = -39.100;
xMax3 = 37.783;
yMin3 = -824.270;
yMax3 = -730.620;

%金星中路-咸嘉湖西路口
xMin4 = 443.740;
xMax4 = 530.090;
yMin4 = -826.950;
yMax4 = -740.255;



%设置统计时间范围
smin = 5.000000;
smax = 10.000000;




% 创建写文件对象
fid = fopen('positions.txt', 'w');

% 写入表头
fprintf(fid, 'timestamp ');
for actorID = 1:numActors
    fprintf(fid, 'Actor%d_x \t\t Actor%d_y ', actorID, actorID);
end
fprintf(fid, '\n');

% 初始化车辆数目数组
vehiclesCountArray1 = zeros(1, smax - smin + 1);
vehiclesCountArray2 = zeros(1, smax - smin + 1);
vehiclesCountArray3 = zeros(1, smax - smin + 1);
vehiclesCountArray4 = zeros(1, smax - smin + 1);

% 写入时间戳和位置信息
for timestep = 1:numel(position_x)
    % 获取当前时间戳
    timestamp = time(timestep);
    fprintf(fid, '%f ', timestamp);
    
    % 写入所有参与者的位置
    for actorID = 1:numActors
        fprintf(fid, '%f %f ', actorPositions{actorID}(timestep, 1), actorPositions{actorID}(timestep, 2));

     % 检查当前时间戳是否在指定的时间范围内
        if timestamp >= smin && timestamp <= smax
          % 统计各个路口的车辆数目
           vehiclesInInterestArea1 = 0;
           vehiclesInInterestArea2 = 0;
           vehiclesInInterestArea3 = 0;
           vehiclesInInterestArea4 = 0;
          for actorID = 1:numActors
            %桐梓坡路-谷风南路口
            if actorPositions{actorID}(timestep, 1) >= xMin1 && actorPositions{actorID}(timestep, 1) <= xMax1 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin1 && actorPositions{actorID}(timestep, 2) <= yMax1
                vehiclesInInterestArea1 = vehiclesInInterestArea1 + 1;
            end

            %桐梓坡路-金星中路路口
            if actorPositions{actorID}(timestep, 1) >= xMin2 && actorPositions{actorID}(timestep, 1) <= xMax2 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin2 && actorPositions{actorID}(timestep, 2) <= yMax2
                vehiclesInInterestArea2 = vehiclesInInterestArea2 + 1;
            end

            %谷风南路-咸嘉湖西路口
            if actorPositions{actorID}(timestep, 1) >= xMin3 && actorPositions{actorID}(timestep, 1) <= xMax3 && ...
                    actorPositions{actorID}(timestep, 2) >= yMin3 && actorPositions{actorID}(timestep, 2) <= yMax3
                vehiclesInInterestArea3 = vehiclesInInterestArea3 + 1;
            end

            %金星中路-咸嘉湖西路口
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
    fprintf(fid, '\n'); % 新一行


% 关闭文件
fclose(fid);





% 输出车辆数目数组
% fprintf('车辆数目数组：%s\n', mat2str(vehiclesCountArray1));
% fprintf('车辆数目数组：%s\n', mat2str(vehiclesCountArray2));
% fprintf('车辆数目数组：%s\n', mat2str(vehiclesCountArray3));
% fprintf('车辆数目数组：%s\n', mat2str(vehiclesCountArray4));

% 计算第smin秒-第smax秒内的平均车流量（向下取整）
ave1 = ceil(sum(vehiclesCountArray1)/(smax-smin+1));
ave2 = ceil(sum(vehiclesCountArray2)/(smax-smin+1));
ave3 = ceil(sum(vehiclesCountArray3)/(smax-smin+1));
ave4 = ceil(sum(vehiclesCountArray4)/(smax-smin+1));

% fprintf('第%ds 到第%ds 中桐梓坡路-谷风南路车流量为%d\n', smin,smax,ave1);
% fprintf('第%ds 到第%ds 中桐梓坡路-金星中路车流量为%d\n', smin,smax,ave2);
% fprintf('第%ds 到第%ds 中谷风南路-咸嘉湖西路车流量为%d\n',smin,smax, ave3);
% fprintf('第%ds 到第%ds 中金星中路-咸嘉湖西路车流量为%d\n', smin,smax,ave4);

% 停止与 RoadRunner 场景交互，并关闭应用程序
close(rrApp);
close all;
    %返回场景总车辆数
    numActors=numActors;
    % 返回路口车流量
    ave1=ave1;
    ave2=ave2;
    ave3=ave3;
    ave4=ave4;
end
