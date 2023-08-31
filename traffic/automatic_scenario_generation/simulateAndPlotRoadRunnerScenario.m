function vehiclesInInterestArea = simulateAndPlotRoadRunnerScenario(rrProjPath, rrScenarioPath,workPath,stime)
    % 输入参数 rrProjPath: RoadRunner 项目的路径
    % 输入参数 rrScenarioPath: RoadRunner 场景的路径
    % 输入参数 workPath: RoadRunner软件的运行路径
    % 输入参数 stime: 统计某一时刻的拥堵指数（车辆数量）

    % 使用 roadrunner 函数创建对象并启动 RoadRunner 方案会话
    rrApp = roadrunner(rrProjPath, InstallationFolder=workPath);

    % 打开现有方案
    openScenario(rrApp, rrScenarioPath);

% 将场景加载到 RoadRunner 场景中后，通过使用 createSimulation函数创建模拟对象来自动执行模拟任务。模拟对象使您能够以编程方式与方案模拟进行交互。
rrSim = createSimulation(rrApp);


maxSimulationTimeSec = 10;% 将最大模拟时间设置为 10 秒。
set(rrSim,'MaxSimulationTime',maxSimulationTimeSec);


set(rrSim,"Logging","on");  % 启用仿真结果日志记录，以便以后可以绘制结果。

% 开始模拟。使用while循环监视模拟的状态，并等待模拟完成。
set(rrSim,"SimulationCommand","Start");
while strcmp(get(rrSim,"SimulationStatus"),"Running")
    pause(1);
end


% 在本节中，您将从模拟中检索Actor的记录速度，并绘制其幅度与模拟时间的关系。
% 从方案中获取记录的结果。使用该函数并指定对象和 “scenario.getrrSimSimulationLog“ 作为输入参数。该函数返回中的模拟日志，其中包含有关 rrLog 的模拟信息。
rrLog = get(rrSim,"SimulationLog");

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


% 绘制 RoadRunner 场景中的车道并在地图上叠加车辆的位置。
% 使用该函数从RoadRunner获取高清地图规范。请注意，该函数返回一个结构，其中一个字段包含有关通道的信息
% 获取地图信息和车道规范
hdMap = getMap(rrSim);
lanes = hdMap.map.lanes;
% 获取场景中的所有参与者（车辆）信息
numActors = 6;
% 绘制车道和车辆位置
figure
hold on
for i = 1:numel(lanes)
    control_points = lanes(i).geometry.values;
    x_coordinates = arrayfun(@(cp) cp.x, control_points);
    y_coordinates = arrayfun(@(cp) cp.y, control_points);
    plot(x_coordinates, y_coordinates, 'black');
end

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

% axis equal
% title("RoadRunner场景中的车辆位置")
% ylabel("Y (米)")
% xlabel("X (米)")
% figure(gcf)


% 统计路口车辆数量
xMin = -1385.020;
xMax = -1229.810;
yMin = -374.310;
yMax = -252.360;
vehiclesInInterestArea = 0;


% 创建写文件对象
fid = fopen('positions.csv', 'w');

% 写入表头
fprintf(fid, 'stamp ');
for actorID = 1:numActors
  fprintf(fid, ',Actor%d_x,Actor%d_y', actorID, actorID);
end
fprintf(fid, '\n');

% 写入时间戳和位置信息
for timestep = 1:numel(position_x)
    % 获取当前时间戳
    timestamp = time(timestep);
    fprintf(fid, '%f ', timestamp);

    % 写入所有参与者的位置
    for actorID = 1:numActors
        fprintf(fid, '%f %f ', actorPositions{actorID}(timestep, 1), actorPositions{actorID}(timestep, 2));

        % 输出第五秒的车辆坐标信息
        if timestamp == stime
            if actorPositions{actorID}(timestep, 1) >= xMin && actorPositions{actorID}(timestep, 1) <= xMax && ...
                    actorPositions{actorID}(timestep, 2) >= yMin && actorPositions{actorID}(timestep, 2) <= yMax
                vehiclesInInterestArea = vehiclesInInterestArea + 1;
            end
        end
    end
    fprintf(fid, '\n'); % 新一行
end

% 关闭文件
fclose(fid);

%fprintf('当前拥堵指数为%d\n', vehiclesInInterestArea);

% 停止与 RoadRunner 场景交互，请关闭模拟。然后关闭应用程序。
close(rrApp)
close all;
    % 返回拥堵指数
    vehiclesInInterestArea = vehiclesInInterestArea;
end
% 停止与 RoadRunner 场景交互，请关闭模拟。然后关闭应用程序。
close(rrApp)

end
