scenario = drivingScenario;
%将从roadrunner中导出的.xodr路网文件路径指定
filePath = 'C:\Users\86130\OneDrive\桌面\asam.xodr';  
roadNetwork(scenario,'OpenDRIVE',filePath);
plot(scenario)
xlim([-1000 1000])
ylim([-2500 -2000])
numPoints = 10;
setSeed = 2;
rng(setSeed);
s = rng;
[points,yaw] = helperSamplePositions(scenario,numPoints,"Seed",s);

%% 
% 指定场景中要放置的车辆数量为3。
% 在生成的集合中选择任意三个点作为车辆的起始位置。

numVehicles = 3;
startSet1 = [points(2,:);points(4,:);points(7,:)];  %每一行代表一个坐标点
yaw1 = [yaw(2);yaw(4);yaw(7)];
mesh = driving.scenario.carMesh;
%% 
% 使用该<https://ww2.mathworks.cn/help/driving/ref/drivingscenario.vehicle.html 
% |vehicle|>功能将车辆放置在选定的点。

for idx = 1 : numVehicles
    vehicle(scenario,Position=startSet1(idx,:),Yaw=yaw1(idx),ClassID=1,Mesh=mesh);
end

%% 
% 通过定义 ROI 生成另一组点。计算坐标以指定圆形 ROI，用于描述一个圆形感兴趣区域。
%此处直接通过道路坐标指定

xCor = -2380;
yCor = 244;
radius = 50;
theta = 0: pi/10: 2*pi;
roiCircular(:,1) = xCor+radius*cos(theta);
roiCircular(:,2) = yCor+radius*sin(theta);

%% 
% 指定要在 ROI 内生成的点数和要在 ROI 内放置的车辆数为 3。
% 选择圆形 ROI 内的所有点作为车辆的起始位置。

numPoints = 3;
[startSet2,yaw2] = helperSamplePositions(scenario,numPoints, 'ROI',roiCircular);
% 错误使用 drivingScenario/record
% No trajectory found.  To record a scenario, you must define the trajectory of at least one actor.


for idx = 1 : size(startSet2,1)
    vehicle(scenario,'Position',startSet2(idx,:),'Yaw',yaw2(idx),'ClassID',1);
end
%% 
% 指定矩形 ROI 的坐标。将要在 ROI 内生成的点数和要放置在 ROI 内的车辆数设置为 3。
% 将同一车道中两个连续点之间的纵向距离设置为 30 米。
% 如果% ROI 不足以容纳指定纵向距离处的指定点数，
% 则该|helperSamplePositions|函数仅返回 ROI 内可以容纳的点数。要
% 获得所需的点数，您必须减少纵向距离或增加 ROI 的面积。

roiRectangular = [-2411 496;-2394 573];
numPoints = 3;
[startSet3,yaw3] = helperSamplePositions(scenario,numPoints,ROI=roiRectangular,LongitudinalDistance=30);


%% 
% 使用该<https://ww2.mathworks.cn/help/driving/ref/drivingscenario.vehicle.html 
% |vehicle|>功能将车辆放置在选定的点。

for idx = 1 : size(startSet3,1)
    vehicle(scenario,Position=startSet3(idx,:),Yaw=yaw3(idx),ClassID=1,Mesh=mesh);
end
%% 
% 绘制生成的样本点和 ROI。

figScene = figure(Name="AutomaticScenarioGeneration");
set(figScene,Position=[0,0,900,500]);

hPanel1 = uipanel(figScene,Position=[0 0 0.5 1]);
hPlot1 = axes(hPanel1);
plot(scenario,Parent=hPlot1,Meshes="on");
title("Points for Selecting Start Positions")
hold on
plot(points(:,1),points(:,2),"ro",MarkerSize=5,MarkerFaceColor="r");

plot(roiCircular(:,1),roiCircular(:,2),LineWidth=1.2,Color="k");
plot(startSet2(:,1),startSet2(:,2),"ko",MarkerSize=5,MarkerFaceColor="k");

plot([roiRectangular(1,1);roiRectangular(1,1);roiRectangular(2,1);roiRectangular(2,1);roiRectangular(1,1)], ...
     [roiRectangular(1,2);roiRectangular(2,2);roiRectangular(2,2);roiRectangular(1,2);roiRectangular(1,2)], ...
     LineWidth=1.2,Color="b");
plot(startSet3(:,1),startSet3(:,2),"bo",MarkerSize=5,MarkerFaceColor="b");
xlim([-50 190])
ylim([-85 330])
hold off

%% 
% 显示场景中的起始位置和车辆。
%% 
% * 红色的 3 个起始位置是从场景中定义的 10 个随机点中选择的。
% * 黑色的 3 个起始位置是从圆形 ROI 中定义的 3 个随机点中选择的。
% * 蓝色的 3 个起始位置是从矩形 ROI 中定义的 3 个随机点中选择的。

