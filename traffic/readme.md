


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

## OpenStreetMap
[将OpenStreetMap导入虚幻引擎](https://github.com/ue4plugins/StreetMap) 

[将OpenStreetMap导入mysql数据库](https://wiyi.org/importing-osm-into-mysql.html)

[OpenStreetMap数据编辑器](https://wiki.openstreetmap.org/wiki/JOSM) 

[基于OpenStreetMap的安卓应用](https://github.com/osmdroid/osmdroid)

[基于OpenStreetMap的搜索](https://github.com/osm-search/Nominatim) 

[基于OpenStreetMap的路由引擎](https://github.com/valhalla/valhalla) 





