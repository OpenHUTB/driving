
# 离线地图服务搭建
场景范围：
```text
(112.7963, 28.1640)
(112.9607, 28.2621)
```

## 离线卫星影像

1. 使用 [地图下载器](https://gitee.com/CrimsonHu/java_map_download) 下载切片。

2. 通过python工具 mb-util转为 mbtiles格式。

3. 通过[geoserver](https://mapserver.org/download.html) 发布mbtiles。


## 三维场景构建
[卫星图像建筑检测](https://github.com/motokimura/spacenet_building_detection)

[matlab 卫星影像目标检测](https://ww2.mathworks.cn/help/vision/ug/object-detection-in-large-satellite-imagery-using-deep-learning.html)

[可以飞行的三维地球仪](https://github.com/google/earthenterprise)

[谷歌三维卫星地图模式](https://github.com/retroplasma/earth-reverse-engineering) 

[Blender导入谷歌地球的插件](https://github.com/imagiscope/EarthStudioTools) 

