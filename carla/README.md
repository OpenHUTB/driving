# Carla


## 环境配置
[将虚幻引擎项目渲染输出从本地网络流送到浏览器和移动设备](https://docs.unrealengine.com/4.26/zh-CN/SharingAndReleasing/PixelStreaming/PixelStreamingIntro/) 。

碰到 `Streamer disconnected` 或者浏览器访问时的`Crash`问题请参考[链接](https://blog.csdn.net/m0_55173487/article/details/126231595) 。 

[将过场动画序列渲染成视频文件并保存在电脑上](https://docs.unrealengine.com/4.26/zh-CN/AnimatingObjects/Sequencer/Workflow/RenderAndExport/RenderMovies/) 


## 像素流
驾驶场景设计器增加转发像素流参数的位置：
```shell
matlab\toolbox\shared\drivingscenario\+driving\+scenario\+internal\GamingEngineScenarioAnimator.m -> setupCommandReaderAndWriter(this)
```

simulink模块增加转发像素流参数的位置：
```shell
matlab\toolbox\shared\sim3d\sim3d\+sim3d\World.m -> asCommand(self)
```

## 交通管理程序
交通管理程序的说明[手册](https://carla.readthedocs.io/en/latest/adv_traffic_manager/) 。


## 关卡切换

[多关卡的无缝切换](https://docs.unrealengine.com/4.26/zh-CN/InteractiveExperiences/Networking/Travelling/) 。


## 学习

[UE4初学者系列教程合集-全中文新手入门教程](https://www.bilibili.com/video/BV164411Y732/?share_source=copy_web&vd_source=d956d8d73965ffb619958f94872d7c57)

[ue4官方文档](https://docs.unrealengine.com/4.26/zh-CN/)

[为虚幻编辑器准备自定义车辆网格](https://ww2.mathworks.cn/support/search.html/videos/preparing-custom-vehicle-mesh-for-the-unreal-editor-1645163589268.html) 


## 问题

`WindowsNoEditor\CarlaUE4\Content\Carla\Maps\OpenDrive\hutb_test.xodr`拷贝到`WindowsNoEditor\CarlaUE4\Content\RoadRunner\Maps\OpenDrive`（没有的话就新建）。