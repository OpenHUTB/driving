
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

## 三维建模

