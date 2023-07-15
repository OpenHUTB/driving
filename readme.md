​	

湖工商交通数字孪生引擎是在人、车、路、地、物数据底座的基础上，搭建的一套同时支持宏观、中观和微观的仿真引擎，提升交通服务水平，
包括交通场景数字孪生、区域信控、车流诱导、停车管理等模块。

<img src=fig/hutb.png alt="图片替换文本" width="780" />

# 系统概述
本平台支持对仿真结果可视化，同时提供分析、快速预测等辅助模块。宏观、中观、微观仿真既支持传统的离线仿真，同时也支持前沿的在线仿真，为城市等场景的预测和交通状况管理提供支持。其中，宏观仿真可仿真城市级交通流量状况，计算性能高，仿真区域面积大；中观仿真可仿真车道级别的的单个交通参与者，能准确、灵活地反映各种道路和交通条件的影响，适合规模适中的场景；微观仿真提供高保真的实时数字孪生场景，达到以假乱真的效果。

## 能力特点
* 实现交通流数据可视化呈现，形成实时的交通热力图，以寻找控制全局交通流量的最佳方法。
* 利用路测摄像头获取的实时道路监控影像，通过目标检测、跟踪、再识别技术感知目标并进行状态估计，实现真实路面交通与虚拟环境的融合。可以将感知识别出的动态目标模型化，让实时交通流大数据映射到虚拟环境中，并生成大规模车道级仿真，以此实现城市交通流实时仿真，并进行未来模拟和推演，为全区域交通管理调度和优化提供支持。
* 提供从数据采集、数据解算、场景制作、性能测试和优化等一整套三维重建综合解决方案，保证局部场景的绝对位置精确，并基于UE4的渲染引擎提供高逼真的渲染效果，实现对场景的高度还原。在数字孪生的世界中，自由模拟各种天气状态，评估其带来的影响，为智慧交通运营管理提供决策依据。

## 功能设计
* 监控：对城市区域整体的交通状况进行检测，以关键指标及动态车流为展示方式。拥有分钟级的数据更新频次，可帮助用户快速寻找拥堵点，及时分析拥堵成因。
* 预测：对未来短期的区域交通状况进行预测，为客户提供未来拥堵路口、路段排名，为提前制定交通管理方案提供有力支持。
* 交通仿真：
事件推演仿真：推演在某事件（事故、流动施工等占道事件）的影响下，经过道路的车辆轨迹变化。
* 智能信控：通过对比不同信控方案应用下，经过周边道路的车辆轨迹，分别在不同方案下的车流计算周边道路关键指标，用以协助用户对比优化结果。
* 管控策略仿真：对于会涉及大量人员或车辆流动的大型事件，如体育赛事、重大会议、疫情防控等，需要采取相应的交通管控措施以避免出现严重拥堵。支持设置的管控措施有限速（设定最高时速）、限流（设定最大通行流量）、封闭道路等。
* 综合仿真：支持多种仿真应用相结合，以适应多变复杂的线下场景。如结合事件推演和管控策略仿真用以验证所制定方案的合理性，从而更好的降低事件的影响。


## 页面设计
三个前端页面：宏观（地图）、中观（路网）、微观（场景）。