hPanel2 = uipanel(figScene,Position=[0.5 0 0.5 1]);
hPlot2 = axes(hPanel2);
plot(scenario,Parent=hPlot2,Meshes="on");
title("Start Positions and Vehicle Placement")
hold on
plot(startSet1(:,1),startSet1(:,2),"rs",MarkerSize=15,LineWidth=1.2);
plot(startSet2(:,1),startSet2(:,2),"ks",MarkerSize=15,LineWidth=1.2);
plot(startSet3(:,1),startSet3(:,2),"bs",MarkerSize=15,LineWidth=1.2);
xlim([-50 190])
ylim([-85 330])
hold off

%% 
% 将所有起始位置合并到一个矩阵中。
% 起始位置的数量意味着驾驶场景中的车辆总数。

startPositions = [startSet1;startSet2;startSet3];
% *2.检查场景对象*
% 显示场景对象并检查其属性。|Actors|该对象的属性是|scenario|一个 1×9 数组，
% 用于存储有关添加到驾驶场景的 9 辆车的信息。
% 使用点索引访问属性中每辆车的详细信息|Actors|。
% 显示驾驶场景中第一辆车的详细信息。该|Position|属性包含车辆的起始位置。

scenario
scenario.Actors(1)
% *3.选择目标位置*
% 使用函数生成场景中车辆的目标位置|helperSamplePositions|。
% 目标位置的总数必须与起始位置的总数相同。

numGoalPositions = length(startPositions)
%% 
% 指定多边形 ROI 的坐标，并在多边形 ROI 内找到 5 个随机点。
% 选择这些点作为场景中前 5 辆车的目标位置。
%roiPolygon = [-50  170;30  250;72 170;-50 170];
roiPolygon = [-2421  787;-2447  784;-2401  630;-2425  605];
numPoints1 = 9;
goalSet1 = helperSamplePositions(scenario,numPoints1,ROI=roiPolygon);


%% 
% 生成剩余的一组目标位置，使它们都位于特定的车道上。
% 使用“ |Lanes|”名称-值对组参数指定目标位置的车道编号。

%numPoints2 = 4;
%goalSet2 = helperSamplePositions(scenario,numPoints2,'lanes',1);
%goalSet2 = [108.1520  -34.7885   -0.0005
 % 118.4150  192.4992    0.0005
  %110.0865  248.1703   -0.0003
  %177.2049  267.6814   -0.0016];
%% 
% 显示场景和选定的目标位置。
%% 
% * 红色的 5 个点显示多边形 ROI 中定义的目标位置。
% * 蓝色的 4 个点显示了在整个场景中定义的目标位置。

figure
plot(scenario,Meshes="on"); 
title("Goal Positions")
hold on
plot(roiPolygon(:,1), roiPolygon(:,2), LineWidth=1.2, Color="r")
plot(goalSet1(:,1), goalSet1(:,2), "ro", MarkerSize=5, MarkerFaceColor="r")
%plot(goalSet2(:,1), goalSet2(:,2), "bo", MarkerSize=5, MarkerFaceColor="b")
xlim([-50 190])
ylim([-85 310])
hold off
%% 
% 将所有目标位置合并到一个矩阵中。

%goalPositions = [goalSet1;goalSet2];
%% 
% 显示场景中每辆车的起始位置和目标位置。

vehicleNum = 1:length(startPositions);
table(vehicleNum(:),startPositions,goalSet1,VariableNames={'Vehicle','Start positions','Goal positions'})
%% *生成车辆轨迹*
% 使用该|helperGenerateWaypoints|函数计算连接起始位置和目标位置的路点。
% 该函数返回一个结构数组，其中包含场景中每辆车的道路中心、计算的路点和偏航角。
% 从对象中读取车辆信息|scenario|并为每辆车指定随机速度值。
% 使用该<https://ww2.mathworks.cn/help/driving/ref/drivingscenario.trajectory.html 
% |trajectory|>函数通过使用计算出的路点和随机速度值为每辆车生成轨迹。

info = helperGenerateWaypoints(scenario,startPositions,goalSet1);
for indx = 1:length(startPositions)
    vehicleData = scenario.Actors(indx);
    speed = randi([5,10],1,1);
    waypts = info(indx).waypoints;
    trajectory(vehicleData,waypts,speed);
end


%% 
% 设置场景的停止时间。

% 设置场景的停止时间为10秒
scenario.StopTime = 100;

% 创建自定义图形并显示模拟驾驶场景
close all;
figScene = figure;
set(figScene, 'Position', [0, 0, 600, 600]);
movegui(figScene, 'center');
hPanel = uipanel(figScene, 'Position', [0 0 1 1]);
hPlot = axes(hPanel);
plot(scenario, 'Parent', hPlot, 'Meshes', 'on');
title('Generated Scenario')

% 创建一个空数组用于存储车辆位置数据
numActors = length(scenario.Actors);
vehiclePositions = [];

% 模拟场景并记录车辆位置数据
timeStep = 0.5;
currentTime = 0;

% 定义车辆的速度，假设所有车辆的速度都是恒定的
vehicleVelocities = randi([5, 15], 1, numActors);  % 随机生成车辆速度，单位：m/s

reachedGoal = false(1, numActors);

