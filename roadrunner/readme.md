## 一、对于RoadRunner仿真使用

1.找到你的RoadRunner的资源地址存储地址。



2.然后将本项目导入打开即可 ,其中Scenes即为你的场景的地址存放，复制进去即可



3.再将额外补充的资产加入，也就是这里的XXXXXXX文件，放置到你的Assets



4.再使用RoadRunner打开即可（可查看使用图），并重新加载一下你的资产，在主界面的Assets--》点击Upgrade Asset Library即可。


![使用图](D:\RoadProject\driving\roadrunner\fig\使用图.png)

对于**HUTB-仅路网.rrecene**，**直接放置到你的Scenes中。再在RoadRunner打开即可，没有额外的材质补充**



## 二、关于Matlab与Unreal Engine（4.26版本）

1.关于环境配置可部分参考（[手把手超详细介绍MATLAB+RoadRunner+Unreal Engine自动驾驶联合仿真 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/335521741)）

​			本项目百度网盘地址进行下载安装再依据此方法进行配置即可。

> 注意对于本Visual Studio版本应该选择2019版本，不要用之前的AutoVrtlEnv.zip，直接用 AutoVrtlEnv_接受到虚幻引擎的相机数据_2023-3-17175651.zip

将需要的软件安装好之后进行环境配置（**关键步骤**）

**MATLAB插件安装**

**安装matlab支持包并配置环境**

1.在matlab主页选项卡，在环境部分找到附加功能，选择获取附加功能，这种方式不成功的话，直接进入官网进行下载安装 再拖拽进入Matlab页面即可。

​	下载地址（所有的附件库都可以在这里搜索并下载安装）：https://ww2.mathworks.cn/matlabcentral/fileexchange/107969-computer-vision-toolbox-model-for-yolo-v4-object-detection?s_tid=srchtitle_Yolo%20v4_1 下载**Vehicle Dynamics Blockset Interface for Unreal Engine 4 Projects**，**Automated Driving Toolbox interface for unreal Engine 4 Projects**

![matlab1](D:\RoadProject\driving\roadrunner\fig\matlab1.png)

2.关于进行环境配置可手动复制文件或者使用如下代码或者手动复制，可以使用代码，也可以手动复制。(参考地址：(https://blog.csdn.net/zidongjiashi/article/details/110520812))

```matlab
%% STEP1
% Specify the location of the support package project files and a local folder destination
% Note:  Only one path is supported. Select latest download path.
dest_root = "C:\Local";
src_root = fullfile(matlabshared.supportpkg.getSupportPackageRoot, ...
    "toolbox", "shared", "sim3dprojects", "automotive");

%% STEP2
% Specify the location of the Unreal Engine installation.
ueInstFolder = "C:\Program Files\Epic Games\UE_4.23";

%% STEP3
% Copy the MathWorksSimulation plugin to the Unreal Engine plugin folder.
mwPluginName = "MathWorksSimulation";
mwPluginFolder = fullfile(src_root, "PluginResources", "UE423"); % choose UE version
uePluginFolder = fullfile(ueInstFolder, "Engine", "Plugins");
uePluginDst = fullfile(uePluginFolder, "Marketplace", "MathWorks");

cd(uePluginFolder)
foundPlugins = dir("**/" + mwPluginName + ".uplugin");

if ~isempty(foundPlugins)
    numPlugins = size(foundPlugins, 1);
    msg2 = cell(1, numPlugins);
    pluginCell = struct2cell(foundPlugins);

    msg1 = "Plugin(s) already exist here:" + newline + newline;
    for n = 1:numPlugins
        msg2{n} = "    " + pluginCell{2,n} + newline;
    end
    msg3 = newline + "Please remove plugin folder(s) and try again.";
    msg  = msg1 + msg2 + msg3;
    warning(msg);
else
    copyfile(mwPluginFolder, uePluginDst);
    disp("Successfully copied MathWorksSimulation plugin to UE4 engine plugins!")
end

%% STEP4
% Copy the support package folder that contains the AutoVrtlEnv.uproject
% files to the local folder destination.
projFolderName = "AutoVrtlEnv";
projSrcFolder = fullfile(src_root, projFolderName);
projDstFolder = fullfile(dest_root, projFolderName);
if ~exist(projDstFolder, "dir")
    copyfile(projSrcFolder, projDstFolder);
end

```

**步骤一：**将AutoVrtlEnv文件夹复制到C:\Local文件夹中（自己创建）。此文件夹的默认目录为C:\ProgramData\MATLAB\SupportPackages\R2020b\toolbox\shared\sim3dprojects\automotive\AutoVrtlEnv.
**步骤二：**将MathWorksSimulation.uplugin文件复制到虚幻引擎工作目录中。C:\ProgramData（可能隐层了注意你自己电脑是否开启）\MATLAB\SupportPackages\R2020b\toolbox\shared\sim3dprojects\driving\PluginResources\UE423\MathWorksSimulation
在上述目录中找到文件并且复制到（经过测试：这个有可能每个人的不一样）
H:\xuhuanyinqing\UE_4.23\Engine\Plugins\Marketplace\MathWorks\MathWorksSimulation（此文件夹为虚幻引擎的安装文件夹，可自行寻找）
若无法找到MathWorksSimulation.uplugin文件，需要在“附加资源管理器”中搜索Automated Driving Toolbox Interface for Unreal Engine 4 Projects 获取并安装。安装之后就可以找到了这个文件了。



3.通过matlab打开虚幻引擎进行场景自定义。
上述工作完成后，在matlab命令窗口输入openExample(‘vdynblks/SceneInterrogationReferenceApplicationExample’)打开实例工程

![matlab2](D:\RoadProject\driving\roadrunner\fig\matlab2.png)

选择Simulation 3D Scene Configuration模块双击进入编辑界面，在scene source中选择Unreal Editor并在下面的project中选择

![matlab3](D:\RoadProject\driving\roadrunner\fig\matlab3.png)

C:\Local\AutoVrtlEnv目录下的AutoVrtlEnv.uproject

![matlab4](D:\RoadProject\driving\roadrunner\fig\matlab4.png)

点击Open Unreal Editor 即可打开虚幻引擎进行场景编辑。成功打开虚幻引擎即表示联合仿真环境配置成功。

![matlab5](D:\RoadProject\driving\roadrunner\fig\matlab5.png)

上面就是先对你环境以及基本逻辑的了解，后面将学习自己创建的RoadRunner项目导出到UE与Matlab联动。

​			先学习一下这里的(https://zhuanlan.zhihu.com/p/335521741)后面将本项目的实践再上传

**3.2 新建Unreal工程，安装Unreal的RoadRunner插件开始学起**
