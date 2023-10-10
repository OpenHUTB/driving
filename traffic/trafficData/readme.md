# Matlab函数打成Jar类库

1、将trafficData2.m脚本在MATLAB R2022b中打开

2、打包Java类库，在**APP**中点击 **Library Compiler**(应用程序部署行)

3、在 **Library Compiler**中，**TYPE**栏选择**Java Package**；**EXPORTED FUNCTIONS**栏选择trafficData2.m。

4、根据需求修改Jar的名称和类名名称。

5、点击右上角**Package**打包即可。

6、打包完成后打开打包后的文件夹，其中**for_redistribution_files_only**文件夹下的**Jar**就是我们打包后的类库，在我们自己的Java应用中引用这个类库即可

7、此类库需要安装**matlab r2022b MCR**配合使用。对应链接(https://blog.csdn.net/shirukai/article/details/123641588)



## 