function scenario = helperOSMImport(bbox)
% helperOSMImport 从OpenStreetMap导入MCity测试工具的道路网络 
%   使用指定的边界框坐标，该函数从OpenStreetMap下载数据，
%   并返回一个 drivingScenario 对象，该对象包含Mcity测试工具的路网。
%   matlab\examples\driving\main\helperOSMImport.m

% 将几何边界框坐标原点与 Mcity 地图原点同步
originLat = 42.299847;
originLon = -83.698854;

% 边界框经纬度限制
minLat =  bbox(1,1);  % 最小经度
maxLat =  bbox(1,2);  % 最大经度
minLon = bbox(2,1);   % 最小纬度
maxLon = bbox(2,2);   % 最大纬度

% 获取OpenStreetMap XML
url = ['https://api.openstreetmap.org/api/0.6/map?bbox=' ...
    num2str(minLon, '%.10f') ',' num2str(minLat, '%.10f') ',' ...
    num2str(maxLon, '%.10f') ',' num2str(maxLat, '%.10f')];
fileName = websave("drive_map.osm", url,weboptions("ContentType", "xml"));  % 下载

% 创建一个驾驶场景
importedScenario = drivingScenario;
% 导入 OpenStreetMap 路网
roadNetwork(importedScenario, "OpenStreetMap", fileName);

% 将边界框的形心转换到局部笛卡尔坐标
[tX,tY,tZ] = latlon2local(originLat, originLon,...
    0, importedScenario.GeoReference);  % 将地理坐标转换为局部笛卡尔坐标
% 变换矩阵
tf = [tX,tY,tZ];

% 根据边界框质心，使用 Shifted RoadCenters 将获取的场景映射到新场景中
scenario = drivingScenario;
roadInfo = variantgenerator.internal.getRoadInfoFromScenario(importedScenario);

% 特定场景MCity的预处理
if(minLon < originLon || maxLon > originLon || ...
        minLon < originLat || maxLat > originLat)

    for index = 1 : size(roadInfo, 2)
        rn = roadInfo(index).RoadName;

        % 将道路中心或地图转换成所需的原点
        roadCenters = roadInfo(index).RoadCenters - tf;

        % 将 Roundabout 更改为单车道
        if(rn == "453870095" || rn == "453870101")
            ls = lanespec(1); % 单车道
        else

            % 从 Mcity 地图跳过“Access drive”道路
            if(rn == "Access Drive")
                continue
            end
            % OSM 的相同车道规范
            ls = roadInfo(index).LaneSpecification;
        end

        % 使用 Name 和 Lane Specification 创建道路
        road(scenario, roadCenters, "Lanes", ls , "Name", rn);
    end
end
scenario.VerticalAxis = "Y";
end