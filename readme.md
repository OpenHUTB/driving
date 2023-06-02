	

构建智慧交通系统，
包括交通场景数字孪生、车流诱导、区域信控、停车管理等。

# 效果

## 数字孪生

<figure class="half">
    <img src=fig/west_gate.jpg width="380"/><img src=fig/business_building.png width="380"/>
</figure>

<img src=fig/crossroads.png alt="图片替换文本" width="380" />

## 车流诱导

<figure class="half">
    <img src=fig/multi_car.gif alt="multi_car" width="380"/><img src=fig/street_view.gif alt="street_view" width="380"/>
</figure>



## 区域信控

<figure class="half">
    <img src=fig/green2red.gif alt="green2red" width="380"/><img src=fig/red2green.gif alt="street_view" width="380"/>
</figure>



## 停车管理

<figure class="half">
    <img src=parking/img/imagesindex.jpg width="380"/><img src=parking/img/imagesparking.jpg width="380"/>
</figure>

# 入门文档
[静态场景](https://ww2.mathworks.cn/help/roadrunner/index.html) 、
[动态场景文档](https://ww2.mathworks.cn/help/roadrunner-scenario/index.html) 、
[自动驾驶文档](https://ww2.mathworks.cn/help/driving/index.html) 。

## 经典示例

[使用openstreetmap数据构建道路](https://ww2.mathworks.cn/help/roadrunner/ug/build-roads-using-openstreetmap-data.html)

[从记录的车辆数据生成场景](https://ww2.mathworks.cn/help/driving/ug/scenario-generation-from-recorded-vehicle-data.html)


# 环境配置

相关软件和数据[下载链接](https://pan.baidu.com/s/1y194-A2m0s9IUwuRWAttYw) ，提取码：dong。
```text
RoadRunner_2022b_运行bin.win64.AppRoadRunner.exe_激活文件为license.lic.zip 为RoadRunner的运行版本，

RoadRunner.zip 为RoadRunner工程，

AutoVrtlEnv.zip 为虚幻引擎工程（需要从matlab中打开）

matlab_2022b_win_run.zip 为matlab运行版本。

parking 文件夹为停车管理系统的相关软件
```

Matlab安装连接虚幻引擎的插件：
```markdown
uiopen('{REPOSITORY_PATH}\utils\mlpkginstall\adtunrealengine4.mlpkginstall',1)
```

安装虚幻引擎4.26后，在`matlab`中运行脚本以下脚本：
```commandline
main.mlx
```
运行后等待出现"In Unreal Editor, select 'Play' to view the scene"后再在虚幻编辑器中点击“运行”。

## 贡献指南
[提交Pull Request流程](https://zhuanlan.zhihu.com/p/153381521) 。 

## 虚幻引擎配置
1. [为自定义场景安装支持包](https://ww2.mathworks.cn/help/releases/R2022a/driving/ug/install-and-configure-support-package-for-customizing-scenes.html) 。


# 内容

## 场景建模
基于RoadRunner和虚幻引擎进行场景的建模，任务包括：
1. 建模咸嘉新村及周围的道路；
2. 建模湖南工商大学及周围的道路；
3. 使用虚幻引擎建模桐梓坡路和西二环交叉的十字路口；


## 局部路网建模
基于虚幻引擎和RoadRunner进行场景的建模，任务包括：
1. 检测单个摄像头的图像，并显示和返回检测结果；
2. 配置4个方向的摄像头，进行车辆的检测；
3. 计算红绿灯的配时方案，并进行红绿灯的设置；
4. 测试车辆按地图选点进行移动，看到红灯停、绿灯行，以及避让等功能；
5. 加入更多的车辆进行交通拥堵的模拟
6. 统计优化前和优化后的结果。

基于RoadRunner Scenario和Carla进行城市级的场景建模，任务包括：
1. 参考 [RoadRunner 场景的公路车道跟踪](https://ww2.mathworks.cn/help/driving/ug/highway-lane-following-with-roadrunner-scenario.html) 进行Simulink、RoadRunner、Unreal的联合仿真。
```commandline
openExample('autonomous_control/HighwayLaneFollowingWithRRScenarioExample')
openExample('autonomous_control/AutonomousEmergencyBrakingWithRoadRunnerScenarioExample')
openExample('autonomous_control/AEBWithHighFidelityDynamicsExample')
```

2. [使用 Simulink 将传感器添加到 RoadRunner 场景](https://ww2.mathworks.cn/help/driving/ug/add-sensors-to-roadrunner-scenario-using-simulink.html) 
```markdown
openExample('driving/AddSensorsToRoadRunnerScenarioUsingSimulinkExample')
```

## 全局路网建模
参考[自动场景生成](https://ww2.mathworks.cn/help/driving/ug/automatic-scenario-generation.html) 、[从车道检测和 OpenStreetMap生成高精度场景](https://ww2.mathworks.cn/help/driving/ug/build-high-definition-road-scene-from-lane-detections-and-openstreetmap.html) ，构建长沙高新区路网仿真模型。




## 需求管理

### 数据需求
包含这些列的表：
timeStamp— 收集 GPS 数据的时间，以微秒为单位。
latitude- 自我航路点的纬度坐标值。单位是度。
longitude— 自我航路点的经度坐标值。单位是度。
altitude- 自我航路点的高度坐标值。单位为米。

安装在自我车辆上的前向单眼相机记录的相机数据，相机数据是一个包含两列的表格：
timeStamp— 捕获图像数据的时间，以微秒为单位。
fileName— 数据集中图像的文件名。

### Requirement Toolbox

* 加入交通灯逻辑、城市场景




## 实现
各个阶段形成一个闭环。



### 场景
基于[城市场景](demo/TLNWithUnrealExample)，利用虚幻引擎来构建学校场景。
[AirSim](https://github.com/microsoft/AirSim) 
[Road Runner](https://zhuanlan.zhihu.com/p/165376866) 
[51VR](https://www.51aes.com/) 

### 感知
1. [使用虚幻引擎设计车道线检测器](https://ww2.mathworks.cn/help/driving/ug/design-of-lane-marker-detector-in-3d-simulation-environment.html) 
2. 车辆检测
3. 行人检测
4. [前向车辆传感器融合](https://ww2.mathworks.cn/help/driving/ug/forward-vehicle-sensor-fusion.html) 
5. 可行驶区域
6. 地图
全局地图：从云端获得或者本地逐步构建全局地图。
局部地图：SLAM。

### 规划
1. 全局路径规划

### 决策
1. 局部轨迹规划
2. 决策逻辑

### 控制
由横向和纵向的决策生成转向角（方向盘）和加速度（油门）控制。
1. [设计基于模型的控制器](https://ww2.mathworks.cn/help/mpc/ref/mpcdesigner-app.html) ，生成横向和纵向的决策。
[在Simulink中设计基于模型的控制器](https://ww2.mathworks.cn/help/mpc/gs/designing-a-model-predictive-controller-for-a-simulink-plant.html) 
[路径跟随控制系统](https://ww2.mathworks.cn/help/mpc/ref/pathfollowingcontrolsystem.html) 
2. 强化学习，[DDPG路径跟随控制](https://ww2.mathworks.cn/help/deeplearning/ug/train-ddpg-agent-for-path-following-control.html) 


### 机械
车辆动力学仿真
买一台可以程序控制的电动车。
[在 Simulink 和 Gazebo 中使用移动机械手设计和模拟仓库取放应用程序](demo/DesignAndSimulateAMobileManipulatorExample/DesignAndSimulateAMobileManipulatorExample.mlx)

### 评估
性能评估并反馈


## 部署
[车道标记检测器代码生成](https://ww2.mathworks.cn/help/driving/ug/generate-code-for-lane-marker-detector.html) 
[视觉车辆检测器代码生成](https://ww2.mathworks.cn/help/driving/ug/generate-code-for-vision-vehicle-detector.html) 


## 测试
[高速公路车道跟随的自动测试](https://ww2.mathworks.cn/help/driving/ug/automate-testing-for-highway-lane-following.html) 
[自动测试](demo\AutomateTestingForHighwayLaneFollowingExample\AutomateTestingForHighwayLaneFollowingExample.m)


# 参考
向场景中添加车辆
```markdown
openExample('driving_lidar/BuildMapWithLidarOdometryAndMappingLOAMUsingUnrealEngineExample')
edit helperAddParkedVehicles.m
```

[车联网的交叉路口辅助](https://ww2.mathworks.cn/help/driving/ug/intersection-movement-assist-using-v2v.html) 



# 问题
## 编译器
```
Toolchain 'LCC-win64 v2.4.1 | gmake (64-bit Windows)' does not contain a build tool named 'C++ Compiler'.
```
安装 MinGW-w64 编译器：
主页 > 附加功能 > 获取附加功能，搜索 MinGW 或从功能菜单中选择。

## 不需要另外安装虚幻引擎成功运行是工具箱的原因
matlab自带的3D仿真引擎（4.26，不包括3D编辑器）位于：
matlab_2022b\toolbox\shared\sim3d_projects\automotive_project\UE4\WindowsNoEditor

openExample('autonomous_control/TLNWithUnrealExample')


## 场景
```
函数或变量 'scenario_VVD_01_Curve_FiveVehicles' 无法识别。
```
需要在 Matlab 界面打开工程 `VisionVehicleDetector/VisionVehicleDetectorVisionVehicleDetector.prj`

matlab自带虚幻引擎（无编辑器）目录：
```commandline
matlab_2022b\toolbox\shared\sim3d_projects\automotive_project\UE4\WindowsNoEditor\VehicleSimulation.exe
```


和Editor进行协同仿真，需要 
```commandline
USCityBlock.umap、USCityBlock_BuiltData.uasset、USCityBlockLabel.uasset（位于AutoVrtlEnv\Content\Maps）
```


# 贡献者

## 局部场景仿真
张卫 [champion123456](https://github.com/champion123456)

李诗帆 [q894749380](https://github.com/q894749380) 

李豪军 [q894749380](https://github.com/q894749380)

刘子涵

李权龙

蒋平平

## 路网和车流仿真
王海东 [donghaiwang](https://github.com/donghaiwang) 

杨子仪 [yangziyi](https://github.com/Gloria-ziyiyang) 

王磊

张未来 [randomforest1111](https://github.com/randomforest1111)

邹岱

刘璐

冯颖



