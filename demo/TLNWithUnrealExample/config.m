% 参考：https://blog.csdn.net/weixin_42670330/article/details/122099753
clear; clc;

% 第二步 将matlab自带的ue4 文件和ue4插件包拷贝出来
% 1，指定包含项目的支持包文件夹的路径。如果以前下载了支持包，请仅指定最新的下载路径，如此处所示。还要指定要在其中复制项目的本地文件夹目标。此代码指定的本地文件夹为 ：C:\Loca
% 看代码和官方注释 这段代码作用是要就创建两个变量 一个变量是ue4插件包的路径 一个是ue4项目的路径

% supportPackageFolder = fullfile( ...
%     matlabshared.supportpkg.getSupportPackageRoot, ...
%     "toolbox","shared","sim3dprojects","driving");
localFolder = "C:\project";


% 2，将项目从支持包文件夹复制到本地目标文件夹，项目名为 AutoVrtlEnv1
projectFolderName = "AutoVrtlEnv";
projectSupportPackageFolder ="C:\ProgramData\MATLAB\SupportPackages\R2022b\toolbox\shared\sim3dprojects\spkg\project";
% RRScenes路径：              C:\ProgramData\MATLAB\SupportPackages\R2022b\toolbox\shared\sim3dprojects\driving\RoadRunnerScenes
projectLocalFolder = fullfile(localFolder,projectFolderName);

if ~exist(projectLocalFolder,"dir")
    copyfile(projectSupportPackageFolder, projectLocalFolder);
end


%% 3，将UE4插件复制到虚幻编辑器的安装路径里

% 指定包含虚幻引擎安装的本地文件夹。此代码显示编辑器在 Windows 计算机上的默认安装位置。

ueInstallFolder = "C:\Program Files\Epic Games\UE_4.26";
% 将插件从支持包复制到UE4的Plugins文件夹中
support_package_root = fullfile( ...
    matlabshared.supportpkg.getSupportPackageRoot, ...
    "toolbox","shared","sim3dprojects","driving");
% C:\ProgramData\MATLAB\SupportPackages\R2022b\toolbox\shared\sim3dprojects\spkg\plugins\mw_simulation
supportPackageFolder = fullfile(fileparts(support_package_root), "spkg", "plugins", "mw_simulation");

mwPluginName = "MathWorksSimulation.uplugin";

mwPluginFolder = fullfile(supportPackageFolder, "MathWorksSimulation");
uePluginFolder = fullfile(ueInstallFolder,"Engine","Plugins");

uePluginDestination = fullfile(uePluginFolder,"Marketplace","MathWorks");

cd(uePluginFolder) 
foundPlugins = dir("**/" + mwPluginName);


if ~isempty(foundPlugins)
    numPlugins = size(foundPlugins,1);
    msg2 = cell(1,numPlugins);
    pluginCell = struct2cell(foundPlugins);

    msg1 = "Plugin(s) already exist here:" + newline + newline;
    for n = 1:numPlugins
        msg2{n} = "    " + pluginCell{2,n} + newline;
    end
    msg3 = newline + "Please remove plugin folder(s) and try again.";
    msg  = msg1 + msg2 + msg3;
    warning(mat2str(msg));
else
    copyfile(mwPluginFolder, uePluginDestination);
    disp("Successfully copied MathWorksSimulation plugin to UE4 engine plugins!")
end
% 这段代码意思就是我前文提到的 ：将matlab写的一个插件拷到UE4编辑器的插件文件夹下


