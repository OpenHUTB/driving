%% 在 OpenStreetMap 底图上显示数据
% <https://ww2.mathworks.cn/help/driving/ug/display-data-on-openstreetmap-basemap.html> 
% 此示例说明如何在OpenStreetMap ® 底图上显示行驶路线和车辆位置。
% 将OpenStreetMap底图添加到可用于|geoplayer|对象的底图列表中。
% 添加底图后，您无需在以后的会话中再次添加。

name = 'openstreetmap';  % 底图的名字
url = 'https://a.tile.openstreetmap.org/${z}/${x}/${y}.png';
copyright = char(uint8(169));
attribution = copyright + "OpenStreetMap contributors";
% 为osm路网添加底图。
addCustomBasemap(name, url, 'Attribution', attribution)

%% 
% 加载一系列纬度和经度坐标。
data = load('geoRoute.mat');

%% 
% 创建一个地理播放器。
% 将地理播放器置于行车路线的第一个位置的中心，并将缩放级别设置为 12。
zoomLevel = 12;
player = geoplayer(data.latitude(1), data.longitude(1), zoomLevel);

%% 
% 显示完整路线。
plotRoute(player,data.latitude,data.longitude);

%% 
% |'streets'|默认情况下，地理播放器使用Esri® 提供的世界街道地图底图 ( )。
% 更新地理播放器以改为使用添加的OpenStreetMap底图。
player.Basemap = 'openstreetmap';

%% 
% 再次显示路线。
plotRoute(player,data.latitude,data.longitude);

%% 
% 按顺序显示车辆的位置。
for i = 1:length(data.latitude)
   plotPosition(player,data.latitude(i),data.longitude(i))
end
