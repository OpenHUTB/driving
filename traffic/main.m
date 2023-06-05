
% 导入场景
sc = hutb_scenario;

% 将场景导入到驾驶场景设计器中
drivingScenarioDesigner(sc);

%% 
ac = sc.Actors;

actorProfiles(sc)