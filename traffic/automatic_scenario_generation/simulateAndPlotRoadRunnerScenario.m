function simulateAndPlotRoadRunnerScenario(rrProjPath, rrAppPath, scenarioFileName)
    % % 您可以使用roadrunner函数创建对象并启动 RoadRunner 方案会话。该函数需要一个参数来指定 RoadRunner 项目的位置。
    rrApp = roadrunner(rrProjPath, InstallationFolder=rrAppPath);
    
    % 通过使用函数并指定要打开的对象和特定方案，在 RoadRunner 方案中打开现有方案。
    openScenario(rrApp, scenarioFileName);
    
    % 将场景加载到 RoadRunner 场景中后，通过使用 createSimulation函数创建模拟对象来自动执行模拟任务。模拟对象使您能够以编程方式与方案模拟进行交互。
    rrSim = createSimulation(rrApp);
    
    % 将最大模拟时间设置为 20 秒。
    maxSimulationTimeSec = 20;
    set(rrSim, 'MaxSimulationTime', maxSimulationTimeSec);
%     启用仿真结果日志记录，以便以后可以绘制结果
    set(rrSim, 'Logging', 'on');
    
    % 开始模拟。使用while循环监视模拟的状态，并等待模拟完成。
    set(rrSim, 'SimulationCommand', 'Start');
    while strcmp(get(rrSim, 'SimulationStatus'), 'Running')
        pause(1);
    end


% 在本节中，您将从模拟中检索Actor的记录速度，并绘制其幅度与模拟时间的关系。
% 从方案中获取记录的结果。使用该函数并指定对象和 “scenario.getrrSimSimulationLog“ 作为输入参数。该函数返回中的模拟日志，其中包含有关 rrLog 的模拟信息。
rrLog = get(rrSim,"SimulationLog");


% 绘制 RoadRunner 场景中的车道并在地图上叠加车辆的位置。
% 使用该函数从RoadRunner获取高清地图规范。请注意，该函数返回一个结构，其中一个字段包含有关通道的信息
% 获取地图信息和车道规范
hdMap = getMap(rrSim);
lanes = hdMap.map.lanes;
% 获取场景中的所有参与者（车辆）信息
numActors = 6

vehiclesInInterestArea = 0; %统计路口车辆数量
stime=5.000000; %时间戳
%定义统计路口
xMin = -1385.020;
xMax = -1229.810;
yMin = -374.310;
yMax = -252.360;


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

axis equal
title("RoadRunner场景中的车辆位置")
ylabel("Y (米)")
xlabel("X (米)")
figure(gcf)


% 创建写文件对象
fid = fopen('positions.txt','w');

% 写入表头
fprintf(fid,'timestamp ');
for actorID = 1:numActors
    fprintf(fid,'Actor%d_x \t\t Actor%d_y ',actorID, actorID);   
end  
fprintf(fid,'\n');

% 写入时间戳和位置信息
for timestep = 1:numel(position_x) 
    
   % 获取当前时间戳
   timestamp = time(timestep);  
   
   fprintf(fid,'%f ', timestamp); 
    
   % 写入所有参与者的位置  
   for actorID = 1:numActors      
       fprintf(fid,'%f %f ',actorPositions{actorID}(timestep,1),...
                              actorPositions{actorID}(timestep,2));

          % 输出第五秒的车辆坐标信息
       if timestamp == stime
      
%          fprintf('车辆%d在第五秒的坐标：x=%f, y=%f\n', actorID, actorPositions{actorID}(timestep,1), actorPositions{actorID}(timestep,2));
         if actorPositions{actorID}(timestep,1)>=xMin && actorPositions{actorID}(timestep,1) <=xMax && ...
               actorPositions{actorID}(timestep,2)>=yMin && actorPositions{actorID}(timestep,2)<=yMax
               vehiclesInInterestArea=vehiclesInInterestArea+1
         end
       end
      
   

   end
   fprintf(fid,'\n'); % 新一行     
end

% 关闭文件     
fclose(fid);

fprintf("拥堵指数为%d\n",vehiclesInInterestArea)
% 停止与 RoadRunner 场景交互，请关闭模拟。然后关闭应用程序。
close(rrApp)

end
