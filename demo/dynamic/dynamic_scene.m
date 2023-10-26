%% 在仿真期间删除参与者
% 此示例演示如何在仿真过程中删除参与者。将构建两名球形参与者选择其中一名进行摧毁。首先，创建一个世界场景并构建两个演员。然后，将演员添加到世界中，设置更新功能以删除所选演员，并在场景中设置视图。最后，可以在三维仿真查看器窗口中查看动画。
% 
% 可以使用 sim3d.World 对象在运行时修改参与者。
%% 创造世界
% 创建世界场景并使用更新函数与虚幻引擎建立通信。

% world = sim3d.World('ExecutablePath', "D:\project\WindowsNoEditor\AutoVrtlEnv.exe", ...
%     'Map', "/Game/Maps/HutbCity", ...
%     'Update' , @updateImpl);

world = sim3d.World('Map', "/Game/Maps/USCityBlock", ...
    'Update' , @updateImpl, ...
    'Output',@outputImpl);


%% 构建球和平面参与者
% 实例化两个名为 |Ball1| 和 |Ball2| 的参与者。使用 |createShape| 函数从球体构建参与者外观。向世界添加参与者。

% vehicle_1 = sim3d.vehicle.Vehicle();
% vehicle_1 = HutbVehicle(); % 'ActorName','vehicle1'
% vehicle_2 = self@sim3d.auto.WheeledVehicle();
% sedan_1 =  sim3d.ActorFactory.createWheeledVehicle('sim3d.auto.Tractor');

ball1 = sim3d.Actor('ActorName', 'Ball1');
ball1.createShape('sphere', [0.5 0.5 0.5]);
ball1.Color = [0 .149 .179];
ball1.Translation = [0, 0, 4.5];
ball2 = sim3d.Actor('ActorName', 'Ball2');
ball2.createShape('sphere', [0.5 0.5 0.5]);
ball2.Color = [.255 .510 .850];
ball2.Translation = [0, 0, 3];
world.add(ball1);
world.add(ball2);




%% 
% 实例化一个名为  |Plane1| 的参与者。使用 |createShape| 函数从平面构建参与者外观。向世界添加一个参与者。

plane = sim3d.Actor('ActorName', 'Plane1');
plane.createShape('plane', [5 5 0.1]);
world.add(plane);


%% 
% 将用户数据结构初始化为零。在更新函数中，将使用此结构从世界中删除参与者之前插入延迟。

world.UserData.Step = 0;

client = tcpclient("localhost",30000);
world.UserData.client = client;


%% 设置查看器窗口视角
% 如果不创建视口，则视点设置为 0, 0 ,0，并且可以使用方向键和指针在三维仿真查看器窗口中导航。
% 
% 对于本示例，使用 |createViewport| 函数创建一个带有单个字段 |Main| 的视口，其中包含一个 |sim3d.sensors.MainCamera| 
% 对象。

viewport = createViewport(world);


%% 运行动画
% 运行仿真集 10 秒，采样时间为 0.01 秒。

run(world, 0.01, 60)


%% 删除世界
% 删除世界对象。
delete(world);


%% *读取相机更新的函数*
% 使用更新函数在每个仿真步骤读取数据。|updateImpl| 函数从虚幻引擎中的 |MainCamera1| 读取图像数据并从场景中删除球体参与者。

function updateImpl(world)

world.UserData.Step = world.UserData.Step + 1;  % 每次仿真都会执行一次
actorFields = fields(world.Actors);
actorPresent = strcmp(actorFields, 'Ball1');
if any(actorPresent) && (world.UserData.Step == 500)  % 到仿真500步时就删除参与者
    actorIndex=(find(actorPresent));
    actorToDelete = actorFields{actorIndex};
    
    world.remove(actorToDelete);  % 删除参与者
end

end


function outputImpl(world)


data = read(world.UserData.client);
if ~isempty(data)
    actor = sim3d.ActorFactory.createVehicleUtil('auto', 'PassengerVehicle', 'MuscleCar');
    world.add(actor);
end
% clear client

% if world.UserData.Step == 600  % 到仿真500步时就加入一辆车
%     actor = sim3d.ActorFactory.createVehicleUtil('auto', 'PassengerVehicle', 'MuscleCar');
%     world.add(actor);
% end

end

%% 
%