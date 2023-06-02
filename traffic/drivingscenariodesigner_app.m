 
%% 从场景生成传感器数据
% 从预构建的 Euro NCAP 驾驶场景生成激光雷达点云数据。
% 有关应用程序提供的预建场景的更多详细信息，请参阅 Driving Scenario Designer 中的预建驾驶场景。
% 有关可用的 Euro NCAP 场景的更多详细信息，请参阅Driving Scenario Designer 中的 Euro NCAP Driving Scenarios。
% 加载与行人儿童发生碰撞的 Euro NCAP 自动紧急制动 (AEB) 场景。
% 在碰撞时，碰撞点发生在汽车宽度的 50% 处。

path = fullfile(matlabroot, 'toolbox' , 'shared' , 'drivingscenario' , ... 
    'PrebuiltScenarios' , 'EuroNCAP' );
addpath(genpath(path)) % 添加文件夹到路径
drivingScenarioDesigner( 'AEB_PedestrianChild_Nearside_50width.mat' )
rmpath(path) % 从路径中删除文件夹


% 将激光雷达传感器添加到自我车辆。
% 首先点击添加激光雷达(Lidar)。
% 然后，在传感器画布(Sensor Canvas)上，单击汽车车顶中心的预定义传感器位置。
% 激光雷达传感器在预定义位置显示为黑色，汽车周围的灰色是传感器的覆盖区域。

% 运行场景。通过在画布和视图之间切换来检查场景的不同方面。
% 您可以在传感器画布和场景画布之间以及鸟瞰图和自我中心视图之间切换。
% 在Bird's-Eye Plot和Ego-Centric View中，演员显示为网格而不是长方体。
% 要更改显示设置，请使用 应用工具条上的显示选项。

% 将传感器数据导出到 MATLAB 工作区。
% 点击Export > Export Sensor Data，输入工作区变量名称，然后点击 OK。


%% 导入程序化驾驶场景和传感器
% 以编程方式创建驾驶场景、雷达传感器和摄像头传感器。
% 然后将场景和传感器导入应用程序。
% 有关使用程序化驾驶场景和传感器的更多详细信息，请参阅以编程方式创建驾驶场景变体。

% 使用 drivingScenario 对象创建简单的驾驶场景。
scenario = drivingScenario;
% 在这种情况下，自我车辆以每秒 30 米的恒定速度在 50 米的路段上直线行驶。
roadCenters = [0 0 0; 50 0 0];
road(scenario,roadCenters);

% 对于自我车辆，指定ClassID 属性为 1。
% 该值对应于的app Class ID， 1指的是类的actor Car。
% 有关应用程序如何定义类的更多详细信息，请参阅Actors参数选项卡中的类参数说明 。
egoVehicle = vehicle(scenario, 'ClassID',1, 'Position',[5 0 0]);
waypoints = [5 0 0; 45 0 0];
speed = 30;
smoothTrajectory(egoVehicle,waypoints,speed)


% 使用 drivingRadarDataGenerator 对象创建雷达传感器，
% 将两个传感器放在车辆原点，雷达朝前，摄像头朝后。
radar = drivingRadarDataGenerator('MountingLocation',[0 0 0]);
% 使用 visionDetectionGenerator 对象创建摄像头传感器。
camera = visionDetectionGenerator('SensorLocation',[0 0], 'Yaw',-180);

% 将场景、前置雷达传感器和后置摄像头传感器导入应用程序。
drivingScenarioDesigner(scenario, {radar,camera})

% 然后您可以运行场景并修改场景和传感器。
% 要生成新的 drivingScenario、drivingRadarDataGenerator和visionDetectionGenerator对象，
% 请在 App 工具条上选择导出>导出 MATLAB 函数，然后运行生成的函数。


%% 生成场景和传感器的Simulink模型
% 加载包含传感器的驾驶场景，并从场景和传感器生成 Simulink 模型。
% 有关从 App 生成 Simulink 模型的更详细示例，请参阅使用 Driving Scenario Designer 生成传感器模块。
% 
% 将预建的驾驶场景加载到应用程序中。
% 该场景包含两辆车穿过十字路口。
% 自我车辆向北行驶并包含一个摄像头传感器。
% 该传感器配置为检测物体和车道。
path = fullfile(matlabroot, 'toolbox' , 'shared' , 'drivingscenario' , 'PrebuiltScenarios' );
addpath(genpath(path)) % 添加文件夹到路径
drivingScenarioDesigner('EgoVehicleGoesStraight_VehicleFromLeftGoesStraight.mat' )
rmpath(path) % 从路径中删除文件夹

% 生成场景和传感器的 Simulink 模型。在 App 工具条上，选择Export > Export Simulink Model。
% 如果出现提示，请保存方案文件。

% Scenario Reader块从场景文件中读取道路和参与者。要更新模型中的场景数据，请更新应用程序中的场景并保存文件。

% 视觉检测生成器块重新创建应用程序中定义的相机传感器。
% 要更新模型中的传感器，请更新应用程序中的传感器，选择Export > Export Sensor Simulink Model，然后将新生成的传感器模块复制到模型中。如果您在更新传感器时更新了任何道路或角色，请选择Export > Export Simulink Model。在这种情况下，Scenario Reader块准确读取演员资料数据并将其传递给传感器。


%% 为 3D 模拟指定车辆轨迹
% 创建一个包含车辆轨迹的场景，
% 稍后您可以在 Simulink 中重新创建该场景以在 3D 环境中进行仿真。

% 打开其中一个预建场景，重新创建可通过 3D 环境使用的默认场景。
% 在应用程序工具条上，选择“打开” > “预构建场景” > “Simulation3D”并选择一个场景。
% 例如，选择 DoubleLaneChange.mat场景。
double_lane_change_path = fullfile(toolboxdir('shared'), ...
    'drivingscenario', 'PrebuiltScenarios', 'Simulation3D', ...
    'DoubleLaneChange.mat');
drivingScenarioDesigner(double_lane_change_path);

% 指定车辆及其轨迹。

% 更新车辆的尺寸以匹配 3D 模拟环境中预定义车辆类型的尺寸。
% 1. 在Actors选项卡上，选择 所需的3D 显示类型选项。
% 2. 在 App 工具条上，选择3D Display > Use 3D Simulation Actor Dimensions。
% 在Scenario Canvas中，演员尺寸会更新以匹配 3D 模拟环境中演员的预定义尺寸。
% 
% 稍后在 Simulink 中重新创建场景时，预览场景的外观。
% 在 App 工具条上，选择3D Display > View Simulation in 3D Display。
% 3D 显示窗口打开后，单击 “运行”。












