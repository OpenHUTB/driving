%% 将OpenStreetMap数据导入驾驶场景
% <https://ww2.mathworks.cn/help/driving/ug/import-openstreetmap-data-into-driving-scenario.html>
% OpenStreetMap ®是一种免费的开源网络地图服务，使您能够访问众包地图数据。
% 使用Driving Scenario Designer应用程序，您可以从 OpenStreetMap 导入地图数据，
% 并使用它为您的驾驶场景生成道路。

% 本示例重点介绍在应用程序中导入地图数据。
% 或者，要将 OpenStreetMap 道路导入drivingScenario对象，
% 请使用该 roadNetwork 函数。


%% 选择OpenStreetMap文件
% 要导入道路网络，您必须首先选择一个包含该网络道路几何图形的 OpenStreetMap 文件。要从 导出这些文件openstreetmap.org，请指定地图位置，手动调整此位置周围的区域，然后将该区域的道路几何图形导出到扩展名为 的 OpenStreetMap .osm。仅导出全长在此指定区域内的道路。在此示例中，您选择了之前从该网站导出的 OpenStreetMap 文件。
% 
% 1. 打开Driving Scenario Designer 应用程序。
drivingScenarioDesigner
% 2. 在应用程序工具条上，选择导入，然后选择 OpenStreetMap。
% 
% 3. 在OpenStreetMap Import 对话框中，浏览此文件， 您的 MATLAB ®matlabroot文件夹的根目录位于：

