%% 高速公路车道线跟随（highway lane following）
% 该示例展示了如何使用视觉处理、传感器融合和控制器组件来模拟高速公路车道跟随应用。
% 这些组件在包括摄像头和雷达传感器模型的三维仿真环境中进行测试。


%% 介绍
% 高速公路车道跟随系统引导车辆在标记的车道内行驶。
% 它还与同一车道上的前车保持设定的速度或安全距离。
% 该系统通常基于摄像头使用视觉处理算法检测车道和车辆。
% 然后将来自摄像头的车辆检测与来自雷达的检测融合在一起，以提高感知的鲁棒性。
% 控制器使用车道检测、车辆检测和设定速度来控制转向和加速。
% 
% 该示例演示如何创建测试基准模型以在三维仿真环境中测试视觉处理、传感器融合和控制。
% 测试基准模型可以针对不同的场景进行配置，以测试跟随车道和避免与其他车辆碰撞的能力。
% 在此示例中：
% 
% # *划分算法和测试平台* &mdash; 模型被划分为车道跟随算法模型和测试平台模型。
%    算法模型实现各个组件。测试平台包括算法模型的集成和虚拟测试框架。（&mdash表示长划线）
% # *探索测试台模型* &mdash; 测试台模型包含测试框架，其中包括场景、智能车动力学模型和使用真实值的指标评估。
%    一个长方体场景定义了车辆轨迹并指定了真实值。
%    等效的虚幻引擎&reg; 场景用于对来自雷达传感器的检测和来自单目相机传感器的图像进行建模。
%    自行车模型（假设车辆只有前后两个轮A和B,C为车辆质心；只考虑平面运动，不考虑Z方向的影响；
%    低速运动，此时不需要考虑车子行进方向和轮圈所指的方向两者间所成的这个角度，即滑移角的影响）用于对智能车进行建模。
% # *探索算法模型* &mdash; 算法模型是实现视觉处理、传感器融合、决策逻辑和控制组件以构建车道跟随应用程序的参考模型。
% # *可视化测试场景* &mdash; 该场景包含一条有多辆车的弯曲道路。
% # *模拟测试台模型* &mdash; 模拟模型以测试视觉处理、传感器融合和控制组件的集成。
% # *探索其他场景* &mdash 在其他条件下的场景进行系统测试。


%% 
% 测试控制器和感知算法的集成需要一个逼真的仿真环境。 
% 在此示例中，通过与 Epic Games&reg 的虚幻引擎集成来启用系统级模拟。 
% 三维模拟环境需要 Windows&reg 64 位平台。
%%
if ~ispc
    error(['3D Simulation is supported only on Microsoft', char(174), ' Windows', char(174), '.'])
end
%% 
% 设置随机种子来保证仿真结果可以复现。
rng(0)


%% 算法分块和测试基准
% 该模型分为单独的算法和测试基准模型。
% 
% * 算法模型&mdash; 算法模型是实现单个组件功能的参考模型（可以用各种目标检测算法替换）。
% * 测试基准模型&mdash; 高速公路车道跟随测试基准指定了测试算法模型的刺激（图像等）和环境。


%% 探索测试基准模型
% 在此示例中，使用系统级仿真测试台模型来探索车道跟随系统的控制和视觉处理算法的行为。
% 
% 要探索测试台模型，请打开项目示例文件的工作副本。 MATLAB&reg 将文件复制到示例文件夹，以便您可以编辑它们。
addpath(fullfile(matlabroot, "toolbox", "driving", "drivingdemos"));
helperDrivingProjectSetup("HighwayLaneFollowing.zip", workDir=pwd);


%%
% 打开系统层仿真测试台模型。
open_system("HighwayLaneFollowingTestBench")


