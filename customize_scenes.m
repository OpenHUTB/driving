
% 必须从Matlab中打开AutoVrtlEnv.uproject，否则会出现插件AutoVrtlEnv找不到的错误。
% 启动 -> Simlink 运行 （ -> 运行）

% https://ww2.mathworks.cn/help/driving/ug/customize-scenes-using-simulink-and-unreal-editor.html
% openExample('driving/VisualPerceptionIn3DSimulationExample')
% open_system('straightRoadSim3D')

% path = fullfile(fileparts(matlabroot), 'workspace', 'AutoVrtlEnv', 'AutoVrtlEnv.uproject');
path = fullfile('C:\buffer\AutoVrtlEnv', 'AutoVrtlEnv.uproject');
editor = sim3d.Editor(path);
open(editor);