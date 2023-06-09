function scenario = USCityBlock()
% createDrivingScenario Returns the drivingScenario defined in the Designer

% Generated by MATLAB(R) 9.9 (R2020b) and Automated Driving Toolbox 3.2 (R2020b).
% Generated on: 29-May-2020 10:25:57

% Construct a drivingScenario object.
scenario = drivingScenario;

% Add all road segments
roadCenters = [76.4 -110.5 -0.01;
    -22.6 -110.5 -0.01;
    -112.6 -110.5 -0.01;
    -184 -110.5 -0.01;
    -240.77 -110.5 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road');

roadCenters = [-240.77 0 0;
    -184.6 0 -0.01;
    -112.6 0 -0.01;
    -20.34 0 -0.01;
    76.4 0 -0.01];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road1');

roadCenters = [199 108 0;
    166.4 108 -0.01;
    74.58 108 -0.01;
    -20.38 108 -0.01;
    -112.6 108 -0.01;
    -202.6 108 -0.01;
    -242.15 108 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road2');

roadCenters = [166.4 -151.67 0;
    166.4 108 -0.01;
    166.4 148.33 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road3');

roadCenters = [76.4 104 -0.01;
    76.4 0 -0.01;
    76.4 -110.5 -0.01;
    76.4 -151.67 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road4');

roadCenters = [-22.6 -106.5 -0.01;
    -20.34 0 -0.01;
    -20.38 108 -0.01;
    -20.38 148.33 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(5, 'Width', [0.7125 4.5 3.75 3.75 0.7125], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road5');

roadCenters = [-112.6 148.33 0;
    -112.6 108 -0.01;
    -112.6 0 -0.01;
    -112.6 -110.5 -0.01;
    -112.6 -151.67 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road6');

roadCenters = [-202.6 148.33 0;
    -202.8 108 -0.01;
    -202.002 95.1997 -0.01;
    -201.701 85.396 -0.01;
    -201.118 75.0835 -0.01;
    -198.9 65.159 -0.01;
    -196.199 55.6373 -0.01;
    -192.877 45.9306 -0.01;
    -189.399 35.8963 -0.01;
    -186.874 25.9599 -0.01;
    -184.971 15.1573 -0.01;
    -184.6 0 -0.01;
    -184.6 -110.5 -0.01;
    -184.6 -151.67 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road7');

roadCenters = [72.1 148.33 0;
    72.1 112 -0.01];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road8');

roadCenters = [-22.6 -151.67 0;
    -22.5 -114.5 -0.01];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road9');

roadCenters = [76.4 -1.25 -0.01;
    199 -1.25 0];
marking = [laneMarking('Unmarked')
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid', 'Width', 0.13)
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 3.15], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road10');

roadCenters = [199 -112.5 -0.01;
    166.4 -112.5 -0.01;
    76.4 -110.5 -0.01];
marking = [laneMarking('Unmarked')
    laneMarking('Solid')
    laneMarking('Dashed', 'Width', 0.13, 'Length', 1.5, 'Space', 3)
    laneMarking('Solid')
    laneMarking('Unmarked')];
laneSpecification = lanespec(4, 'Width', [0.65 3.85 3.85 0.65], 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road11');

% Add the actors
actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [163.5 146.95 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [166.35 146.95 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier2');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [169.2 146.95 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier3');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [163.5 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier7');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [166.35 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier8');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [169.2 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier9');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 -109.65 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier11');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 -113 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier13');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 -115.34 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier14');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 2.9 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier18');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 0.05 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier19');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 -2.8 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier20');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-240.5 -107.65 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier21');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 110.9 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier22');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 -5.6 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier24');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 108.05 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier27');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [197.05 105.25 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier28');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-240.5 -110.5 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier31');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-240.5 -113.35 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier32');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-240.1 2.9 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier36');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-240.1 0.05 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier37');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-240.1 -2.8 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier38');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-242.15 110.9 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier43');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-242.15 108.05 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier44');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-242.15 105.25 0], ...
    'Yaw', 90, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier45');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [73.4 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier48');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [76.25 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier49');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [79.1 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier50');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-25.25 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier54');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-22.7 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier55');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-19.85 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier56');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-115.3 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier59');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-112.45 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier60');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-109.6 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier61');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [69.25 147.35 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier66');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [75.45 147.5 -0.15], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier68');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [72.45 147.5 -0.15], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier69');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-25.25 146.45 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier70');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-22.15 146.45 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier71');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-18.65 146.45 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier72');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-115.3 147.6 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier75');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-112.45 147.6 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier76');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-109.6 147.6 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier77');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-15.45 146.45 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier84');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-187.5 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier88');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-184.65 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier89');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-181.8 -150.15 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier90');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-205.6 147.4 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier94');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-202.75 147.4 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier95');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [-199.9 147.4 0], ...
    'Yaw', -180, ...
    'PlotColor', [195 210 215] / 255, ...
    'Name', 'Barrier96');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [44.15 -3.05 0], ...
    'Yaw', -50, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier101');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [39.15 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier102');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [41.95 -1.3 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier103');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [36.5 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier104');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [33.85 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier105');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [31.2 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier106');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [28.45 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier107');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [25.8 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier108');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [23.15 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier109');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [20.5 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier110');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [17.95 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier111');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [15.3 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier112');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [12.65 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier113');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [10 -0.55 0], ...
    'Yaw', 180, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier114');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [7.01 -1.38 0], ...
    'Yaw', -125, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier115');

actor(scenario, ...
    'ClassID', 5, ...
    'Length', 2.4, ...
    'Width', 0.76, ...
    'Height', 0.8, ...
    'Position', [4.75 -3.05 0], ...
    'Yaw', -125, ...
    'PlotColor', [227 99 97] / 255, ...
    'Name', 'Barrier116');