%% 
% 基准测试模型包含三个模块：
% （场景）、感知、（规划）、决策、控制、（动力学）、（评估）:
% 
% * 三维场景仿真 &mdash; 指定用于仿真的道路、车辆、相机传感器、雷达传感器的子系统。
% * 车道线检测器 &mdash; 用于检测摄像机传感器捕获的视频帧中车道边界的算法模型。
% * 车辆检测器&mdash; 用于检测摄像机传感器捕获视频帧中车辆的算法模型。
% * 前向车辆传感器融合 &mdash; 从相机和雷达传感器融合车辆检测的模型。
% * 车道线跟随的决策逻辑 &mdash; 该算法模型根据最重要目标（MIO）和车道中心的信息为控制器提供横向和纵向决策逻辑。
% * 车道线跟随控制器 &mdash; 指定转向角（方向盘）和加速度（油门）控制的算法模型。
% * 车辆动力学 &mdash; 指定智能车动力学模型的子系统。
% * 指标评估 &mdash; 评估系统层次行为的子系统。

%% 
% 三维场景仿真子系统配置了道路网络、车辆位置并人工合成传感器数据。 
% 打开三维场景仿真子系统。
open_system("HighwayLaneFollowingTestBench/Simulation 3D Scenario")

%% 
% 场景和道路网络由子系统的以下几个部分指定：
% 
% * 三维场景仿真配置模块的 *SceneName* 参数设置为 |Curved road|（弯曲的路径）。
% * Scenario Reader 模块配置为使用包含道路网络的驾驶场景，该道路网络与 |弯曲| 道路场景中的一段道路网络非常匹配。
% 
% 车辆位置由子系统的以下几个部分指定：
% 
% * Ego 输入端口控制智能车的位置，该位置由具有地面跟随 1 模块的 Simulation 3D Vehicle （三维立方体）指定。
% * Vehicle To World 模块（Scenario模块中）将行动者（智能车）的姿势从车辆坐标转换成世界坐标。
% * Scenario Reader 模块输出行动者的姿态，控制目标车辆的位置。这些车辆由其他 Simulation 3D Vehicle with Ground Following (1-6) 模块指定。
% * Cuboid To 3D Simulation 模块将车辆姿态坐标系（相对于车辆后轴中心下方）转换为三维模拟坐标系（相对于车辆中心下方）。
%
% 装在智能车上的传感器由子系统的这些部分指定：
% 
% * 模拟 3D 相机的模块装在智能车上以捕捉其前视图。 该模块的输出图像由 Lane Marker Detector 模块处理以检测车道，并由 Vehicle Detector 模块以检测车辆。
% * Simulation 3D Probabilistic Radar Configuration 模块连接到智能车以检测三维仿真环境中的车辆。
% * Measurement Bias Center to Rear Axle 模块将 Simulation 3D Probabilistic Radar Configuration 模块的坐标系（相对于车辆中心下方）转换为车辆姿态坐标（相对于车辆后轴中心下方）。
% 
% 车辆动力学子系统使用自行车模型模块对智能车进行建模。 
% 打开车辆动力学子系统。
open_system("HighwayLaneFollowingTestBench/Vehicle Dynamics");


%% 
% 自行车模型模块实现了一个刚性的两轴单轨车身模型来计算纵向、横向和偏航运动。 
% 该模块考虑了车身质量、空气动力阻力以及由于加速和转向导致的车轴之间的重量分布。 
% 
% 度量评估子系统使用场景中的真实值来进行系统级度量评估。 
% 打开度量评估子系统。
open_system("HighwayLaneFollowingTestBench/Metrics Assessment");


%% 
% 在此示例中，使用四个指标来评估车道跟随系统。
% 
% *验证横向偏差* &mdash; 此块验证与车道中心线的横向偏差是否在相应场景的规定阈值内。 在编写测试场景时定义阈值。
% *验证车道* &mdash; 该模块验证智能车在整个仿真过程中跟随道路上的车道之一。
% *验证时间间隔* &mdash; 该块验证智能车和前导车辆之间的时间间隔是否超过 0.8 秒。 两辆车之间的时间间隔定义为车头距离与本车速度的比值。
% *验证无碰撞* &mdash; 此模块验证智能车在模拟过程中的任何时候都不会与前车发生碰撞。


