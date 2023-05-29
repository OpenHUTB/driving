


# 路网仿真
## 数据
[手动导出道路数据链接](https://www.openstreetmap.org/) 

[最新中国道路数据](https://download.geofabrik.de/asia/china-latest.osm.bz2)
[.osm.pdf](http://download.geofabrik.de/asia/china-latest.osm.pbf)

[根据城市名获取城市ID](https://nominatim.openstreetmap.org/ui/search.html) 

岳麓区：7985081165

长沙市：3202711

湖南省：913073

[通过ID获得边界](http://polygons.openstreetmap.fr/)


[从一个更大的区域获得osm文件](https://github.com/JamesChevalier/cities) 
```commandline
osmosis --read-pbf-fast file="china-latest.osm.pbf" --bounding-polygon file="changsha_poly.txt" --write-xml file="changsha.osm"
```


# 教程
[在 OpenStreetMap 底图上显示数据](https://ww2.mathworks.cn/help/driving/ug/display-data-on-openstreetmap-basemap.html)

[将 OpenStreetMap 数据导入驾驶场景](https://ww2.mathworks.cn/help/driving/ug/import-openstreetmap-data-into-driving-scenario.html) 


# 示例

[智能交通灯控制](https://github.com/MuhammedMegz/Smart-Traffic-light-control)

https://github.com/Baazigar007/Smart-Traffic-Light


[使用虚幻引擎的交通信号灯协商](https://ww2.mathworks.cn/help/driving/ug/traffic-light-negotiation-with-unreal-engine-visualization.html) 


[交叉路口交通灯协商](https://ww2.mathworks.cn/help/driving/traffic-negotiation-at-intersections.html?s_tid=srchtitle_Traffic%20Light%20Negotiation_9) 


[matlab交通信号灯比赛](https://github.com/mathworks/MathWorks-Excellence-in-Innovation/tree/main/projects/Traffic%20Light%20Negotiation%20and%20Perception-Based%20Detection)




