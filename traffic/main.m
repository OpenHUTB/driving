
addpath('automatic_scenario_generation');
%% 
% 导入岳麓区的路网
minLat =  28.1625;
maxLat =  28.2587;
minLon = 112.7911;
maxLon = 112.9604;
bbox = [minLat maxLat;minLon maxLon];


%% 

% 导入场景
sc = hutb_scenario;

% 将场景导入到驾驶场景设计器中
drivingScenarioDesigner(sc);

%% 
ac = sc.Actors;

actorProfiles(sc)