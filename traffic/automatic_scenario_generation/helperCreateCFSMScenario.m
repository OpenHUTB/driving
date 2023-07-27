function ds = helperCreateCFSMScenario(out, currScenario)
% 辅助函数：helperCreateCFSMScenario，将有碰撞风险的 drivingScenario 转换为无碰撞风险的 drivingScenario

% 创建一个 vehicles 结构体数组,用createVehicleStruct函数从out中提取车辆的位置和速度信息
vehicles = createVehicleStruct(out);
%创建一个drivingScenario对象
ds = drivingScenario;
%将当前场景仿真的时间步长、停止时间设置给ds对象
ds.SampleTime = currScenario.SampleTime;
ds.StopTime = currScenario.StopTime;
ds.VerticalAxis = 'Y'; %使用Y轴作为垂直坐标轴
% ds.Scene = currScenario.Scene;
% ds.RoadHistory = currScenario.RoadHistory;
for i = 1 : numel(vehicles)
    %从场景中获取第i个车辆的信息
    oldActor = currScenario.Actors(i);
    %获取第i辆车的位置信息
    waypoints = vehicles(i).Position;
    %获取waypoints的行数
    n = size(waypoints,1);

    % 计算偏向角
    course = NaN(n,1);
    course = matlabshared.tracking.internal.scenario.clothoidG2fitMissingCourse(waypoints,course);

    % 获取每个路段的起始曲率、终止曲率和长度。
    hip = complex(waypoints(:,1), waypoints(:,2));
    [~, ~, hl] = matlabshared.tracking.internal.scenario.clothoidG1fit2(hip(1:n-1),course(1:n-1),hip(2:n),course(2:n));

    % 获取车辆从初始点到相应路段结束时累计的水平距离
    hcd = [0; cumsum(hl)];

    % 获取第i辆车的速度信息
    Velocity = vehicles(i).Speed';

    % 寻找因为车辆停止而导致重复出现的位置
    [~,idx] = unique(hcd,'rows','stable');

    % 从车辆轨迹中移除这些重复出现的路点和速度，并添加等待时间（waitTime）。
    waypoints = waypoints(idx,:); %根据idx，将waypoints重复的路保留，其他移除
    Velocity = Velocity(idx);     %根据idx，将waypoints重复索引位置的速度保留，其他移除
    d = diff(idx);   %保存重复位置之间的索引间隔
    waitTime = [ds.SampleTime*(d-ones(size(d)));0]; 
  %创建一个新的车辆（newActor）对象，并设置其初始属性使得与之前车辆对象保持一致。
    newActor =  vehicle(ds, 'Position', waypoints(1,:), 'Length', ...
        oldActor.Length, 'ClassID', oldActor.ClassID,...
        'Width', oldActor.Width, 'Height', oldActor.Height, ...
        'Mesh', driving.scenario.carMesh);

    %使得新车辆按照之前的路点、速度和等待时间在驾驶场景中运动
    trajectory(newActor, waypoints, Velocity, waitTime);
end
end

function vehicles = createVehicleStruct(out)
% createVehicleStruct函数将车辆信息从不同数据结构转换为结构体数组
numActors =  numel(out{1});  % 获取车辆的数量
% 对于每个车辆，将其在不同时间步骤的位置和速度信息存储在Position和Speed数组中
for i = 1 : numActors
    Position = [];
    Speed = [];
    % 遍历每个时间步骤，提取第i个车辆的位置和速度信息
    for j = 1:numel(out)
        Position = [Position;out{j}(i).Position];
        Speed = [Speed;out{j}(i).Speed];
    end
    % 将第i个车辆的位置和速度信息存储在vehicles结构体数组中
    vehicles(i).Position = Position; %#ok<*AGROW>
    vehicles(i).Speed = Speed;
end
end

