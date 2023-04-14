	

构建智能交通测试系统，
包括虚幻引擎、计算机视觉、深度学习等。

# 入门
[RoadRunner使用文档](https://ww2.mathworks.cn/help/roadrunner/index.html)

[RoadRunner Scenario使用文档](https://ww2.mathworks.cn/help/roadrunner-scenario/index.html)


# 环境配置

相关软件和数据[下载链接](https://pan.baidu.com/s/1y194-A2m0s9IUwuRWAttYw) ，提取码：dong。
其中 `RoadRunner_2022b_运行bin.win64.AppRoadRunner.exe_激活文件为license.lic.zip` 为RoadRunner的运行版本，
`RoadRunner.zip`为RoadRunner工程，`AutoVrtlEnv.zip`为虚幻引擎工程（需要从matlab中打开），
`matlab_2022b_win_run.zip` 为matlab运行版本。

安装虚幻引擎4.26。

在`matlab`中运行脚本
```commandline
main.mlx
```

## 贡献指南
[提交Pull Request流程](https://zhuanlan.zhihu.com/p/153381521) 。 


# 内容

## 社区场景建模
基于RoadRunner和虚幻引擎进行场景的建模，任务包括：
1. 建模咸嘉新村及周围的道路；
2. 建模湖南工商大学及周围的道路；

操作指南：
1. [导入底图](https://ww2.mathworks.cn/help/roadrunner/ug/build-roads-using-openstreetmap-data.html) 

## 局部路网建模
基于虚幻引擎和RoadRunner进行场景的建模，任务包括：
1. 检测单个摄像头的图像，并显示和返回检测结果；
2. 配置4个方向的摄像头，进行车辆的检测；
3. 计算红绿灯的配时方案，并进行红绿灯的设置；
4. 测试车辆按地图选点进行移动，看到红灯停、绿灯行，以及避让等功能；
5. 加入更多的车辆进行交通拥堵的模拟
6. 统计优化前和优化后的结果。

## 全局路网建模
基于RoadRunner Scenario和Carla进行城市级的场景建模，任务包括：
1. 参考[例子](https://ww2.mathworks.cn/help/driving/ug/autonomous-emergency-braking-with-high-fidelity-vehicle-dynamics.html) 进行Simulink、RoadRunner、Unreal的联合仿真。
```commandline
Examples\R2022b\autonomous_control\AutonomousEmergencyBrakingWithRoadRunnerScenarioExample
Examples\R2022b\autonomous_control\AEBWithHighFidelityDynamicsExample_2023a
```


## 需求管理
Requirement Toolbox

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

# 效果
![image](https://github.com/OpenHUTB/driving/blob/master/demo/multi_car.gif)

# 贡献者
杨子仪 [yangziyi](https://github.com/Gloria-ziyiyang) 

张卫 [champion123456](https://github.com/champion123456)

李诗帆 [q894749380](https://github.com/q894749380) 

李豪军 [q894749380](https://github.com/q894749380)