%% 探索算法模型
% 车道跟随系统是通过集成车道标记检测器、车辆检测器、前方车辆传感器融合、车道跟随决策逻辑和车道跟随控制器组件而开发的。
% 
% 车道标记检测算法模型实现了一个感知模块来分析道路图像。 
% 打开车道标记检测算法模型。
open_system("LaneMarkerDetector");


%% 
% 车道标记检测器将单目相机传感器捕获的视频帧作为输入。 
% 它还通过 mask 获取相机的内参。 
% 它检测车道边界并通过 LaneSensor 总线输出每条车道的车道信息和标记类型。 
% 
% 车辆检测算法模型在驾驶场景中的检测车辆。 
% 打开车辆检测器算法模型。
open_system("VisionVehicleDetector");
%% 
% 车辆检测器将摄像头传感器捕获的视频帧作为输入。 
% 它还通过 mask 获取相机的内参。 
% 它检测车辆并将车辆的边界框信息作为输出。 
% 有关如何设计和评估车辆检测器的更多详细信息，请参阅为视觉车辆检测器生成代码。
% 
% 
% 前向车辆传感器融合组件融合来自摄像头和雷达传感器的车辆检测，并使用中央级跟踪方法跟踪检测到的车辆。 
% 打开前向车辆传感器融合算法的模型。
%%
open_system("ForwardVehicleSensorFusion");

%% 
% 前向车辆传感器融合模型将来自视觉和雷达传感器的车辆检测作为输入。 
% 雷达检测被聚类，然后与视觉检测连接。 
% 然后使用联合概率数据关联跟踪器跟踪连接的车辆检测。 
% 该组件输出确认的轨迹。 
% 
% 
% 车道跟随决策逻辑算法模型根据检测到的车道和跟踪轨迹指定横向和纵向的决策。 
% 打开车道跟随决策逻辑算法模型。
%%
open_system("LaneFollowingDecisionLogic");
%% 
% 车道跟随决策逻辑模型将来自车道标记检测器所检测到的车道和来自前方车辆传感器融合模块的确认跟踪轨迹作为输入。 
% 它估计车道中心，并确定与本车在同一车道上行驶的 MIO 领头车。 
% 它输出 MIO 和本车之间的相对距离和相对速度。
%
% 
% 车道跟随控制器指定纵向和横向控制。 
% 打开车道跟随控制器算法模型。
%%
open_system("LaneFollowingController");
%% 
% 控制器将设定的速度、车道中心和 MIO 信息作为输入。 
% 它使用路径跟随控制器来控制智能车的转向角和加速度。 
% 它还使用看门狗制动控制器来应用制动作为故障安全模式。 
% 控制器输出转向角和加速命令来确定是加速、减速还是制动。 
% 车辆动力学模块使用这些输出对智能车进行横向和纵向控制。


%% 可视化测试场景
% 辅助函数 |scenario_LFACC_03_Curve_StopnGo| 生成一个与 |HighwayLaneFollowingTestBench| 模型兼容的长方体场景。 
% 这是一个开环场景，在弯曲的道路上包含多个目标车辆。 
% 该长方体场景中的道路中心、车道标记和车辆与 3D 模拟环境提供的一段弯曲道路场景紧密匹配。 
% 在这种情况下，领先车辆在本车前方减速，而其他车辆在相邻车道上行驶。
% 
% 绘制开环场景以查看本车和目标车辆的交互。
% 
% 默认的仿真测试了 |scenario_LFACC_03_Curve_StopnGo| 场景。 
% 此示例提供了与 |HighwayLaneFollowingTestBench| 模型兼容的其他场景。
%    scenario_LF_01_Straight_RightLane
%    scenario_LF_02_Straight_LeftLane
%    scenario_LF_03_Curve_LeftLane 
%    scenario_LF_04_Curve_RightLane
%    scenario_LFACC_01_Curve_DecelTarget
%    scenario_LFACC_02_Curve_AutoRetarget 
%    scenario_LFACC_03_Curve_StopnGo              % 曲线路径，跟随车道线
%    scenario_LFACC_04_Curve_CutInOut
%    scenario_LFACC_05_Curve_CutInOut_TooClose
%    scenario_LFACC_06_Straight_StopandGoLeadCar  % 直线路径，遇到前车刹车
scenario_name = 'scenario_LFACC_03_Curve_StopnGo';  % 所测试场景的名字
hFigScenario = helperPlotLFScenario(scenario_name);


