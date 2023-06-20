


# 路网仿真
## 数据
[手动导出道路数据链接](https://www.openstreetmap.org/) 

[最新中国道路数据](https://download.geofabrik.de/asia/china-latest.osm.bz2)
[.osm.pdf](http://download.geofabrik.de/asia/china-latest.osm.pbf)

[根据城市名获取城市ID](https://nominatim.openstreetmap.org/ui/search.html)

长沙市：3202711

湖南省：913073

[通过ID获得边界](http://polygons.openstreetmap.fr/)


[从一个更大的区域获得osm文件](https://github.com/JamesChevalier/cities) 
```commandline
osmosis --read-pbf-fast file="china-latest.osm.pbf" --bounding-polygon file="changsha_poly.txt" --write-xml file="changsha.osm"
```

```commandline
osmosis --read-pbf-fast file="china-latest.osm.pbf" --bounding-polygon file="yuelu_poly.txt" --write-xml file="yuelu.osm"
```

```commandline
osmosis --read-pbf-fast file="china-latest.osm.pbf" --bounding-polygon file="data/street_poly.txt" --write-xml file="data/street_yuelu.osm"
```


# 教程
[在 OpenStreetMap 底图上显示数据](https://ww2.mathworks.cn/help/driving/ug/display-data-on-openstreetmap-basemap.html)

[驾驶场景设计器](https://ww2.mathworks.cn/help/driving/ref/drivingscenariodesigner-app.html)

[将 OpenStreetMap 数据导入驾驶场景](https://ww2.mathworks.cn/help/driving/ug/import-openstreetmap-data-into-driving-scenario.html) 

[使用 OpenStreetMap 数据构建 RoadRunner 道路](https://ww2.mathworks.cn/help/releases/R2022a/roadrunner/ug/build-roads-using-openstreetmap-data.html)


# 示例

[智能交通灯控制](https://github.com/MuhammedMegz/Smart-Traffic-light-control)

https://github.com/Baazigar007/Smart-Traffic-Light


[使用虚幻引擎的交通信号灯协商](https://ww2.mathworks.cn/help/driving/ug/traffic-light-negotiation-with-unreal-engine-visualization.html) 


[交叉路口交通灯协商](https://ww2.mathworks.cn/help/driving/traffic-negotiation-at-intersections.html?s_tid=srchtitle_Traffic%20Light%20Negotiation_9) 


[matlab交通信号灯比赛](https://github.com/mathworks/MathWorks-Excellence-in-Innovation/tree/main/projects/Traffic%20Light%20Negotiation%20and%20Perception-Based%20Detection)


# 开发
## OpenStreetMap
[资源列表](https://github.com/osmlab/awesome-openstreetmap)

[将OpenStreetMap导入虚幻引擎](https://github.com/ue4plugins/StreetMap) 

[从OpenStreetMap数据渲染3D场景](https://github.com/RodZill4/godot-openstreetmap)

[将OpenStreetMap导入mysql数据库](https://wiyi.org/importing-osm-into-mysql.html)

[OpenStreetMap数据编辑器](https://wiki.openstreetmap.org/wiki/JOSM) 

[基于OpenStreetMap的安卓应用](https://github.com/osmdroid/osmdroid)

[离线苹果和安卓应用](https://github.com/mapsme/omim) 

[基于OpenStreetMap的搜索](https://github.com/osm-search/Nominatim) 

[基于OpenStreetMap的路由引擎](https://github.com/valhalla/valhalla) 

[基于docker的OpenStreetMap瓦片服务器](https://github.com/geo-data/openstreetmap-tiles-docker)

[基于matlab的最短路径](https://github.com/johnyf/openstreetmap)

[街道网络的分析](https://github.com/gboeing/osmnx)

[交通规划与模拟](https://github.com/a-b-street/abstreet)

[用Python绘制好看的地图](https://github.com/marceloprates/prettymaps)

[数据清洗](https://github.com/iPhiliph/Data-Wrangling-OpenStreetMap)

[Python API](https://github.com/metaodi/osmapi)

[使用OpenStreetMap特征和卫星影像训练深度网络](https://github.com/trailbehind/DeepOSM) 


## 地图
[百度街景地图爬虫](https://blog.csdn.net/ZMT1849101245/article/details/88242232)


## 交通仿真
[大型网络交通仿真](https://sumo.dlr.de/docs/) 

[使用模块化车辆和路口控制器仿真简单的交通场景](https://github.com/mathworks/OpenTrafficLab)

[基于模型的的自动驾驶交通仿真框架](https://github.com/MOBATSim/MOBATSim) 



