 
# **交通工具** 

该项目是一个基于 MATLAB® 的端到端交通导航学习平台，使用 MATLAB 的 自动驾驶工具箱以及其他几个工具箱，提供一个使用适合测试自动驾驶学习算法的长方体世界的平台。
此外，交通工具使用 SUMO 交通模拟器在模拟器上建模和定义道路交通参与者，以便用户可以专注于为 Ego Vehicle 提供解决方案。

此外，交通工具模拟器提供了一个与 MATLAB 的强化学习工具箱™兼容的开箱即用环境，允许用户轻松训练“自我车辆”代理如何导航交通。
同样，交通工具允许用户通过创建自己的道路拓扑并定义交通交互来定义自己的控制器算法，以便在任何交通情况下实现自动驾驶。

交通工具在 MATLAB 中定义“自我车辆”，并在 SUMO 上更新自我车辆的状态以模拟交通交互。
同样，交通工具将 SUMO 生态系统中定义的车辆与 MATLAB 驾驶场景参与者同步，以定义和控制道路交通参与者。

为了以交互方式提供自定义拓扑，深度交通实验室使用驾驶场景设计器应用程序提供驾驶场景和道路拓扑，随后使用 OpenDRIVE® 导出文件和 SUMO 的 [netconvert](https://sumo.dlr.de/docs/netconvert.html) 将其转换为 SUMO .net 文件。
有关详细信息，请参阅 [此处](https://www.mathworks.com/help/driving/ref/drivingscenariodesigner-app.html) 的文档。


<p align="center">
<img src="./figures/AppleHill.gif" alt="logo"  width = "1000"/>
</p>

## MATLAB&reg; 工具箱依赖项
需要 MATLAB R2021a 或更高版本以及以下工具箱：
- [Automated Driving Toolbox&trade;](https://www.mathworks.com/products/automated-driving.html)
- [Navigation Toolbox&trade;](https://www.mathworks.com/products/navigation.html#:~:text=Navigation%20Toolbox%E2%84%A2)
- [Robotics Systems Toolbox&trade;](https://www.mathworks.com/products/robotics.html)
- [Image Processing Toolbox&trade;](https://www.mathworks.com/products/image.html)
- [Computer Vision Toolbox&trade;](https://www.mathworks.com/products/computer-vision.html)
- [Sensor Fusion and Tracking Toolbox&trade;](https://www.mathworks.com/products/sensor-fusion-and-tracking.html)
- [Reinforcement Learning Toolbox&trade;](https://www.mathworks.com/products/reinforcement-learning.html)
- [Deep Learning Toolbox&trade;](https://www.mathworks.com/products/deep-learning.html)

## 第三方产品：
该项目使用以下外部依赖项：
- [SUMO](https://www.eclipse.org/sumo/) (1.9.2 or newer)
- [TraCI4Matlab](https://www.mathworks.com/matlabcentral/fileexchange/44805-traci4matlab)
- [INPOLY](https://github.com/dengwirda/inpoly)

**注意：** 目前 Deep Traffic Lab 仅支持 Windows 10。

## 设置 
安装：
1. 安装 SUMO 1.9.2 或更高版本 ([指导](https://sumo.dlr.de/docs/Installing/index.html)) 
2. 将 SUMO_HOME 配置为环境变量 ([指导](https://sumo.dlr.de/docs/Basics/Basic_Computer_Skills.html#windows))
3. 克隆 Git 存储库
```
git clone <[URL to Git repo]>
```
4. 通过运行初始化子模块
```
git submodule update --init
```
5. 打开 MATLAB
6. 进入该目录下
7. 运行 ./scripts/install.m

**注意：** 每次 MATLAB 路径重置时都需要运行步骤 7

## 入门

该项目遵循如下所示的工作流程：
<p align="center">
<img src="./figures/Workflow.PNG" alt="workflow"  />
</p>


### *强化学习：*
为了运行强化学习训练，用户可以参考此存储库附带的 [示例](./Example/StraightHighwayDiscreteMetaAction/main.m) 。

为了能够运行强化学习训练，用户需要定义一个 MATLAB 兼容环境。这可以通过修改此存储库附带的模板环境 ([DiscreteHighwayEnvironment.m](Example/StraightHighwayDiscreteMetaAction/DiscreteHighwayEnvironment.m)) 来完成，并且可以用作模板来根据用户的需要修改和使用自定义应用程序。

提供的示例附带了 Ego 车辆和交通车辆的默认 .json 配置。但是，如果需要，用户可以通过修改提供的模板来修改配置文件以定义 [EgoVehicles](Example\StraightHighwayDiscreteMetaAction\SingleEgoMinimalSensorsConfigTemplate.m) 和 [TrafficVehicles](Example/StraightHighwayDiscreteMetaAction/TrafficConfigTemplate.m) 。 

此外，在 egoConfig.json 文件中，用户需要正确定义 Ego 车辆要使用的传感器。有关可用传感器的列表，请参阅 [EgoTemplate](ConfigurationTemplates/TwoEgoSensorsConfigTemplate.m) 文件，其中定义了相机、激光雷达和雷达的数组。这些传感器将用作强化学习环境观察空间的一部分。

有关如何为强化学习代理生成神经网络的更多详细信息，请参阅 [此处](https://www.mathworks.com/help/reinforcement-learning/ug/create-agent-using-deep-network-designer-and-train-using-image-observations.html)

<p align="center">
<img src="./Example/StraightHighwayDiscreteMetaAction/result/result_media/result.gif" alt="RL Training"  />
</p>

***注意：*** 尽管能够定义不止一种自我车辆，但 Deep Traffic Lab 目前不支持多智能体强化学习训练，因为当前对多智能体环境训练的支持是使用 Simulink® 完成的。

### *离散/连续控制：*
该工具箱可以使用控制机制而不是学习机制。在 [该](TestScripts\TestContinuousModelStanley\TestModelStanleyController.m) 示例中，自主车辆上使用了 stanley 控制器。受控车辆使用离散自行车模型沿着笔直道路上的一组路点行驶。

<p align="center">
<img src="./figures/Stanley/stanleyGif.gif" alt="Stanley Controller"  />
</p>

### *定义自定义网络：*
该工具箱使用 [Driving Scenario Designer App](https://www.mathworks.com/help/driving/ref/drivingscenariodesigner-app.html) 以交互方式定义道路。要定义自定义场景，请按照下面描述的说明进行操作

1. 按照 [此处](https://www.mathworks.com/videos/driving-scenario-designer-1529302116471.html) 所述创建道路拓扑
2. 如果定义了一条直路，最好将道路分成多个路段，以便稍后定义路线
3. 将场景导出到 MATLAB 函数
4. 将道路拓扑导出到 OpenDRIVE
<p align="center">  
<img src="./figures/CustomTopologyInstructions/1.PNG" width = "1200">
</p>

5. 打开 [scripts/GenerateEnvrionmentFiles.m](scripts/GenerateEnvironmentFiles.m) 
6. 指定生成的 .xodr 文件的路径和目标文件夹以生成网络文件

<p align="center">  
<img src="./figures/CustomTopologyInstructions/2.PNG" width = "1200">
</p>

7. 首先，将使用 SUMO 的 [netconvert](https://sumo.dlr.de/docs/netconvert.html) 工具创建 SUMO .net.xml 文件。转换完成后，会弹出SUMO的 [Netedit](https://sumo.dlr.de/docs/Netedit/index.html#changing_connections]) 。
8. 定义交通规则，例如速度限制以及每条道路上允许的车辆，如下所示

<p align="center">  
<img src="./figures/CustomTopologyInstructions/3.PNG" width = "1200">
</p>


9. 转到 NETEDIT 内的“Demand”选项卡
10. 选择路线图标
11. 通过选择边定义可用路线

<p align="center">  
<img src="./figures/CustomTopologyInstructions/4.PNG" width = "1200">
</p>

12. 如果应专门为自我车辆定义路线，请将路线 ID 定义为“ego_route”。深度交通实验室只会在此路线内生成 ego_vehicles
13. 将网络和路由文件分别保存为 "network.net.xml" 和 "Routes.rou.xml"。
14. 为了能够使用新创建的环境，需要创建 SUMO 配置文件。用户可以修改此存储库附带的 [.sumocfg](highwayConfiguration.sumocfg) 。有关如何创建 .sumocfg 文件的更多信息，请参阅 SUMO 文档。


### *定义配置文件：*

该工具使用 SUMO 配置文件来调用相应的 SUMO 网络和路由文件（有关更多信息，请参阅 SUMO 文档）。但是，为了指定 Ego 车辆和交通车辆的详细信息和配置，DTL 使用 .json 文件作为标准。为了创建 JSON 配置文件，分别为 Ego 车辆和交通车辆提供了模板脚本。有关如何使用它们的更多信息，请转到 [ConfigurationTemplates](ConfigurationTemplates) 文件夹。

各个配置文件的整体结构如下所示：

<p align="center">  
<img src="./figures/trafficJson.PNG" width = "1200">
</p>

<p align="center">  
<img src="./figures/egoJson.PNG" width = "1200">
</p>

两个ego配置文件示例如下：

<p align="center">  
<img src="./figures/egoJsonEg.PNG" width = "1200">
</p>


### *定义交通环境：*
为了能够运行该工具箱，除了模拟 StopTime、SampleTime 以及指示是否应调用 SUMO gui 的布尔值之外，模拟器还需要一组配置文件，如下面的代码片段所示。
```
scenario = highwayStraight();
SampleTime = 0.1; %[sec]
StopTime = SampleTime*1000; %[sec]
```
```
highwayEnv = TrafficEnvironment(scenario, ...
    sumoConfigFile, ...
    egoConfigFile,...
    trafficConfigFile,...
    StopTime,...
    'SampleTime', SampleTime,...
    'SumoVisualization', true);
```

变量“scenario”对应于以编程方式或使用 Driving Scenario Designer 应用程序定义的道路拓扑，并描述 SUMO 使用的相同道路拓扑。确保 .sumocfg 文件路由和网络对应于同一网络。

定义 *"TrafficEnvrionment"* 后，用户可以通过随机选择车辆来调用环境的可视化

```
highwayEnv.create_random_visualization;
```
或通过呼叫特定车辆的名称

```
highwayEnv.create_chase_visualization('ego01');
```

<p align="center">  
<img src="./figures/visualizationEgo.png">
</p>

为了部署流量，可以调用以下成员方法

```
[hasBeenCreated, numberOfTrafficActors, egos] = highwayEnv.deploy_traffic();
```

*"deploy_traffic"* 方法，顾名思义，在场景上部署流量。此外，它还返回以下参数：

- *hasBeenCreated:* 布尔值，指定环境创建是否成功
- *numberOfTrafficActors:* 描述创建了多少个 Actor 的整数
- *egos:* 包含 ego 车辆句柄的单元格列表。使用此句柄，用户可以监视自我状态、当前状态，并调用自我的步骤函数，该函数将控制输入作为其参数

此外，当调用 *"deploy_traffic"* 法时，当前流量将消失，因此该方法也可用作重置功能。


## 示例
要了解如何在测试工作流程中使用它，请参阅 [Examples](/examples/) 或 [TestScripts](TestScripts/). 

## 架构
该工具使用三个主要类来定义环境的架构，而不考虑 RLEnv 类，该类充当用户根据自己的需求定义环境的模板。每个类的功能描述如下。

- **TrafficEnvironment:** 该类分别负责定义 MATLAB 和 SUMO 中环境之间的连接。此外，它还使用用户指定的配置文件来根据用户的规范创建和部署流量。该类还负责在 MATLAB 的驾驶场景中创建追逐图可视化。TraffiicEnvironment允许用户在 SUMO 中定义车道变换模型，这可以是子车道模型，也可以是预先指定的固定时间车道变换时间窗口。有关更多详细信息，请参阅 [SUMO 文档](https://sumo.dlr.de/docs/Simulation/SublaneModel.html) 和有关构造函数方法的 [Class Documentation](lib/@TrafficEnvironment/TrafficEnvironment.m) 。
- **TrafficVehicle:** 此类代表模拟中的每辆车辆。因此，它负责在仿真中定义车辆的物理属性，并在 SUMO 和 MATLAB 之间进行同步。由于 MATLAB 中驾驶场景世界的架构，MATLAB 中的参与者在 SUMO 中完成路线后，会被放置在远离场景的位置。当在 SUMO 中创建新的车辆实例时，TrafficVehicle类会回收“已消失”的车辆。
- **EgoVehicle:** 该类继承自TrafficVehicle类，并使用与父类相同的方法。然而，此类还负责定义车辆模型（SUMO、自行车），用于使用用户在配置文件上指定的已定义动作空间（DiscreteMeta-Action、离散、连续）来控制“自我车辆”。此外，此类负责定义自我车辆在模拟期间将使用的传感器和观察结果（理想、激光雷达、雷达、摄像头、占用网格）。

下面显示了每个类使用的公共方法的图表

<p align="center">  
<img src="./figures/class.PNG" width="1500">
</p>

同样，该工具箱的初始化架构如下图所示

<p align="center">  
<img src="./figures/initializationArch.PNG" width="1500">
</p>

其中可用选项如下

<p align="center">  
<img src="./figures/initializationArchOptions.PNG" width="1500">
</p>

完全指定环境后，运行时同步如下图所示

<p align="center">  
<img src="./figures/RuntimeArch.PNG" width="1500">
</p>



## 目前的限制
- RL 训练仅支持单代理环境
- 目前不支持 RL Agent 的并行训练 
- 由于道路内部空间限制，trafficConfig.json 文件中指定的交通参与者数量可能与生成车辆的实际数量不同
- 由于将驾驶场景设计器拓扑导出到 OpenDRIVE 的 .xodr 文件时出现问题，SUMO 道路拓扑可能与 MATLAB 道路拓扑不同。欲了解更多信息，请参见 [此处](https://www.mathworks.com/help/driving/ref/drivingscenario.export.html#mw_fea198e6-827f-49bd-a1f5-4c953b2139b1).
- 不支持 SUMO 感应环或流
- 激光雷达点云可能会因错误而引发错误。此错误已在未来版本中修复 (MATLAB r2021b)
- 在为自我车辆定义连续模型时，由于 SUMO 和 DSD 之间的同步架构，自我车辆上存在两步延迟。因此，建议使用较小的时间步长



## 参考
[深度交通实验室](https://github.com/mathworks/deep-traffic-lab)