%% 
% 智能车不受闭环控制，因此与移动较慢的前车发生碰撞。 
% 闭环系统的目标是跟随车道并与前车保持安全距离。 
% 在 |HighwayLaneFollowingTestBench| 模型中，智能车具有与开环场景相同的初始速度和初始位置。
%%
% 关闭图形。
close(hFigScenario)

%% 测试台模型仿真
% 在三维仿真环境中配置和测试算法的集成。 
% 为了减少命令窗口输出，这里关闭基于模型的控制器更新消息。
mpcverbosity("off");

%% 
% 配置测试台模型以使用相同的场景。
helperSLHighwayLaneFollowingSetup("scenarioFcnName", scenario_name);
sim("HighwayLaneFollowingTestBench")  % 进行仿真

%% 
% 绘制横向控制器的性能结果。
hFigLatResults = helperPlotLFLateralResults(logsout);

%%
% 关闭图形。
close(hFigLatResults)

%% 
% 检查仿真结果。
%% 
% * *检测到的车道边界横向偏移图* 显示了检测到的左车道和右车道边界相对于车道中心线的横向偏移。 检测到的值接近车道的真实值，但偏差很小。
% * *横向偏差图* 显示了本车与车道中心线的横向偏差。 理想情况下，横向偏差为零米，这意味着智能车完全遵循中心线。 当车辆改变速度以避免与另一辆车发生碰撞时，会发生小偏差。
% * *相对偏航角图* 显示了本车与车道中心线之间的相对偏航角。 相对偏航角非常接近于零弧度，这意味着本车的航向角与中心线的偏航角紧密匹配。
% * *转向角图* 显示了智能车的转向角。 
% 转向角轨迹是平滑的。
%% 
% 绘制纵向控制器性能结果。
hFigLongResults = helperPlotLFLongitudinalResults(logsout,time_gap,...
    default_spacing);

%%
% 关闭图像。
close(hFigLongResults)

%% 
% 检查仿真结果。
%% 
% *相对纵向距离图* 显示了本车和 MIO 之间的距离。 在这种情况下，本车接近 MIO 并接近它或在某些情况下超过安全距离。
% *相对纵向速度图* 显示了本车和 MIO 之间的相对速度。 在这个例子中，车辆检测器只检测位置，因此控制算法中的跟踪器估计速度。 估计的速度滞后于实际（真实）MIO 相对速度。
% *绝对加速度图* 显示当本车辆离 MIO 太近时，控制器会命令车辆减速。
% *绝对速度图* 显示本车遵循最初设定的速度，但当 MIO 减速时，为避免碰撞，本车也会减速。

%% 
% 在仿真过程中，模型将信号作为 |logout| 记录到工作区，并将相机传感器的输出记录到 |forwardFacingCamera.mp4|。 
% 以使用 |helperPlotLFDetectionResults| 函数来可视化模拟检测，
% 还可以将可视化检测记录到视频文件中，以供无法访问 MATLAB 的其他人查看。
% 
% 根据记录的数据绘制检测结果，生成视频，然后打开 Video Viewer 应用程序。
hVideoViewer = helperPlotLFDetectionResults(...
    logsout, "forwardFacingCamera.mp4" , scenario, camera, radar,...
    scenarioFcnName,...
    "RecordVideo", true,...
    "RecordVideoFileName", scenarioFcnName + "_VPA",...
    "OpenRecordedVideoInVideoViewer", true,...
    "VideoViewerJumpToTime", 10.6);