while currentTime <= scenario.StopTime
    % 获取当前时间步的车辆位置信息
    positions = zeros(1, 2 * numActors + 1);
    positions(1) = currentTime;
    for actorIdx = 1:numActors
        actor = scenario.Actors(actorIdx);
        actorPos = actor.Position(1:2);  % 确保actorPos的维度是(1, 2)
        positions(2 * actorIdx : 2 * actorIdx + 1) = actorPos;
        
        % 如果车辆已经到达目标位置，则不再更新位置
        if reachedGoal(actorIdx)
            continue;
        end
        
        % 计算车辆到目标位置的距离
        targetPos = goalSet1(actorIdx, 1:2);  % 确保targetPos的维度是(1, 2)
        distanceToTarget = norm(actorPos - targetPos);  % 计算距离
        
        if distanceToTarget <= timeStep * vehicleVelocities(actorIdx)  % 判断条件改为距离小于等于一个时间步长内的位移
            % 车辆到达目标位置后停止移动，并将位置固定在目标位置上
            vehicleVelocities(actorIdx) = 0;
            actor.Position(1:2) = targetPos;
            reachedGoal(actorIdx) = true;  % 标记该车辆已到达目标位置
        else
            % 更新车辆位置
            % 使用速度和时间步长计算车辆新位置
            direction = (targetPos - actorPos) / distanceToTarget;  % 计算目标方向
            displacement = vehicleVelocities(actorIdx) * timeStep * direction;  % 车辆位移 = 速度 * 时间步长 * 方向
            actor.Position(1:2) = actor.Position(1:2) + displacement;
        end
    end
    
    % 将当前时间步的车辆位置信息添加到数组中
    vehiclePositions = [vehiclePositions; positions];
    
    % 更新当前时间
    currentTime = currentTime + timeStep;
    
    % 显示当前时间步的模拟结果
    drawnow;
    pause(0.01); % 添加小的延时，使得动画能够更好地显示
end

% 将车辆位置数据写入文档
outputFilePath = 'vehicle_positions.txt';
fileID = fopen(outputFilePath, 'w');
fprintf(fileID, '时间\t');
for actorIdx = 1:numActors
    fprintf(fileID, '车辆%d_x\t车辆%d_y\t', actorIdx, actorIdx);
end
fprintf(fileID, '\n');

for idx = 1:size(vehiclePositions, 1)
    fprintf(fileID, '%.3f\t', vehiclePositions(idx, 1));
    fprintf(fileID, '%.3f\t%.3f\t', vehiclePositions(idx, 2:end));
    fprintf(fileID, '\n');
end
fclose(fileID);

disp('模拟已完成并将车辆位置数据写入文档。');
%%
% 在生成的场景中，所有车辆以特定速度沿着它们的轨迹移动以到达它们的目标位置。
% 您还可以观察两个演员在沿其轨迹移动时发生的碰撞。
% 在合成用于测试驾驶算法的场景时，重要的是场景中的车辆不会发生碰撞。
% 为防止碰撞，您必须调整车辆的速度，使它们在沿路径行驶时不会相互碰撞。
% *修改速度曲线以避免碰撞*
% 使用 MATLAB® System object™|CollisionFreeTrajectory|校正车辆的速度，
% 使它们在沿着轨迹行驶时不会发生碰撞。
% 该模型使用非线性时间缩放来反应性地加速或减速车辆而不改变其轨迹 
% [1]。

collisionFreeObj = helperCollisionFreeTrajectory(Scene=scenario);
out = cell(numel(0:0.025:50),1);
scenario.SampleTime = 0.025;
index = 1;
for time = 0:0.025:50
    out{index} = collisionFreeObj(time);
    index = index+1;
end
% *模拟和可视化生成的场景*
% 使用该|helpergetCFSMScenario|函数将输出转换|CollisionFreeTrajectory|为驾驶场景对象。
% 模拟并显示驾驶场景。您可以看到车辆沿着指定的轨迹行驶以到达其目标位置。

% 未识别类 'drivingScenario' 的方法、属性或字段 'Scene'。
% 出错 helperCreateCFSMScenario (第 12 行)
% ds.Scene = currScenario.Scene;
% 注释掉了currScenario.Scene 和 currScenario.RoadHistory 所在的代码行
newScenario = helperCreateCFSMScenario(out,scenario);

close all;
figScene = figure;
set(figScene,Position=[0,0,600,600]);
movegui(figScene,"center");
hPanel = uipanel(figScene,Position=[0 0 1 1]);
hPlot = axes(hPanel);
plot(newScenario,Parent=hPlot,Meshes="on");
title("Updated Scenario")
hold on
h1 = plot(goalSet1(:,1),goalSet1(:,2),"rs",MarkerSize=15,LineWidth=1.2);
h2 = plot(startPositions(:,1),startPositions(:,2),"gs",MarkerSize=15,LineWidth=1.2);
legend([h2 h1],{"Start Positions";"Goal Positions"},Location="southoutside",Orientation="horizontal")
hold off
while advance(newScenario)

end
