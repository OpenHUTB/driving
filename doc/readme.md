
# 帮助文档翻译

## 原则
1. 每个页面的文件名为网页地址栏中.html前面文件文件名，比如`https://ww2.mathworks.cn/help/roadrunner/ug/create-traffic-signals-at-junctions.html` 对应翻译后的文件名为`create_traffic_signals_at_junctions.mlx`（文件名中的中划线改为下划线），使用 `.mlx` 文件存放翻译后的文档，该文件放置的目录为`doc/roadrunner/ug`；
2. 中文文档中的超链接尽量链接到本地的文档；


## [RoadRunner](https://ww2.mathworks.cn/help/roadrunner/index.html)

## [RoadRunner Scenario](https://ww2.mathworks.cn/help/roadrunner-scenario/index.html) 


# 需求管理

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


## 参考
向场景中添加车辆
```markdown
openExample('driving_lidar/BuildMapWithLidarOdometryAndMappingLOAMUsingUnrealEngineExample')
edit helperAddParkedVehicles.m
```

[车联网的交叉路口辅助](https://ww2.mathworks.cn/help/driving/ug/intersection-movement-assist-using-v2v.html) 



## 问题
### 编译器
```
Toolchain 'LCC-win64 v2.4.1 | gmake (64-bit Windows)' does not contain a build tool named 'C++ Compiler'.
```
安装 MinGW-w64 编译器：
主页 > 附加功能 > 获取附加功能，搜索 MinGW 或从功能菜单中选择。

### 不需要另外安装虚幻引擎成功运行是工具箱的原因
matlab自带的3D仿真引擎（4.26，不包括3D编辑器）位于：
matlab_2022b\toolbox\shared\sim3d_projects\automotive_project\UE4\WindowsNoEditor

openExample('autonomous_control/TLNWithUnrealExample')


### 场景
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