%% 
% 播放生成的视频。
%
% * *前置摄像头* 显示摄像头传感器返回的图像。 
% 左侧车道边界以红色绘制，右侧车道边界以绿色绘制。 
% 这些车道由车道标记检测器模型返回。 
% 检测跟踪的结果也覆显在视频上。
% * *鸟瞰图* 显示真实的车辆位置、传感器覆盖区域、概率检测和跟踪输出。 
% 绘图标题包括模拟时间，以便可以将视频和之前的静态绘图之间的事件关联起来。

%% 
% 关闭显示图。
close(hVideoViewer)

%% 
% 这些场景代表两种类型的测试。
%
% * 使用带有 |scenario_LF_| 前缀的场景来测试车道检测和车道跟踪算法，而不会受到其他车辆的阻碍。 场景中的车辆被定位为使本车看不到它们。
% * 使用带有 |scenario_LFACC_| 前缀的场景来测试车道检测和车道跟踪算法以及在本车传感器覆盖区域内的其他车辆。

%% 
% 检查每个文件中的注释以获取有关每个场景中道路和车辆几何形状的更多详细信息。 
% 可以使用 |helperSLHighwayLaneFollowingSetup| 函数配置 |HighwayLaneFollowingTestBench| 模型和工作区来模拟这些场景。
% 
% 例如，在评估基于摄像头的车道检测算法对闭环控制的影响时，从有道路但没有车辆的场景开始可能会有所帮助。 
% 要为此类场景配置模型和工作区，请使用以下代码。
helperSLHighwayLaneFollowingSetup("scenarioFcnName",...
    "scenario_LF_04_Curve_RightLane");



%% 为 ACF 车辆检测器生成 C++ 代码
% 可以为 ACF 算法生成 C++ 代码、应用常见优化并生成报告以方便探索生成的代码。 
% 配置测试台模型以使用 ACF 变体。
helperSLVisionVehicleDetectorSetup("detectorVariantName", "ACF");  % 在车道线跟随中是否生效？

%%
% 配置 |视觉车辆检测器| 模型以生成 C++ 代码以实时实现算法。 
% 设置模型参数以启用代码生成并显示配置值。
% 设置和查看模型参数以启用 C++ 代码生成。
helperSetModelParametersForCodeGeneration('VisionVehicleDetector');
save_system('VisionVehicleDetector');

%%
% 从参考模型生成代码并查看代码生成报告。
rtwbuild('VisionVehicleDetector');

%% 
% 使用代码生成报告探索生成的代码。 
%
% * *initialize* &mdash; 在初始化的时候调用一次。
% * *step* &mdash; 每一步执行车辆检测算法定期调用。
% * *terminate* &mdash; 在结束时条用一次。

%% 使用软件在环进行功能评估
% 在为聚集通道特征（aggregate channel features，ACF）视觉车辆检测器变体生成 C++ 代码后，现在可以使用 SIL 仿真评估代码功能。 
% SIL 仿真使您能够验证主机上编译生成的代码在功能上是否与正常模式等效。



%% 后续工作
% 再次启用 MPC 更新消息。
mpcverbosity("on");

% 无条件地关闭任一或所有 Simulink 系统窗口
bdclose('all');
% 关闭视频播放窗口
clear all; close all;


%% 结论
% 该示例展示了如何集成视觉处理、传感器融合和控制器组件，以在闭环三维仿真环境中模拟高速公路车道跟随系统。 
% 该示例还演示了各种评估指标，以验证设计系统的性能。 
% 还可以为嵌入式实时目标（Embedded Real-time Target，ERT）生成可部署的算法模型代码。