[宏观](https://ibb.co/XFdXmY8) ：1. 嵌入在线地图；2. 离线地图服务搭建；3. 宏观流量仿真，前端精简地图和卫星影像以热力图形式展示车流量大小；

[中观](https://ibb.co/bByHR0N) ：岳麓区路网建模的可视化：RoadRunner、虚幻引擎；

[微观](https://ibb.co/RCpXrcj) ：局部路网仿真，前端对接虚幻引擎像素流。


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

相关软件和数据位于[链接](https://pan.baidu.com/s/1n2fJvWff4pbtMe97GOqtvQ?pwd=hutb) 下。
```text
matlab_2022b_win_run.zip 为matlab运行版本。

RoadRunner_2022b_运行bin.win64.AppRoadRunner.exe_激活文件为license.lic.zip 为RoadRunner的运行版本，

RoadRunner.zip 为RoadRunner工程，

虚幻引擎/AutoVrtlEnv_接受到虚幻引擎的相机数据_2023-3-17 175651.zip 为虚幻引擎工程（需要从matlab中打开）

parking 文件夹为停车管理系统的相关软件

crossrods 交叉路口视频

osm OpenStreetMap相关数据
```

1. 安装虚幻引擎4.26。

2. Matlab安装连接虚幻引擎的插件：
```markdown
uiopen('{REPOSITORY_PATH}\utils\mlpkginstall\adtunrealengine4.mlpkginstall',1)
```

3. 下载百度网盘中的文件`虚幻引擎/AutoVrtlEnv_接受到虚幻引擎的相机数据_2023-3-17 175651.zip`并解压到目录`C:/buffer`。

4. 安装虚幻引擎4.26后，在`matlab`中运行脚本以下脚本：
```commandline
main.mlx
```
5. 运行后等待出现"In Unreal Editor, select 'Play' to view the scene"后再在虚幻编辑器中点击“运行”。

## 贡献指南
在进行代码之前，请阅读 [贡献指南](https://github.com/OpenHUTB/bazaar/blob/master/CONTRIBUTING.md) 文档。


## 虚幻引擎配置
1. [为自定义场景安装支持包](https://ww2.mathworks.cn/help/releases/R2022a/driving/ug/install-and-configure-support-package-for-customizing-scenes.html) 。


# 内容

## 场景建模
基于RoadRunner和虚幻引擎进行场景的建模，任务包括：
1. 建模湖南工商大学和咸嘉新村及周围的道路；
2. 使用虚幻引擎建模桐梓坡路和西二环交叉的十字路口；
3. 建模岳麓区的主干道；
4. [从车道检测和 OpenStreetMap 生成车道级场景](https://ww2.mathworks.cn/help/driving/ug/build-high-definition-road-scene-from-lane-detections-and-openstreetmap.html) ；



## 局部路网建模
基于RoadRunner和虚幻引擎进行场景的建模，任务包括：
1. 检测单个摄像头的图像，并显示和返回检测结果；
2. 配置4个方向的摄像头，进行车辆的检测、定位和再识别；
3. 计算红绿灯的配时方案，并进行红绿灯的设置；
4. [插入车辆](https://ww2.mathworks.cn/help/releases/R2022b/driving/ref/drivingscenario.vehicle.html) ，测试车辆按地图选点进行移动，看到红灯停、绿灯行，以及避让等功能；
5. 加入更多的车辆进行交通拥堵的模拟；
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

1. 生成场景中所有车辆无碰撞的路径规划信息和配速信息（[参考链接](https://github.com/OpenHUTB/driving/tree/master/traffic/automatic_scenario_generation) ）；
2. 根据百度地图车流量的统计信息生成每个车辆位置和速度信息并实时更新到roadrunner路网；
3. 态势感知，根据roadrunner路网上每个车辆及统计信息生成交通流量和拥堵的热力图信息；
4. 根据预测的车流量拥堵信息，重新生成各个车辆的路径规划，降低拥堵情况；
5. 根据实景图检测车道线位置，并生成到车道级路网信息（[参考链接](https://ww2.mathworks.cn/help/driving/ug/build-high-definition-road-scene-from-lane-detections-and-openstreetmap.html) ）；
6. 增加一条不存在的路，统计对车流量和拥堵情况的影响；
7. 多路口绿波通行方案模拟；
8. 模拟车辆各种驾驶行为特征，比如超速行驶，变道，加塞，闯红绿灯，酒后驾驶，疲劳驾驶，红绿灯停止，礼让行人、礼让车辆，跟车，路径跟随等（[参考链接](https://github.com/OpenHUTB/driving/tree/master/roadrunner/Assets/Vehicles/Behavior) ）；

参考[自动场景生成](https://ww2.mathworks.cn/help/driving/ug/automatic-scenario-generation.html) 、[从车道检测和 OpenStreetMap生成高精度场景](https://ww2.mathworks.cn/help/driving/ug/build-high-definition-road-scene-from-lane-detections-and-openstreetmap.html) ，构建长沙岳麓区路网仿真模型。



# 贡献者

## 局部场景仿真
张卫  [champion123456](https://github.com/champion123456) ：局部高保真场景联动仿真

李诗帆 [q894749380](https://github.com/q894749380) ：多目标跟踪和场景感知

李豪军 [q894749380](https://github.com/q894749380) ：虚幻引擎局部交通仿真场景的精细化

李权龙 ：进行场景元素建模

蒋平平 [haiping-jpp](https://github.com/haiping-jpp) ：目标检测跟踪和车辆的定位与场景注入

蒋芳雪 [jfangx123](https://github.com/jfangx123) ：局部高仿真场景联动

## 路网和车流仿真 

杨子仪 [yangziyi](https://github.com/Gloria-ziyiyang) ：岳麓区OpenStreetMap数据清洗和路网仿真

刘子涵 [liuzihan888](https://github.com/liuzihan888) ：爬取百度地图全景图片和采集车对应的经纬度（静态路网建模） 

王磊 [wanglei](https://github.com/WLei1212115) ：车道线检测并合并到路网场景中（静态路网建模） 

张未来 [randomforest1111](https://github.com/randomforest1111) ：OpenStreetMap路网数据清洗和静态路网建模和仿真

邹岱[zoudai](https://github.com/zoudai) ：静态路网建模和与真实路网差异的校正

刘璐 [liulu](https://github.com/Aal-izzwell) ：车辆加入路网场景的车流量建模

冯颖[fengying](https://github.com/fengying5201107) ：实时路网数据采集和动态车流量校正和态势感知

邓梓睿[dengzirui](https://github.com/D-kistch)：车道线检测并合并到路网场景中（静态路网建模）  

陈凤英[xiaolaihuohu](https://github.com/xiaolaihuohuo)：静态路网建模

李一骁[YixiaoLee](https://github.com/Requester7):红绿灯静态建模(红绿灯数据爬取)
## 系统开发 

程昌理：交通系统微观、中观、宏观的后端开发

王海东 [donghaiwang](https://github.com/donghaiwang) ：局部场景和路网的建模的部分开发和对接

肖鹏飞 [feipengxiao](https://github.com/jiandaoshou-aidehua) ：完成matlab控制roadrunner，和roadrunner（包括虚幻引擎）进行协同仿真



